//
//  FBRegistroViewController.m
//  Vineando
//
//  Created by Javier ignacio Calvo juan on 04/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "FBRegistroViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "Login.h"
#import "Utils.h"
#import "JSONKit.h"
#import "RestEngine.h"

@interface FBRegistroViewController ()

@end

@implementation FBRegistroViewController

@synthesize email;
@synthesize passwordText;
@synthesize alias;
@synthesize navBar;
@synthesize user = _user;
@synthesize userProfileImage;


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
    [navBar setBackgroundImage:[UIImage imageNamed: @"navBarVino.png"]forBarMetrics:UIBarMetricsDefault];
     
    
    [self populateUserDetails];
    [passwordText becomeFirstResponder];

}

-(void)viewDidUnload{

    [self setPasswordText:nil];
    [self setNavBar:nil];
    [super viewDidUnload];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)UnirteClick:(id)sender{
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Creando usuario...";
    [HUD showWhileExecuting:@selector(registrarUsuario) onTarget:self withObject:nil animated:YES];
    
}

-(void)registrarUsuario{
    
    Login *login = [[Login alloc] init];
    
    if([[passwordText text] isEqualToString:@""]){
        
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Debe introducir la contraseña" titulo:@"Datos incorrectos"];
        
        
    }
    else{
        
        login.user= [email text];
        login.password = [passwordText text];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[email text], @"email",
                             [passwordText text], @"password",[alias text],@"alias",nil];
        
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

-(void)loadData:(NSNotification *)notification{
}

- (IBAction)volver:(id)sender{
    
    UIStoryboard * storyboard = self.storyboard;
    
    ViewController * pantallainicio = [storyboard instantiateViewControllerWithIdentifier: @"pantallaPrincipal"];
    
    [self presentViewController:pantallainicio animated:YES completion:nil];
}

- (void)populateUserDetails {
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 self.alias.text = user.name;
                 self.userProfileImage.profileID = [user objectForKey:@"id"];
                 self.email.text = [user objectForKey:@"email"];
             }
         }];
       
    }
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	//[HUD release];
	HUD = nil;
}


@end
