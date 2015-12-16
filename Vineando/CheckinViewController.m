//
//  CheckinViewController.m
//  Vineando
//
//  Created by Jose Adame on 23/08/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "CheckinViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "RestEngine.h"
#import "Utils.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>

@interface CheckinViewController (){

    UIView *vistalogros;

}

@end

@implementation CheckinViewController 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _comentarioText.delegate=self;
    
    _nombreVinoLabel.text=[datosVino objectForKey:@"nombre"];
    _tipoVinoLabel.text=[datosVino objectForKey:@"tipovino"];
    _anioVinoLabel.text=[datosVino objectForKey:@"anio"];
    _puntuacionLabel.text=[NSString stringWithFormat:@"%.2f",[datosVino[@"notamedia"] floatValue]];

    
    NSString *url = [NSString stringWithFormat:@"%@",[datosVino objectForKey:@"rutaimagen"]];
    
    
    
    [_imagenVino setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    
    
    //lo metemos en otro hilo para que no interrumpa la experiencia del usuario.
   dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self obtenerFechaUltimaCata];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textViewShouldReturn:(UITextField *)textField
{
    [_comentarioText resignFirstResponder];
    
    return YES;
}


- (IBAction) sliderValueChanged:(UISlider *)sender {
    _puntuacionLabel.text = [NSString stringWithFormat:@" %.1f", [sender value]];
}



- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"¿Que te ha parecido este vino? "]) {
        
    
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
        return YES;
    }
    else{
    
        return YES;
    
    }
    
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"¿Que te ha parecido este vino? ";
        [textView resignFirstResponder];
    }
}




//Este metodo oculta el teclado cuando pulsamos el boton DONE del teclado.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}




//Metodo para obtener la fecha de la ultima cata del vino por el usuario.
-(void)obtenerFechaUltimaCata{

    // llamamos al servicio para recuperar las listas del usuario.
    //recuperamos el id del usuario para buscar sus listas.
    NSDictionary *usuario = ApplicationDelegate.usuario;
    NSString *url = [NSString stringWithFormat:@"vino/cata/%@/%@",[datosVino objectForKey:@"idvino"],[usuario objectForKey:@"id"]];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
        
        
           
            
           dispatch_async(dispatch_get_main_queue(), ^{  
               
              
               [self mostrarFechaUltimaCata:responseData];
            //lanzamos el metodo que muestra la notificacion al usuario abajo de la pantalla.
            
          });
        
      
        
    }
    else{
        
         dispatch_async(dispatch_get_main_queue(), ^{          Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
        // [activityIndicator stopAnimating];
         });
    }
    
    
    
    
    
    
 


}



-(void)mostrarFechaUltimaCata:(NSString*)texto{

    //NSDictionary *notificacion = [notificaciones objectAtIndex:0];
    
    
    
    CGRect vistabounds = self.view.bounds;
    
    CGPoint origen= vistabounds.origin;
    // CGSize size=vistabounds.size;
    
    CGRect bounds = CGRectMake(origen.x+40, origen.y+40,240,250);
    
    
     vistalogros =[[UIView alloc]initWithFrame:bounds];
     //vistalogros.layer.cornerRadius=10;
    [vistalogros setBackgroundColor:[UIColor blackColor]];
    
    
    [vistalogros setFrame:CGRectMake( self.view.bounds.origin.x,self.view.bounds.size.height-40,self.view.bounds.size.width,40)];
    [vistalogros setAlpha:0.9];
    vistalogros.layer.cornerRadius=0;
    [self.view addSubview:vistalogros];
    
    
    CGRect labelFrame = CGRectMake( vistalogros.bounds.origin.x+20, vistalogros.bounds.origin.y, vistalogros.bounds.size.width, 30 );
    UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setBackgroundColor:[UIColor clearColor]];
    NSString *titulo=texto;
    
    [label setText:titulo];
    [label setTextColor: [UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"Avenir-Black" size:12]];
    [vistalogros addSubview: label];
    
    //añadimos el gesturerecognizer para poder cerrar la vista pulsando sobre ella.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cerrarVistaLogros:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [vistalogros addGestureRecognizer:tap];








}



-(void)setDatosVino:(NSDictionary*)datos{
    
    datosVino=datos;
    
    
}



//Este metodo se encarga de controlar la pulsacion del usuario sobre la vista de logros cerrandola con una animacion del tipo
//fade out.
-(void)cerrarVistaLogros:(UIGestureRecognizer *)gestureRecognizer{
    
    
    //eliminamos la vista de los logros.
    // [vistaLogros removeFromSuperview];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^ {
                         vistalogros.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished) {
                         [vistalogros removeFromSuperview];
                         
                     }];
    
    
    
    
}



-(void)doSeleccion:(NSDictionary *)datosEstablecimiento{

// aqui recogemos el establecimiento seleccionado en la lista de establecimientos de la anterior pantalla.

    NSLog(@"hemos entrado");





}



@end


