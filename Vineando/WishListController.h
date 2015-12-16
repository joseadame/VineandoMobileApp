//
//  WishListController.h
//  Vineando
//
//  Created by Jose Adame on 18/05/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface WishListController : UIViewController <MBProgressHUDDelegate>{

    MBProgressHUD *HUD;

}

@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tabla;

-(void)cargarWishList:(UIRefreshControl*)refresh;



@end
