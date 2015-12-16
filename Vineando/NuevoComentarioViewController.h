//
//  NuevoComentarioViewController.h
//  Vineando
//
//  Created by Jose Adame on 10/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface NuevoComentarioViewController : UIViewController <MBProgressHUDDelegate,UIGestureRecognizerDelegate>{

    
       MBProgressHUD *HUD;
       int idvino;
    
}


@property (weak, nonatomic) IBOutlet UITextView *textView;


- (IBAction)enviarComentario:(id)sender;

-(void)setIdvino:(int)idwine;

@end
