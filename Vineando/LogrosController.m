//
//  LogrosController.m
//  Vineando
//
//  Created by Jose Adame on 18/05/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "LogrosController.h"
#import "LogroCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSONKit.h"
#import "AppDelegate.h"
#import "RestEngine.h"
#import "Utils.h"

@interface LogrosController ()
{

    NSMutableArray *logros;
    
   
    

}

@end

@implementation LogrosController

- (IBAction)refrescarLogros:(id)sender {
    
   
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self obtenerLogros];
    }];
  
    
}





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
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Obteniendo logros...";
    [HUD showAnimated:YES whileExecutingBlock:^{
     [self obtenerLogros];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)obtenerLogros{

    // llamamos al servicio para recuperar los logros del usuario.
    //recuperamos el id del usuario para buscar sus logros.
    NSDictionary *usuario = ApplicationDelegate.usuario;
    NSString *url = [NSString stringWithFormat:@"usuario/%@/logros",[usuario objectForKey:@"id"]];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        logros = [responseData objectFromJSONString];
        
        NSLog(@"%d",[logros count]);
       // refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
        //[self.refreshControl endRefreshing];
        
        [_collectionView reloadData];
        });
        
    }
    else{
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
        // [activityIndicator stopAnimating];
        
    }
}







-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [logros count];




}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {


    return 1;


}

-(UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
   
    
    
    

   LogroCell *celda = [_collectionView dequeueReusableCellWithReuseIdentifier:@"celdaLogro" forIndexPath:indexPath];
    
    
    NSDictionary *datoslogro = [logros objectAtIndex:indexPath.row];
    
    
    
    
    
    celda.nombreLogro.text = [datoslogro objectForKey:@"nombre"];
    
    NSString *url = [NSString stringWithFormat:@"%@",[datoslogro objectForKey:@"rutaimagen"]];
    
    
    
    [celda.imagenLogro setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    
    return celda;
    

    
    
    




}







@end
