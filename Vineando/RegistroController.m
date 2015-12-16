//
//  RegistroController.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 21/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "RegistroController.h"
#import "JSONKit.h"
#import "RestEngine.h"
#import "Login.h"
#import "Utils.h"
#import "Login.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface RegistroController ()

@end

@implementation RegistroController

@synthesize emailText;
@synthesize passwordText;
@synthesize aliasText;
@synthesize navBar;

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
    
    
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                      [UIFont fontWithName:@"Avenir-Black" size:18.0f], UITextAttributeFont,
                                      nil]];
    
    
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBarVino.png"]forBarMetrics:UIBarMetricsDefault];
    //mostramos el teclado al cargar la vista.
    [aliasText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEmailText:nil];
    [self setPasswordText:nil];
    [self setAliasText:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}



-(void)registrarUsuario{

    Login *login = [[Login alloc] init];
    
    if([[emailText text] isEqualToString:@""] || [[passwordText text] isEqualToString:@""] || [[aliasText text] isEqualToString:@""]){
        
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Debe introducir el mail y la contraseña" titulo:@"Datos incorrectos"];
        
        
        
        
    }
    else{
        
        login.user= [emailText text];
        login.password = [passwordText text];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[emailText text], @"email",
                             [passwordText text], @"password",[aliasText text],@"alias",nil];
        
        NSString *post = [dic JSONString];
        
        
        
        
        NSString *url = [NSString stringWithFormat:@"usuario/alta"];
        
        RestEngine *rest = [[RestEngine alloc]init];
        
        RespuestaREST *respuestaREST = [rest llamarServicioREST:post url:url];
        
        NSLog(@"response %d",[respuestaREST.response statusCode]);
        
        
        if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            NSDictionary *loginResult = [responseData objectFromJSONString];
            NSString *status = [loginResult objectForKey:@"status"];
            NSDictionary *datos = [loginResult objectForKey:@"user"];
            NSLog(@"hemos deserializado %@",status);
            
            
            if ([status isEqualToString:@"OK"])
            {
                
                
                //guardamos en el delegado el usuario.
                [ApplicationDelegate setUsuario:datos];
                
                UIStoryboard * storyboard = self.storyboard;
                
                ViewController * perfilUsuario = [storyboard instantiateViewControllerWithIdentifier: @"menuPrincipal"];
                
                [self presentViewController:perfilUsuario animated:YES completion:nil];
                
                
            }
            else{
                
                Utils *utilidad = [[Utils alloc] init];
                [utilidad alertStatus:status titulo:@"Registro fallido"];
                
            }
            
            
        }
        else{
            Utils *utilidad = [[Utils alloc]init];
            [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
            
            
        }
        
        
        
        
    }








}



- (IBAction)UnirteClick:(id)sender {
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Creando usuario...";
    [HUD showWhileExecuting:@selector(registrarUsuario) onTarget:self withObject:nil animated:YES];
    
    
   /* Login *login = [[Login alloc] init];
    
    if([[emailText text] isEqualToString:@""] || [[passwordText text] isEqualToString:@""] || [[aliasText text] isEqualToString:@""]){
        
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Debe introducir el mail y la contraseña" titulo:@"Datos incorrectos"];
        
        
        
        
    }
    else{
        
        login.user= [emailText text];
        login.password = [passwordText text];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[emailText text], @"email",
                             [passwordText text], @"password",[aliasText text],@"alias",nil];
        
        NSString *post = [dic JSONString];
        
        
        
    
        NSString *url = [NSString stringWithFormat:@"usuario/alta"];
        
        RestEngine *rest = [[RestEngine alloc]init];
        
        RespuestaREST *respuestaREST = [rest llamarServicioREST:post url:url];
        
        NSLog(@"response %d",[respuestaREST.response statusCode]);
        
        
        if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            NSDictionary *loginResult = [responseData objectFromJSONString];
            NSString *status = [loginResult objectForKey:@"status"];
            NSDictionary *datos = [loginResult objectForKey:@"user"];
            NSLog(@"hemos deserializado %@",status);
            
            
            if ([status isEqualToString:@"OK"])
            {
                
                //guardamos los datos del usuario , hay que itentar guardar al id para luego llamar al webservice que recupera los datos del usuario.
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:datos forKey:@"datosUsuario"];
                
                UIStoryboard * storyboard = self.storyboard;
                
                ViewController * perfilUsuario = [storyboard instantiateViewControllerWithIdentifier: @"menuPrincipal"];
                
                [self presentViewController:perfilUsuario animated:YES completion:nil];
                
                
            }
            else{
                
                Utils *utilidad = [[Utils alloc] init];
                [utilidad alertStatus:status titulo:@"Registro fallido"];
                
            }
            
            
        }
        else{
            Utils *utilidad = [[Utils alloc]init];
            [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
           
            
        }
    
    
    
    
}*/
    
    
    
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
