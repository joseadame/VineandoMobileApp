//
//  RegistroController.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 21/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RegistroController : UIViewController <MBProgressHUDDelegate>{

    MBProgressHUD *HUD;


}

@property (nonatomic,retain) IBOutlet UITextField *emailText;

@property (nonatomic,retain) IBOutlet UITextField *passwordText;
@property (nonatomic,retain) IBOutlet UITextField *aliasText;
@property (nonatomic,retain) IBOutlet UINavigationBar *navBar;

- (IBAction)UnirteClick:(id)sender;

- (IBAction)volver:(id)sender;

-(void)registrarUsuario;

@end
