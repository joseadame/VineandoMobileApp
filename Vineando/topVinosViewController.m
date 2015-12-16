//
//  topVinosViewController.m
//  Vineando
//
//  Created by Jose Adame on 05/10/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "topVinosViewController.h"
#import "RestEngine.h"
#import "Utils.h"
#import "JSONKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TopVinoCell.h"


@interface topVinosViewController (){


    NSMutableArray *topVinos;
    CLLocationManager *locationManager;


}

@end

@implementation topVinosViewController

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
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Avenir-Black" size:18.0f], NSFontAttributeName,
                                                                     nil]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Desliza para refrescar..."];
    
    [refresh addTarget:self
                action:@selector(cargarTopVinos:)
      forControlEvents:UIControlEventValueChanged];
    
    
    self.refreshControl = refresh;
    [self.tabla addSubview:refresh];
    
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Obteniendo top vinos...";
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        [self cargarTopVinos:refresh];
        
    }];
    
    
    //cargamos la localizacion del usuario para centrar el mapa.
    
    if (locationManager==nil) {
        locationManager =[[CLLocationManager alloc] init];
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














-(void)cargarTopVinos:(UIRefreshControl*)refresh{

    
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Actualizando..."];
    NSDateFormatter *formateador = [[NSDateFormatter alloc]init];
    [formateador setDateFormat:@"MMM d,hh:mm a"];
    NSString *ultimafecha = [NSString stringWithFormat:@"Ultima actualización %@ ",[formateador stringFromDate:[NSDate date]]];
    
    // llamamos al servicio para recuperar las listas del usuario.
    
    
    NSString *url = [NSString stringWithFormat:@"ranking/topPuntuacionVinos"];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            topVinos = [[responseData objectFromJSONString] mutableCopy];
            
            NSLog(@"%d",[topVinos count]);
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
            [self.refreshControl endRefreshing];
            
            
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
    
    if ([topVinos count]==0)
    {
        return 0;
    }
    else{
        
        return [topVinos count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopVinoCell *celda = [tableView dequeueReusableCellWithIdentifier:@"topVinoCell"];
    
    
    NSDictionary *datosvino = [topVinos objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[TopVinoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topVinoCell"];
        
    }
   
    
    int posicion=indexPath.row+1;
    celda.posicion.text=[NSString stringWithFormat:@"%d",posicion];
    celda.nombreVino.text=[datosvino objectForKey:@"nombre"];
    celda.tipoVino.text=[datosvino objectForKey:@"tipovino"];
    celda.anioVino.text=[datosvino objectForKey:@"anio"];
    celda.denominacion.text=[datosvino objectForKey:@"zona"];
    celda.puntuacion.text=[NSString stringWithFormat:@"%.2f",[[datosvino objectForKey:@"notamedia"]floatValue]];


    return celda;
    
    
    
    
}











@end
