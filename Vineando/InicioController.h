//
//  InicioController.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 28/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

@interface InicioController : UIViewController<FBLoginViewDelegate, MBProgressHUDDelegate,FBUserSettingsDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (unsafe_unretained, nonatomic) IBOutlet FBLoginView *FBLoginView;

@property (nonatomic,retain) NSString *email;

@property (nonatomic,retain) IBOutlet UIButton *buttonEntrar;
@property (nonatomic,retain) IBOutlet UIButton *buttonCrear;
@property (nonatomic,retain) IBOutlet UILabel *labelCuenta;
@property (nonatomic,retain) IBOutlet UILabel *labelCrear;

@property (nonatomic,retain) NSString *alias;
@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;

@property BOOL hayDatos;

- (void)populateUserDetails;
- (void)obtenerDatosUsuario;
-(void)flujo;
-(void)comprobarUsuario;

@end

