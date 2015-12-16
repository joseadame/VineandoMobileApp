//
//  LoginController.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 21/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "LoginController.h"
#import "Login.h"
#import "JSONKit.h"
#import "RestEngine.h"
#import "RespuestaREST.h"
#import "ViewController.h"
#import "PerfilUsuarioViewController.h"
#import "Utils.h"
#import "AppDelegate.h"

@interface LoginController ()





@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@implementation LoginController{

    RespuestaREST *respuestaREST;



}

#pragma mark -
#pragma mark Constants

#pragma mark -
#pragma mark Lifecycle methods



@synthesize userText;
@synthesize passwordText;
@synthesize activityIndicator;
@synthesize myNavBar;

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
    //vamos a mostrar el teclado despues de cargar la vista para que este disponible al usuario.
    
    [myNavBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                 [UIFont fontWithName:@"Avenir-Black" size:18.0f], NSFontAttributeName,
                                                                 nil]];
 
    [myNavBar setBackgroundImage:[UIImage imageNamed: @"navBarVino.png"]
                   forBarMetrics:UIBarMetricsDefault];
    
    //establecemos la imagen de fondo.
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
   // self.view.backgroundColor = background;
    
    _contenedor.backgroundColor=background;
    [userText becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//hace el login
-(void)doLogin{
    Login *login = [[Login alloc]init];
    
    //asignamos a la clase login sus valores recogidos en los campos de texto.
    
    
    
    if([[userText text] isEqualToString:@""] || [[passwordText text] isEqualToString:@""] ){
        Utils *utilidad = [[Utils alloc]init];
        
        [utilidad alertStatus:@"Debe introducir el mail y la contraseña" titulo:@"Login fallido"];
        
        
    }
    else{
        
        //  [activityIndicator startAnimating];
        //[activityIndicator setHidden:NO];
        
        login.user= [userText text];
        login.password = [passwordText text];
        
        NSDate *date = [[NSDate alloc]init];
        NSTimeInterval timeStamp = [date timeIntervalSince1970];
        
        //pasamos el dato a milisegundos ya que viene en segundos
        double tiempo=timeStamp*1000;
        
        //lo convertimos a string para quitarle los valores decimales
        NSString *tmp=[NSString stringWithFormat:@"%f",tiempo];
        tmp=[tmp substringToIndex:13];
        
        //se formatea y se transforma el string en NSNumber para poder setearlo en el json y que lleve el mismo formato que en java
        NSNumberFormatter *f=[[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *tiempoMilisec=[f numberFromString:tmp];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[userText text], @"username",
                             tiempoMilisec, @"timestamp",
                             [passwordText text], @"password",
                             nil];
        
        //convertimos a formato json.
        NSString *post = [dic JSONString];
        
        NSString *url = [NSString stringWithFormat:@"loginBody"];
        
        //creamos la instancia de RestEngine para las comunicaciones.
        RestEngine *rest = [[RestEngine alloc]init];
    
        //llamamos al webservice y obtenemos la respuesta.
        respuestaREST = [rest llamarServicioREST:post url:url];
        
        
                 
            //evaluamos la respuesta.
            if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                NSDictionary *loginResult = [responseData objectFromJSONString];
                NSString *status = [loginResult objectForKey:@"status"];
                NSDictionary *datos = [loginResult objectForKey:@"user"];
                NSLog(@"hemos deserializado %@",status);
                //[activityIndicator stopAnimating];
                
                if ([status isEqualToString:@"OK"])
                {
                    
                    
                    //guardamos en el delegado el usuario.
                    [ApplicationDelegate setUsuario:datos];
                    
                    //transicionamos a la pantalla de perfil del usuario.
                    UIStoryboard * storyboard = self.storyboard;
                    
                    ViewController * perfilUsuario = [storyboard instantiateViewControllerWithIdentifier: @"menuPrincipal"];
                    
                    [self presentViewController:perfilUsuario animated:YES completion:nil];
                    
                    
                }
                else{
                    
                    Utils *utilidad = [[Utils alloc] init];
                    [utilidad alertStatus:status titulo:@"Login fallido"];
                    [HUD hide:YES];
                    //UIView *removeView  = [self.view viewWithTag:7];
                    //[removeView removeFromSuperview];
                    
                }
                
                
            }
            else{
                Utils *utilidad = [[Utils alloc]init];
                [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
                [HUD hide:YES];
                // UIView *removeView  = [self.view viewWithTag:7];
                // [removeView removeFromSuperview];
            }
        
        
        
       
        
      
        
        
        
                
        
        
        
        
    }




}




- (IBAction)loginClick:(id)sender {
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Conectando...";
    [HUD showWhileExecuting:@selector(doLogin) onTarget:self withObject:nil animated:YES];
    [userText resignFirstResponder];
    [passwordText resignFirstResponder];
    
   /* Login *login = [[Login alloc]init];
    
    //asignamos a la clase login sus valores recogidos en los campos de texto.
    
    
    
    if([[userText text] isEqualToString:@""] || [[passwordText text] isEqualToString:@""] ){
        Utils *utilidad = [[Utils alloc]init];
        
        [utilidad alertStatus:@"Debe introducir el mail y la contraseña" titulo:@"Login fallido"];
        
        
    }
    else{
        
        //  [activityIndicator startAnimating];
        //[activityIndicator setHidden:NO];
        
        login.user= [userText text];
        login.password = [passwordText text];
        
        NSDate *date = [[NSDate alloc]init];
        NSTimeInterval timeStamp = [date timeIntervalSince1970];
        
        //pasamos el dato a milisegundos ya que viene en segundos
        double tiempo=timeStamp*1000;
        
        //lo convertimos a string para quitarle los valores decimales
        NSString *tmp=[NSString stringWithFormat:@"%f",tiempo];
        tmp=[tmp substringToIndex:13];
        
        //se formatea y se transforma el string en NSNumber para poder setearlo en el json y que lleve el mismo formato que en java
        NSNumberFormatter *f=[[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *tiempoMilisec=[f numberFromString:tmp];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[userText text], @"username",
                             tiempoMilisec, @"timestamp",
                             [passwordText text], @"password",
                            nil];
        
        //convertimos a formato json.
        NSString *post = [dic JSONString];
    
        NSString *url = [NSString stringWithFormat:@"loginBody"];
        
        //creamos la instancia de RestEngine para las comunicaciones.
        RestEngine *rest = [[RestEngine alloc]init];
        
        HUD=[[MBProgressHUD alloc]initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.delegate=self;
        
        
        
        
        //llamamos al webservice y obtenemos la respuesta.
        RespuestaREST *respuestaREST = [rest llamarServicioREST:post url:url];
        
        
        //evaluamos la respuesta.
        if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            NSDictionary *loginResult = [responseData objectFromJSONString];
            NSString *status = [loginResult objectForKey:@"status"];
            NSDictionary *datos = [loginResult objectForKey:@"user"];
            NSLog(@"hemos deserializado %@",status);
            //[activityIndicator stopAnimating];
            
            if ([status isEqualToString:@"OK"])
            {
                
                
                //guardamos en el delegado el usuario.
                [ApplicationDelegate setUsuario:datos];
                
                //transicionamos a la pantalla de perfil del usuario.
                UIStoryboard * storyboard = self.storyboard;
                
                ViewController * perfilUsuario = [storyboard instantiateViewControllerWithIdentifier: @"menuPrincipal"];
                
                [self presentViewController:perfilUsuario animated:YES completion:nil];
                
                
            }
            else{
                
                Utils *utilidad = [[Utils alloc] init];
                [utilidad alertStatus:status titulo:@"Login fallido"];
                
            }
            
            
        }
        else{
            Utils *utilidad = [[Utils alloc]init];
            [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
            // [activityIndicator stopAnimating];
            
        }
        
        
        
        
   
    }*/
    
       
    
    
}



- (void)viewDidUnload {
    [self setUserText:nil];
    [self setPasswordText:nil];
    [self setActivityIndicator:nil];
    [self setMyNavBar:nil];
    [super viewDidUnload];
}
- (IBAction)volver:(id)sender {
    
    UIStoryboard * storyboard = self.storyboard;
    
    ViewController * pantallainicio = [storyboard instantiateViewControllerWithIdentifier: @"pantallaPrincipal"];
    
    [self presentViewController:pantallainicio animated:YES completion:nil];
    
    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	//[HUD release];
	HUD = nil;
}



@end
