//
//  PerfilUsuarioViewController.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 22/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "PerfilUsuarioViewController.h"
#import "AppDelegate.h"
#import "RestEngine.h"
#import "RespuestaREST.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSONKit.h"
#import "Utils.h"
#import "WishListController.h"
#import "LogrosController.h"
#import <QuartzCore/QuartzCore.h>
@interface PerfilUsuarioViewController ()

@end

@implementation PerfilUsuarioViewController

@synthesize imagenUsuario;
@synthesize alias;
@synthesize puntuacion;
@synthesize rango;
@synthesize datosUsuario;
@synthesize navBar;
@synthesize numCheckins;
@synthesize numLogros;
@synthesize numWish;

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
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Avenir-Black" size:18.0f], NSFontAttributeName,
                                                                     nil]];
    //actualizamos las estadisticas del usuario.
    [self actualizarEstadisticasUsurio];
    
    
    
    
        
    
    //[navBar setBackgroundImage:[UIImage imageNamed: @"navBarVino.png"]
               //    forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    //establecemos la imagen de fondo.
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    
    
   
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImagenUsuario:nil];
    [self setAlias:nil];
    [self setPuntuacion:nil];
    [self setRango:nil];
    [self setNavBar:nil];
    [self setNumCheckins:nil];
    [self setNumLogros:nil];
    [self setNumWish:nil];
    [super viewDidUnload];
}




-(void)actualizarEstadisticasUsurio{

    
    NSDictionary *usuario = ApplicationDelegate.usuario;
    alias.text= [usuario objectForKey:@"alias"];
    rango.text= [usuario objectForKey:@"rango"];
    NSNumber *puntos = [usuario objectForKey:@"puntuacion"];
    puntuacion.text = [puntos stringValue];
    NSString *url = [NSString stringWithFormat:@"%@",[usuario objectForKey:@"rutaAvatar"]];
    
    // NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    // UIImage *myimage = [[UIImage alloc] initWithData:imageData];
    // imagenUsuario.image = myimage;
    
    //cargamos la imagen de manera asincrona.
    [imagenUsuario setImageWithURL:[NSURL URLWithString:url]
                  placeholderImage:[UIImage imageNamed:@"estrella.png"]]; //hay que cambiar esto para poner una imagen por defecto en caso de que no se cargue la original.
    
    self.imagenUsuario.contentMode = UIViewContentModeScaleAspectFill;
    self.imagenUsuario.clipsToBounds = YES;
    self.imagenUsuario.layer.cornerRadius = 48.0f;
    self.imagenUsuario.layer.borderWidth = 4.0f;
    self.imagenUsuario.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    NSNumber *idusuario = [usuario objectForKey:@"id"];
    url=[NSString stringWithFormat:@"usuario/%@/estadisticas",[idusuario stringValue]];
    
    
    //vamos a obtener el numero de checkins del usuario.
    //deberiamos meter esta llamada en otro hilo de ejecucion para no bloquear la interfaz de usuario.
    
    RestEngine *engine = [[RestEngine alloc]init];
    RespuestaREST *respuesta = [engine llamarServicioRESTConsulta:url ];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        NSString *resultado= [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
        
        NSDictionary *estadisticas = [resultado objectFromJSONString];
        NSString *status = [estadisticas objectForKey:@"status"];
        NSDictionary *datos = [estadisticas objectForKey:@"estadisticas"];
        
        
        if ([status isEqualToString:@"OK"]) {
            //si no hemos tenido ningun error con la api rellenamos las estadisticas del usuario.
            
            self.numCheckins.text=[NSString stringWithFormat:@"%@",[[datos objectForKey:@"numeroCheckins"] stringValue]];
            self.numLogros.text=[NSString stringWithFormat:@"%@",[[datos objectForKey:@"numeroLogros"] stringValue]];
            numWish.text=[NSString stringWithFormat:@"%@",[[datos objectForKey:@"numeroVinosWishList"] stringValue]];
            
            
        }
        else{
            
            Utils *utilidad = [[Utils alloc] init];
            [utilidad alertStatus:status titulo:@"¡Ups!Parece que hemos tenido un problema"];
            
        }
        
        
        
        
    }






}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"wishlist"]) {
        
        NSLog(@"wishlist");
        
        WishListController *wishlist = [segue destinationViewController];
        
          }
    if ([segue.identifier isEqualToString:@"logros"]) 
  
    {
        
        LogrosController *logros = [segue destinationViewController];
        
              
    }
    
    
}




//metodos delegados de UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //devolvemos tantas filas como elementos tenga el array de listas de usuario.
    // return [listavinos count];
    
    return 20;
    
}












@end
