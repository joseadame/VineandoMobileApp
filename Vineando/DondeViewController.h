//
//  DondeViewController.h
//  Vineando
//
//  Created by Jose Adame on 04/09/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DondeViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
