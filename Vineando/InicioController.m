//
//  InicioController.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 28/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "InicioController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "FBRegistroViewController.h"
#import "RestEngine.h"
#import "RespuestaREST.h"
#import "JSONKit.h"
#import "Utils.h"


@interface InicioController ()

@end

@implementation InicioController

@synthesize email;
@synthesize alias;
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
    
    //establecemos la imagen de fondo.
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
    
    self.hayDatos=NO;
    
    if (FBSession.activeSession.isOpen) {
        
        [self populateUserDetails];
        
        _FBLoginView.alpha=0.0f;
        _buttonCrear.alpha=0.0f;
        _buttonEntrar.alpha=0.0f;
        _labelCrear.alpha=0.0f;
        _labelCuenta.alpha=0.0f;
        
    }
    
}


-(void)flujo{
    
    UIStoryboard * storyboard = self.storyboard;
    
    ViewController * FBRegistro = [storyboard instantiateViewControllerWithIdentifier: @"FBRegistro"];
    
    [self presentViewController:FBRegistro animated:YES completion:nil];
}

-(void)comprobarUsuario{
    
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:email, @"username",
                         tiempoMilisec, @"timestamp",
                         @"123456", @"password",
                         nil];
    NSString *post = [dic JSONString];
    
    NSString *url = [NSString stringWithFormat:@"datalogin"];
    
    RestEngine *rest = [[RestEngine alloc]init];
    
    //llamamos al webservice y obtenemos la respuesta.
    RespuestaREST *respuestaREST = [rest llamarServicioREST:post url:url];
    
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
            self.hayDatos=NO;
            [self flujo];
        }
        
        
    }
    else{
        _FBLoginView.alpha=1.0f;
        _buttonCrear.alpha=1.0f;
        _buttonEntrar.alpha=1.0f;
        _labelCrear.alpha=1.0f;
        _labelCuenta.alpha=1.0f;
        
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (FBSession.activeSession.isOpen) {
        
        
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.tag=7;
        [self.view addSubview:HUD];
        HUD.delegate=self;
        HUD.labelText=@"Conectando...";
        [HUD showWhileExecuting:@selector(obtenerDatosUsuario) onTarget:self withObject:nil animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidUnload {
    [self setFBLoginView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Algo es incorrecto";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Error en la sesión";
        alertMessage = @"La sesión no es valida. Por favor, intentelo de nuevo.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"login cancelado");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Error desconocido";
        alertMessage = @"Error. Por favor, intentelo de nuevo.";
        NSLog(@"error inesperado:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)populateUserDetails {
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 alias = user.name;
                 self.userProfileImage.profileID = [user objectForKey:@"id"];
                 email = [user objectForKey:@"email"];
             }
         }];
            
    }
}

- (void)obtenerDatosUsuario{
    
    while(self.hayDatos==NO){
          if(self.alias!=nil && self.email!=nil)
              self.hayDatos=YES;
    }
    
    if(self.hayDatos==YES)
        [self comprobarUsuario];
}

@end
