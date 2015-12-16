//
//  NuevoComentarioViewController.m
//  Vineando
//
//  Created by Jose Adame on 10/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "NuevoComentarioViewController.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "RestEngine.h"
#import "RespuestaREST.h"
#import <QuartzCore/QuartzCore.h>

@interface NuevoComentarioViewController ()

@end

@implementation NuevoComentarioViewController{

    UIView *vistalogros;
}

@synthesize textView;


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
    
    
    
    [textView becomeFirstResponder];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//metodo que realiza la funcion de enviar el comentario escrito por el usuario.
- (IBAction)enviarComentario:(id)sender {
    
    if ([textView.text length]>2000) {
        
        Utils *util = [[Utils alloc]init];
        [util alertStatus:@"Comenario incorrecto" titulo:@"Hay demasiados caracteres"];

        
        
        
    }
    else{
    
        [textView resignFirstResponder];
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.tag=7;
        [self.view addSubview:HUD];
        HUD.delegate=self;
        HUD.labelText=@"Enviando...";
        [HUD showWhileExecuting:@selector(doEnvio) onTarget:self withObject:nil animated:YES];
        
    
    
    
    
    }
    
    
    
    
    
    
    
    
}


-(void)doEnvio{
    
   
    
    //recuperamos el usuario
     NSDictionary *usuario = ApplicationDelegate.usuario;    

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[usuario objectForKey:@"id"],@"idusuario",textView.text, @"comentario",nil];
    
                         
                         
                         
    //convertimos a formato json.
    NSString *post = [dic JSONString];
    
    NSString *url = [NSString stringWithFormat:@"vino/comentarios/%d",idvino];
    
    //creamos la instancia de RestEngine para las comunicaciones.
    RestEngine *rest = [[RestEngine alloc]init];
    
    //llamamos al webservice y obtenemos la respuesta.
    RespuestaREST   *respuestaREST = [rest llamarServicioREST:post url:url];
    
    
    
    //evaluamos la respuesta.
    if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
    {
        NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        NSDictionary *respuestaComentario = [responseData objectFromJSONString];
        NSString *status = [respuestaComentario objectForKey:@"status"];
        NSLog(@"hemos deserializado %@",status);
       
        
        if ([status isEqualToString:@"OK"])
        {
            //si todo ha ido bien hay que mostrar los logros si los hubiera y la puntuación obtenida.
            //guardamos las notificaciones en un NSMutableArray
            
            NSMutableArray *notificaciones = [respuestaComentario objectForKey:@"notificaciones"];
            
            
            
            //mostramos una vista con las notificaciones o puntuaciones obtenidas.
            [self mostrarVistaNotificaciones:notificaciones];
           
            
            
        }
        else{
            
            Utils *utilidad = [[Utils alloc] init];
            [utilidad alertStatus:status titulo:@"Ha fallado el envio del comentario"];
            [HUD hide:YES];
                       
        }
        
        
    }
    else{
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
        [HUD hide:YES];
        
    }
    
    



}



-(void)mostrarVistaNotificaciones:(NSMutableArray *)notificaciones{
    
    //El tamaño de la vista sera el total el tamaño de la vista que la contiene.En este caso cogemos toda la pantalla.
    
    // CGRect bounds= CGRectMake( 25, 40, 250, 300 );
    
    CGRect vistabounds = self.view.bounds;
    
    CGPoint origen= vistabounds.origin;
    // CGSize size=vistabounds.size;
    
    CGRect bounds = CGRectMake(origen.x+40, origen.y+40,240,250);
    
    
    vistalogros =[[UIView alloc]initWithFrame:bounds];
    vistalogros.layer.cornerRadius=10;
    [vistalogros setBackgroundColor:[UIColor blackColor]];
    [vistalogros setAlpha:0.9];
    vistalogros.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self.view addSubview:vistalogros];
    
    //hay que asignar el control para cuando el usuario toque se cierre la vista.
    
    
    //pintamos que hemos conseguido un logro y mostramos su informacion.
    
    if ([notificaciones count]>1) {
        
        
        
        
        
        for (int i=0; i<[notificaciones count]; i++) {
            
            
            NSDictionary *notificacion = [notificaciones objectAtIndex:i];
            
            
            
            if ([[notificacion objectForKey:@"idlogro"] integerValue]!=0) {
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trofeo.png"]];
                imageview.backgroundColor=[UIColor clearColor];
                imageview.frame=CGRectMake(50,20, 128, 128);
                imageview.contentMode=UIViewContentModeScaleAspectFit;
                
                [vistalogros addSubview:imageview];
                
                CGRect labelFrame = CGRectMake( 10, 168, 300, 30 );
                UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
                
                label.backgroundColor=[UIColor clearColor];
                label.text=@"¡Has conseguido un logro!";
                label.textColor=[UIColor whiteColor];
                label.font=[UIFont fontWithName:@"Avenir-Black" size:19];
                
                [vistalogros addSubview:label];
                
                labelFrame = CGRectMake( 10, 190, 300, 30 );
                label = [[UILabel alloc] initWithFrame:labelFrame];
                
                //NSString *textoLabel = [NSstring stringWithFormat:[]]
                [label setBackgroundColor:[UIColor clearColor]];
                NSString *titulo=[NSString stringWithFormat:@"%@",[notificacion objectForKey:@"nombre"]];
                
                [label setText:titulo];
                [label setTextColor: [UIColor whiteColor]];
                [label setFont:[UIFont fontWithName:@"Avenir-Black" size:19]];
                [vistalogros addSubview: label];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cerrarVistaLogros:)];
                tap.cancelsTouchesInView = YES;
                tap.numberOfTapsRequired = 1;
                tap.delegate = self;
                [vistalogros addGestureRecognizer:tap];
                
                
                
                
                
            }
            
            
            
            
        }
        
    }
    else
    {
        
        
        
        NSDictionary *notificacion = [notificaciones objectAtIndex:0];
        [vistalogros setFrame:CGRectMake( self.view.bounds.origin.x,self.view.bounds.size.height-40,self.view.bounds.size.width,40)];
        [vistalogros setAlpha:0.9];
        vistalogros.layer.cornerRadius=0;
        CGRect labelFrame = CGRectMake( vistalogros.bounds.origin.x+20, vistalogros.bounds.origin.y, vistalogros.bounds.size.width, 30 );
        UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
        //labelFrame = CGRectMake(vistaLogros.frame.origin.x+2, vistaLogros.frame.origin.y, 200, 30 );
        //label = [[UILabel alloc] initWithFrame:labelFrame];
        
        //NSString *textoLabel = [NSstring stringWithFormat:[]]
        [label setBackgroundColor:[UIColor clearColor]];
        NSString *titulo=[NSString stringWithFormat:@"Puntuacion obtenida: +%d",[[notificacion objectForKey:@"puntuacion"]intValue]];
        
        [label setText:titulo];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont:[UIFont fontWithName:@"Avenir-Black" size:19]];
        [vistalogros addSubview: label];
        
        //añadimos el gesturerecognizer para poder cerrar la vista pulsando sobre ella.
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cerrarVistaLogros:)];
        tap.cancelsTouchesInView = YES;
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [vistalogros addGestureRecognizer:tap];
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
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









-(void)setIdvino:(int)idwine{


    idvino=idwine;


}


@end
