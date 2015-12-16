//
//  LoginController.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 21/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginController : UIViewController <MBProgressHUDDelegate> {

    MBProgressHUD *HUD;

}

- (IBAction)loginClick:(id)sender;
- (IBAction)volver:(id)sender;

-(void)doLogin;

@property (nonatomic,retain) IBOutlet UITextField *userText;

@property (nonatomic,retain) IBOutlet UITextField *passwordText;

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic,retain) IBOutlet UINavigationBar *myNavBar;


@property (weak, nonatomic) IBOutlet UIView *contenedor;



@end
