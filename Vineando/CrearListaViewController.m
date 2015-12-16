//
//  CrearListaViewController.m
//  Vineando
//
//  Created by Jose Adame on 24/04/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "CrearListaViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "RestEngine.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

@interface CrearListaViewController (){

    NSString *compartida;
    UIView *vistaLogros;


}

@end

@implementation CrearListaViewController

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
    
    //mostramos el teclado.
    [_nombreListaText becomeFirstResponder];
    
    //por defecto ponemos que la lista es compartida.
    compartida=[NSString stringWithFormat:@"Si"];
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self setTitle:@"Nueva lista"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)crearLista:(id)sender {
    
    
    
    
    //ocultamos el teclado.
    [_nombreListaText resignFirstResponder];
    
    
    //creamos el nsdictionary donde almacenamos los datos de la lista.
    
    NSDictionary *usuario = ApplicationDelegate.usuario;
    
    NSDictionary *datosLista = [NSDictionary dictionaryWithObjectsAndKeys:[_nombreListaText text],@"descripcion",compartida,@"compartida",[usuario objectForKey:@"id"],@"idusuario",nil];
    
    NSString *post = [datosLista JSONString];
    
    NSString *url = [NSString stringWithFormat:@"usuario/listas/nuevalista"];
    
    
    //RespuestaREST *respuesta = [self llamarAPI:post conURL:url];
    
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.tag=7;
        [self.view addSubview:HUD];
        HUD.delegate=self;
        HUD.labelText=@"Creando lista...";
    
        [HUD showAnimated:YES whileExecutingBlock:^{
       
        RestEngine *engine = [[RestEngine alloc]init];
        
        RespuestaREST *respuesta = [engine llamarServicioREST:post url:url];
        
        
        if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            NSDictionary *respuestaCrearLista = [responseData objectFromJSONString];
            NSString *status = [respuestaCrearLista objectForKey:@"status"];
            // NSDictionary *datos = [respuestaCrearLista objectForKey:@"user"];
            NSLog(@"hemos deserializado %@",status);
            
            
            if ([status isEqualToString:@"OK"])
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //si todo ha ido bien hay que mostrar los logros si los hubiera y la puntuación obtenida.
                    //guardamos las notificaciones en un NSMutableArray
                    
                    NSMutableArray *notificaciones = [respuestaCrearLista objectForKey:@"listanotificaciones"];
                    
                    
                    
                    //mostramos una vista con las notificaciones o puntuaciones obtenidas.
                    [self mostrarVistaNotificaciones:notificaciones];
                });
                
                
                    
                
                
                
                
                
                
                
            }
            else{
                 dispatch_async(dispatch_get_main_queue(), ^{                
                        Utils *utilidad = [[Utils alloc] init];
                        [utilidad alertStatus:status titulo:@"No hemos podido crear la lista"];
                  });
            }
            
            
        }
        else{
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                        Utils *utilidad = [[Utils alloc]init];
                        [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
            });             
        }
        
        
        
        
        
	} completionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD removeFromSuperview];
            });  		
	}];
    
    
    
        
}


// se ejecuta cuando pulsamos el selector para lista compartida.
- (IBAction)pulsarSelector:(id)sender {
    
    if(_compartidaSwitch.on){
    
        compartida = [NSString stringWithFormat:@"Si"];
    
    }
    else{
    
        compartida = [NSString stringWithFormat:@"No"];
    
    
    }
    
    
    
}

-(void)mostrarVistaNotificaciones:(NSMutableArray *)notificaciones{

    //El tamaño de la vista sera el total el tamaño de la vista que la contiene.En este caso cogemos toda la pantalla.
    
   // CGRect bounds= CGRectMake( 25, 40, 250, 300 );
    
    CGRect vistabounds = self.view.bounds;
    
    CGPoint origen= vistabounds.origin;
   // CGSize size=vistabounds.size;
    
    CGRect bounds = CGRectMake(origen.x+40, origen.y+40,240,250);
    
    
    vistaLogros =[[UIView alloc]initWithFrame:bounds];
    vistaLogros.layer.cornerRadius=10;
    [vistaLogros setBackgroundColor:[UIColor blackColor]];
    [vistaLogros setAlpha:0.9];
    vistaLogros.layer.borderColor=[[UIColor whiteColor] CGColor];
    [self.view addSubview:vistaLogros];
    
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
                
                [vistaLogros addSubview:imageview];
                
                CGRect labelFrame = CGRectMake( 10, 168, 300, 30 );
                UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
                
                label.backgroundColor=[UIColor clearColor];
                label.text=@"¡Has conseguido un logro!";
                label.textColor=[UIColor whiteColor];
                label.font=[UIFont fontWithName:@"Helvetica Neue" size:19];
                
                [vistaLogros addSubview:label];
                
                labelFrame = CGRectMake( 10, 190, 300, 30 );
                label = [[UILabel alloc] initWithFrame:labelFrame];
                
                //NSString *textoLabel = [NSstring stringWithFormat:[]]
                [label setBackgroundColor:[UIColor clearColor]];
                NSString *titulo=[NSString stringWithFormat:@"%@",[notificacion objectForKey:@"nombre"]];
                
                [label setText:titulo];
                [label setTextColor: [UIColor whiteColor]];
                [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];
                [vistaLogros addSubview: label];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cerrarVistaLogros:)];
                tap.cancelsTouchesInView = YES;
                tap.numberOfTapsRequired = 1;
                tap.delegate = self;
                [vistaLogros addGestureRecognizer:tap];
                
                
                
                
                
            }        
        
        
        
        
    }
    
    }
    else
    {
        
      
        
        NSDictionary *notificacion = [notificaciones objectAtIndex:0];
        [vistaLogros setFrame:CGRectMake( self.view.bounds.origin.x,self.view.bounds.size.height-40,self.view.bounds.size.width,40)];
        [vistaLogros setAlpha:0.9];
        vistaLogros.layer.cornerRadius=0;
        CGRect labelFrame = CGRectMake( vistaLogros.bounds.origin.x+20, vistaLogros.bounds.origin.y, vistaLogros.bounds.size.width, 30 );
        UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
        //labelFrame = CGRectMake(vistaLogros.frame.origin.x+2, vistaLogros.frame.origin.y, 200, 30 );
        //label = [[UILabel alloc] initWithFrame:labelFrame];
        
        //NSString *textoLabel = [NSstring stringWithFormat:[]]
        [label setBackgroundColor:[UIColor clearColor]];
        NSString *titulo=[NSString stringWithFormat:@"Puntuacion obtenida: +%d",[[notificacion objectForKey:@"puntuacion"]intValue]];
        
        [label setText:titulo];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];
        [vistaLogros addSubview: label];
        
        //añadimos el gesturerecognizer para poder cerrar la vista pulsando sobre ella.
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cerrarVistaLogros:)];
        tap.cancelsTouchesInView = YES;
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [vistaLogros addGestureRecognizer:tap];
        
        
    
    
    
    
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
                         vistaLogros.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished) {
                         [vistaLogros removeFromSuperview];
                         
                     }];
    
    


}


@end
