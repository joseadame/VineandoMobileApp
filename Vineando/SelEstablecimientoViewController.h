//
//  SelEstablecimientoViewController.h
//  Vineando
//
//  Created by Jose Adame on 04/09/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"


#define kCLIENTID "2VARKRXZAPFW41BWXIDAFOKMBXPASTNX5DJWZELJ2NUAJ0X1"
#define kCLIENTSECRET "TNGUAHENFNKM1VJRBZG3XPHEQ1TB4HHXV5KDQ0AAMPBEJSZD"


@protocol SeleccionarEstablecimientoDelegate<NSObject>

-(void) doSeleccion:(NSDictionary *)datosEstablecimiento;

@end


@interface SelEstablecimientoViewController : UIViewController <CLLocationManagerDelegate,MBProgressHUDDelegate>{

    id<SeleccionarEstablecimientoDelegate>delegate;
    MBProgressHUD *HUD;

}


@property  (retain) id <SeleccionarEstablecimientoDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *ciudadLabel;


@property (weak, nonatomic) IBOutlet UISearchBar *buscadorText;


@property (weak, nonatomic) IBOutlet UITableView *tabla;






@end
