//
//  ListasUsuarioController.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 17/02/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ListasUsuarioController :UIViewController<MBProgressHUDDelegate>{
 
    NSMutableArray *listasUsuario;
     MBProgressHUD *HUD;   

}

@property (nonatomic,retain) IBOutlet UITableView *tabla;
@property (nonatomic) UIRefreshControl *refreshControl;







@end
