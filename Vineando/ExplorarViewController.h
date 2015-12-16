//
//  ExplorarViewController.h
//  Vineando
//
//  Created by Jose Adame on 07/10/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ExplorarViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;




@end
