//
//  VinosEnListaController.m
//  Vineando
//
//  Created by Jose Adame on 10/04/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "VinosEnListaController.h"
#import "CeldaVino.h"
#import "Utils.h"
#import "RestEngine.h"
#import "JSONKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PerfilVinoController.h"

@interface VinosEnListaController ()

@end

@implementation VinosEnListaController

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
                action:@selector(obtenerVinosLista:)
      forControlEvents:UIControlEventValueChanged];
    
    
    self.refreshControl = refresh;
    [self.tabla addSubview:refresh];
    
    
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.topItem.title=@"Tus listas";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.title=nombreLista;
    
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Obteniendo vinos...";
     [HUD showAnimated:YES whileExecutingBlock:^{
         [self obtenerVinosLista:refresh];
    
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIdLista:(int)idlistavinos{

    idlista=idlistavinos;


}

-(void)setNombreLista:(NSString *)nombre{

    nombreLista=nombre;

}


-(void)obtenerVinosLista:(UIRefreshControl *)refresh{


    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Actualizando..."];
    NSDateFormatter *formateador = [[NSDateFormatter alloc]init];
    [formateador setDateFormat:@"MMM d,hh:mm a"];
    NSString *ultimafecha = [NSString stringWithFormat:@"Ultima actualización %@ ",[formateador stringFromDate:[NSDate date]]];
    
   
    NSString *url = [NSString stringWithFormat:@"usuario/listas/%d",idlista];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            listaVinos = [[responseData objectFromJSONString] mutableCopy];
        
            NSLog(@"%d",[listaVinos count]);
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
            [self.refreshControl endRefreshing];
        
            [_tabla reloadData];
        });
        
    }
    else{
         dispatch_async(dispatch_get_main_queue(), ^{
            Utils *utilidad = [[Utils alloc]init];
             [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
       
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
    
    if ([listaVinos count]==0)
    {
        return 0;
    }
    else{
        
        return [listaVinos count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CeldaVino *celda = [tableView dequeueReusableCellWithIdentifier:@"celdaVino"];
    
    
    NSDictionary *datosLista = [listaVinos objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[CeldaVino alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celdaVino"];
        
    }
    
   // celda.nombreListaLabel.text=[datosLista objectForKey:@"descripcion"];
    //celda.visibleLabel.text=[datosLista objectForKey:@"compartida"];
    
    
    //NSNumber *valoracion= [NSNumber numberWithDouble:[datosLista objectForKey:@"notamedia"]];
    
    //celda.valoracionLabel.text=[NSString stringWithFormat:@"%.2f", [datosLista[@"notamedia"] floatValue]];
    
    celda.nombreVino.text = [datosLista objectForKey:@"nombre"];
    celda.anioVino.text=[datosLista objectForKey:@"anio"];
    celda.denominacion.text=[datosLista objectForKey:@"zona"];
    //hay que convertir el double a string
    
    celda.puntuacion.text= [NSString stringWithFormat:@"%.2f",[datosLista[@"notamedia"] floatValue]];
    celda.tipovino.text=[datosLista objectForKey:@"tipovino"];
    NSString *url = [NSString stringWithFormat:@"%@",[datosLista objectForKey:@"rutaimagen"]];
    
    //NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    //UIImage *myimage = [[UIImage alloc] initWithData:imageData];
    
    //celda.imagenVino.image = myimage;
    
    [celda.imagenVino setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    
    return celda;
    
   
    
    
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        //borramos la lista del usuario.
        
        HUD=[[MBProgressHUD alloc]initWithView:self.view];
        HUD.tag=7;
        [self.view addSubview:HUD];
        HUD.delegate=self;
        HUD.labelText=@"Borrando vino...";
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            
            NSDictionary *datosLista = [listaVinos objectAtIndex:indexPath.row];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",idlista], @"idlista",[datosLista objectForKey:@"idvino"],@"idvino",nil];
            
            NSString *post = [dic JSONString];
            
            
            
            
            NSString *url = [NSString stringWithFormat:@"lista/borrarvino"];
            
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
                    [listaVinos removeObjectAtIndex:indexPath.row];
                    
                    [_tabla reloadData];
                    
                     });
                    
                    
                    
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Utils *utilidad = [[Utils alloc] init];
                        [utilidad alertStatus:status titulo:@"Registro fallido"];
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

    if ([segue.identifier isEqualToString:@"perfilVino"]) {
        
        NSDictionary *datos = [listaVinos objectAtIndex:[self.tabla indexPathForSelectedRow].row];
        // *perfilvino = [[PerfilVinoController alloc]init];
        PerfilVinoController *perfilvino = [segue destinationViewController];
        [perfilvino setDatosVino:datos];
        
        
    }



}









@end
