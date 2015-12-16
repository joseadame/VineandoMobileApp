//
//  ExplorarViewController.m
//  Vineando
//
//  Created by Jose Adame on 07/10/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "ExplorarViewController.h"
#import "Utils.h"

@interface ExplorarViewController (){

    CLLocationManager *locationManager;

}

@end

@implementation ExplorarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (locationManager==nil) {
        locationManager=[[CLLocationManager alloc]init];
        
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//delegados de CLLocationManager


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocationCoordinate2D coordenadas= locationManager.location.coordinate;
    
    [_mapView setCenterCoordinate:coordenadas animated:YES];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordenadas, 1500, 1500);
    [_mapView setRegion:region];
    
    
    
}


// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    Utils *util = [[Utils alloc]init];
    [util alertStatus:@"Ha habido un problema localizandote" titulo:@"Error GPS"];
    
}






@end
