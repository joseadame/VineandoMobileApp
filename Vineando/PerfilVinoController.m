//
//  PerfilVinoController.m
//  Vineando
//
//  Created by Jose Adame on 01/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "PerfilVinoController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ComentariosViewController.h"
#import "AppDelegate.h"
#import "RestEngine.h"
#import "JSONKit.h"
#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "CheckinViewController.h"
#import "DondeViewController.h"


@interface PerfilVinoController ()




@end

@implementation PerfilVinoController{

    UIView *vistalogros;


}

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
    
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];    
    
    //seteamos los valores del vino seleccionado.
    self.nombreVino.text=[datosVino objectForKey:@"nombre"];
    self.tipoVino.text=[datosVino objectForKey:@"tipovino"];
    self.anioVino.text=[datosVino objectForKey:@"anio"];
    self.puntuacionVino.text=[NSString stringWithFormat:@"%.2f",[[datosVino objectForKey:@"notamedia"]doubleValue]];
    self.bodegaVino.text=[datosVino objectForKey:@"bodega"];
    NSString *url = [NSString stringWithFormat:@"%@",[datosVino objectForKey:@"rutaimagen"]];
    
    //cargamos la imagen de forma asincrona.
    [self.imagenVino setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    
    
    
    
    
    
    
    
}


//asignamos los datos del vino a la propiedad de la clase.
-(void)setDatosVino:(NSDictionary *)datos{

    datosVino=datos;
  

}



- (void)didReceiveMemoryWarning
{
    //liberamos memoria innecesaria.
    datosVino=nil;
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//realizar el checkin del usuario sobre el vino.
- (IBAction)checkin:(id)sender {
}



//Añade el vino a la wishlist del usuario.
- (IBAction)addWishList:(id)sender {
    
    
    //recuperamos el id del usuario para buscar sus listas.
    NSDictionary *usuario = ApplicationDelegate.usuario;
    NSString *url = [NSString stringWithFormat:@"usuario/altaWishlist/%@/%@",[usuario objectForKey:@"id"],[datosVino objectForKey:@"idvino"]];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
   
   
    
    //hacemos la operacion en otro hilo.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
         //llamamos al webservice para añadir el vino a la wishlist, en este caso no necesitamos body.
        
        RespuestaREST *respuesta = [restengine llamarServicioREST:@"" url:url];
        
        
        if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSDictionary *respuestaComentario = [responseData objectFromJSONString];
            NSString *status = [respuestaComentario objectForKey:@"status"];
            NSLog(@"hemos deserializado %@",status);
            
            
            if ([status isEqualToString:@"OK"])
            {
                //si todo ha ido bien hay que mostrar los logros si los hubiera y la puntuación obtenida.
                //guardamos las notificaciones en un NSMutableArray
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableArray *notificaciones = [respuestaComentario objectForKey:@"notificaciones"];
                    
                    
                    //mostramos una vista con las notificaciones o puntuaciones obtenidas.
                    [self mostrarVistaNotificaciones:notificaciones];
                });
               
                
                
                
                
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{

                        Utils *utilidad = [[Utils alloc] init];
                        [utilidad alertStatus:status titulo:@"El vino ya esta en tu whislist"];
                 });                
            }
            
            
            
            
        }
        else{
           dispatch_async(dispatch_get_main_queue(), ^{ 
            
               Utils *utilidad = [[Utils alloc]init];
               [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
             });             
        }
        
        
        
    });
    
    
    
    
    
    
    
    
}



//Busca un vino cerca de la posicion del usuario, navegando a una pantalla donde podremos ver un mapa con los diferentes establecimientos donde se puede probar este vino.
- (IBAction)buscarVino:(id)sender {
    
    
    
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{


    if ([segue.identifier isEqualToString:@"comentariosvino" ]) {
        
        ComentariosViewController *vistacomentarios = [segue destinationViewController];
        int idvino=[[datosVino objectForKey:@"idvino"]intValue];
        
        [vistacomentarios setIdVino:idvino];
        
        
    }
    if ([segue.identifier isEqualToString:@"checkin" ]) {

    
        CheckinViewController *vistaCheckin = [segue destinationViewController];
        [vistaCheckin setDatosVino:datosVino];
    
    
    
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
                label.font=[UIFont fontWithName:@"Helvetica Neue" size:19];
                
                [vistalogros addSubview:label];
                
                labelFrame = CGRectMake( 10, 190, 300, 30 );
                label = [[UILabel alloc] initWithFrame:labelFrame];
                
                //NSString *textoLabel = [NSstring stringWithFormat:[]]
                [label setBackgroundColor:[UIColor clearColor]];
                NSString *titulo=[NSString stringWithFormat:@"%@",[notificacion objectForKey:@"nombre"]];
                
                [label setText:titulo];
                [label setTextColor: [UIColor whiteColor]];
                [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];
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
        
        
        
       // NSDictionary *notificacion = [notificaciones objectAtIndex:0];
        [vistalogros setFrame:CGRectMake( self.view.bounds.origin.x,self.view.bounds.size.height-40,self.view.bounds.size.width,40)];
        [vistalogros setAlpha:0.9];
        vistalogros.layer.cornerRadius=0;
        CGRect labelFrame = CGRectMake( vistalogros.bounds.origin.x+20, vistalogros.bounds.origin.y, vistalogros.bounds.size.width, 30 );
        UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
        //labelFrame = CGRectMake(vistaLogros.frame.origin.x+2, vistaLogros.frame.origin.y, 200, 30 );
        //label = [[UILabel alloc] initWithFrame:labelFrame];
        
        //NSString *textoLabel = [NSstring stringWithFormat:[]]
        [label setBackgroundColor:[UIColor clearColor]];
        NSString *titulo=[NSString stringWithFormat:@"Vino añadido a  tu whishlist"];
        
        [label setText:titulo];
        [label setTextColor: [UIColor whiteColor]];
        [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];
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





@end
