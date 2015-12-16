//
//  FBRegistroViewController.h
//  Vineando
//
//  Created by Javier ignacio Calvo juan on 04/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface FBRegistroViewController : UIViewController<FBUserSettingsDelegate,MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

@property (nonatomic,retain) IBOutlet UILabel *email;

@property (nonatomic,retain) IBOutlet UITextField *passwordText;
@property (nonatomic,retain) IBOutlet UILabel *alias;
@property (nonatomic,retain) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;


- (IBAction)UnirteClick:(id)sender;

- (IBAction)volver:(id)sender;

-(void)loadData:(NSNotification *)notification;

- (void)populateUserDetails;

-(void)registrarUsuario;


@end
