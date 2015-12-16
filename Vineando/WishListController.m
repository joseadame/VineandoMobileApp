//
//  WishListController.m
//  Vineando
//
//  Created by Jose Adame on 18/05/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "WishListController.h"
#import "CeldaVino.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "RestEngine.h"
#import "JSONKit.h"
#import "Utils.h"
#import "PerfilVinoController.h"


@interface WishListController (){


    NSMutableArray *wishlist;



}

@end




@implementation WishListController


@synthesize tabla;

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
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Desliza para refrescar..."];
    
    [refresh addTarget:self
                action:@selector(cargarWishList:)
      forControlEvents:UIControlEventValueChanged];
    
    
    self.refreshControl = refresh;
    [self.tabla addSubview:refresh];
    
    [self setTitle:@"Whislist"];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Obteniendo wishlist...";
    [HUD showAnimated:YES whileExecutingBlock:^{
    
    [self cargarWishList:refresh];
    
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)cargarWishList:(UIRefreshControl*)refresh{

    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Actualizando..."];
    NSDateFormatter *formateador = [[NSDateFormatter alloc]init];
    [formateador setDateFormat:@"MMM d,hh:mm a"];
    NSString *ultimafecha = [NSString stringWithFormat:@"Ultima actualización %@ ",[formateador stringFromDate:[NSDate date]]];
    
    // llamamos al servicio para recuperar las listas del usuario.
    //recuperamos el id del usuario para buscar sus listas.
    NSDictionary *usuario = ApplicationDelegate.usuario;
    NSString *url = [NSString stringWithFormat:@"usuario/wishlist/%@",[usuario objectForKey:@"id"]];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            wishlist = [[responseData objectFromJSONString] mutableCopy];
        
            NSLog(@"%d",[wishlist count]);
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
            [self.refreshControl endRefreshing];
        
        [tabla reloadData];
        });
        
    }
    else{
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
        // [activityIndicator stopAnimating];
        
    }
    










}



//meotodos delegados de UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    if ([wishlist count]==0)
    {
        return 0;
    }
    else{
        
        return [wishlist count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CeldaVino *celda = [tableView dequeueReusableCellWithIdentifier:@"celdaVino"];
    
    
    NSDictionary *datosLista = [wishlist objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[CeldaVino alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celdaVino"];
        
    }
    
   
    
    celda.nombreVino.text = [datosLista objectForKey:@"nombre"];
    celda.anioVino.text=[datosLista objectForKey:@"anio"];
    celda.denominacion.text=[datosLista objectForKey:@"zona"];
    //hay que convertir el double a string
    
    celda.puntuacion.text= [NSString stringWithFormat:@"%.2f",[datosLista[@"notamedia"] floatValue]];
    celda.tipovino.text=[datosLista objectForKey:@"tipovino"];
    NSString *url = [NSString stringWithFormat:@"%@",[datosLista objectForKey:@"rutaimagen"]];
    
    
    
    [celda.imagenVino setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    
    return celda;
    
    
    
    
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
        
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.tag=7;
        [self.view addSubview:HUD];
        HUD.delegate=self;
        HUD.labelText=@"Borrando vino...";
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            
            NSDictionary *datosLista = [wishlist objectAtIndex:indexPath.row];
            NSDictionary *usuario = ApplicationDelegate.usuario;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[usuario objectForKey:@"id"]], @"idlista",[datosLista objectForKey:@"idvino"],@"idvino",nil];
            
            NSString *post = [dic JSONString];
            
            
            
            
            NSString *url = [NSString stringWithFormat:@"usuario/borrarVinoWhislist"];
            
            RestEngine *rest = [[RestEngine alloc]init];
            
            RespuestaREST *respuestaREST = [rest llamarServicioREST:post url:url];
            
            NSLog(@"response %d",[respuestaREST.response statusCode]);
            
            
            if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                NSDictionary *loginResult = [responseData objectFromJSONString];
                NSString *status = [loginResult objectForKey:@"status"];
                
                NSLog(@"hemos deserializado %@",status);
                
                
                if ([status isEqualToString:@"OK"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //Si todo ha ido bien eliminamos la lista del array de listas obtenidas y refrescamos la tabla.
                        [wishlist removeObjectAtIndex:indexPath.row];
                        
                        [tabla reloadData];
                        
                    });
                    
                    
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Utils *utilidad = [[Utils alloc] init];
                        [utilidad alertStatus:status titulo:@"Error al eliminar el vino de tu wishlist"];
                    });
                }
                
                
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    Utils *utilidad = [[Utils alloc]init];
                    [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
                });
            }
            
            
            
            
            
            
            
            
        }];
        
        
        
        
        
        
        
        
        
        
        
        
    }
}












-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    //cogemos los datos del vino seleccionado en la lista.
    if ([segue.identifier isEqualToString:@"perfilVino"]) {
        
        NSDictionary *datos = [wishlist objectAtIndex:[self.tabla indexPathForSelectedRow].row];
        // *perfilvino = [[PerfilVinoController alloc]init];
        PerfilVinoController *perfilvino = [segue destinationViewController];
        [perfilvino setDatosVino:datos];
        
        
    }




}








@end
