//
//  SelEstablecimientoViewController.m
//  Vineando
//
//  Created by Jose Adame on 04/09/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "SelEstablecimientoViewController.h"
#import "RestEngine.h"
#import "JSONKit.h"
#import "Utils.h"
#import "EstablecimientoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CheckinViewController.h"

@interface SelEstablecimientoViewController (){

    CLLocationManager *locationManager;
    NSMutableArray *listadoEstablecimientos;

}

@end




@implementation SelEstablecimientoViewController{

    NSDictionary *respuestaFourSquare;

}

@synthesize  delegate;


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
    
    
    //configuramos los espacios entre comentarios.
    self.tabla.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    
    self.tabla.separatorColor = [UIColor clearColor];
    
    
    
    
    if (locationManager==nil) {
        locationManager =[[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Obteniendo establecimientos...";
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
                [self obtenerEstalbecimientos];
    }];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [locationManager stopUpdatingLocation];
    // Dispose of any resources that can be recreated.
}



//implementamos los metodos delegados de CLLocationManager.


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString * location = ([placemarks count] > 0) ? [[placemarks objectAtIndex:0] locality] : @"Ciudad no encontrada";
        _ciudadLabel.text=location;
      
    }];
}


// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}



//Metodo que conecta con la API de foursquare para obtener los establecimientos cercanos a la posicion del usuario.
-(void)obtenerEstalbecimientos{
   
    
    
  CLLocation *location= locationManager.location;
  NSString *coordenadas=[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
  NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
  NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&client_id=%@&client_secret=%@",coordenadas,clientID,clientSecret];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarURL:url];
    
    NSLog(@"respuesta: %d",[respuesta.response statusCode]);
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
           respuestaFourSquare = [responseData objectFromJSONString];
            NSDictionary *response = [respuestaFourSquare objectForKey:@"response"];
            
           NSMutableArray *grupos = [response objectForKey:@"groups"];
           NSMutableArray *establecimientos = [grupos mutableArrayValueForKeyPath:@"items"];
           // NSLog(@"%d",[listasUsuario count]);
            //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
          //  [self.refreshControl endRefreshing];
            
           listadoEstablecimientos = [establecimientos objectAtIndex:0];
            NSLog(@"%d",[listadoEstablecimientos count]);
                       
            
            [_tabla reloadData];
        });
    }
    else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            Utils *utilidad = [[Utils alloc]init];
            [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
            // [activityIndicator stopAnimating];
        });
    }
    







}

//metodos delegados de UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //devolvemos tantas filas como elementos tenga el array de listas de usuario.
    // return [listavinos count];
    
    if ([listadoEstablecimientos count]==0)
    {
        return 0;
    }
    else{
        
        return [listadoEstablecimientos count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   EstablecimientoCell  *celda = [tableView dequeueReusableCellWithIdentifier:@"establecimientoCell"];
    
    
    NSDictionary *datosEstablecimiento = [listadoEstablecimientos objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[EstablecimientoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"establecimientoCell"];
        
    }
    
    // celda.nombreListaLabel.text=[datosLista objectForKey:@"descripcion"];
    //celda.visibleLabel.text=[datosLista objectForKey:@"compartida"];
    
    
    //NSNumber *valoracion= [NSNumber numberWithDouble:[datosLista objectForKey:@"notamedia"]];
    
    //celda.valoracionLabel.text=[NSString stringWithFormat:@"%.2f", [datosLista[@"notamedia"] floatValue]];
    
    celda.nombreEstablecimiento.text = [datosEstablecimiento objectForKey:@"name"];
    NSMutableArray *categoria = [datosEstablecimiento objectForKey:@"categories"];
    
    
    if ([categoria count]>0) {
   
    
    NSDictionary *datoscategoria = [categoria objectAtIndex:0];
    
    
     NSString *url = [NSString stringWithFormat:@"%@",[datoscategoria objectForKey:@"icon"]];
    
        
    [celda.imagenEstablecimiento setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    }
    
    
    return celda;
    
    
    
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSDictionary *datosEstablecimiento = [listadoEstablecimientos objectAtIndex:indexPath.row];
    
    [self.delegate doSeleccion:datosEstablecimiento];
    
    [self.navigationController popViewControllerAnimated:YES];    
    
    
}





- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar{

 
    CLLocation *location= locationManager.location;
    NSString *coordenadas=[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    NSString *texto= _buscadorText.text;
    
    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=%@&client_id=%@&client_secret=%@",coordenadas,texto,clientID,clientSecret];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarURL:url];
    
    NSLog(@"respuesta: %d",[respuesta.response statusCode]);
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            respuestaFourSquare = [responseData objectFromJSONString];
            NSDictionary *response = [respuestaFourSquare objectForKey:@"response"];
            
            NSMutableArray *grupos = [response objectForKey:@"groups"];
            NSMutableArray *establecimientos = [grupos mutableArrayValueForKeyPath:@"items"];
            // NSLog(@"%d",[listasUsuario count]);
            //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
            //  [self.refreshControl endRefreshing];
            
            listadoEstablecimientos = [establecimientos objectAtIndex:0];
            NSLog(@"%d",[listadoEstablecimientos count]);
            
            
            [_tabla reloadData];
        });
    }
    else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            Utils *utilidad = [[Utils alloc]init];
            [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
            // [activityIndicator stopAnimating];
        });
    }
    
    
    
    
    
    
}









@end
