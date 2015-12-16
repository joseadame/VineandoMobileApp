//
//  topVinosViewController.h
//  Vineando
//
//  Created by Jose Adame on 05/10/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

@interface topVinosViewController : UIViewController<MBProgressHUDDelegate,MKMapViewDelegate,CLLocationManagerDelegate>{

    MBProgressHUD *HUD;

}



@property (weak, nonatomic) IBOutlet UITableView *tabla;
@property (nonatomic) UIRefreshControl *refreshControl;



@end
