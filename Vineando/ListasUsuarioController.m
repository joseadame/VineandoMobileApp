//
//  ListasUsuarioController.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 17/02/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "ListasUsuarioController.h"
#import "AppDelegate.h"
#import "RespuestaREST.h"
#import "RestEngine.h"
#import "JSONKit.h"
#import "CeldaLista.h"
#import "Utils.h"
#import "VinosEnListaController.h"
#import "CrearListaViewController.h"

@interface ListasUsuarioController ()





@end




@implementation ListasUsuarioController

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
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], UITextAttributeTextColor,
                                                                     [UIFont fontWithName:@"Avenir-Black" size:18.0f], UITextAttributeFont,
                                                                     nil]];
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Desliza para refrescar..."];
    
    [refresh addTarget:self
                action:@selector(obtenerListasUsuario:)
     forControlEvents:UIControlEventValueChanged];

    
     self.refreshControl = refresh;
    [self.tabla addSubview:refresh];
    
    [self setTitle:@"Tus listas"];
    
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    HUD=[[MBProgressHUD alloc]initWithView:self.view];
    HUD.tag=7;
    [self.view addSubview:HUD];
    HUD.delegate=self;
    HUD.labelText=@"Obteniendo listas...";
    
    [HUD showAnimated:YES whileExecutingBlock:^{
     
    [self obtenerListasUsuario:refresh];
    
    }];
    
    
}



//Metodo para recuperar las listas del usuario.

-(void)obtenerListasUsuario:(UIRefreshControl *)refresh{

    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Actualizando..."];
    NSDateFormatter *formateador = [[NSDateFormatter alloc]init];
    [formateador setDateFormat:@"MMM d,hh:mm a"];
    NSString *ultimafecha = [NSString stringWithFormat:@"Ultima actualización %@ ",[formateador stringFromDate:[NSDate date]]];
    
    // llamamos al servicio para recuperar las listas del usuario.
    //recuperamos el id del usuario para buscar sus listas.
    NSDictionary *usuario = ApplicationDelegate.usuario;
    NSString *url = [NSString stringWithFormat:@"usuario/%@/listas",[usuario objectForKey:@"id"]];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            listasUsuario = [[responseData objectFromJSONString] mutableCopy];
        
            NSLog(@"%d",[listasUsuario count]);
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
            [self.refreshControl endRefreshing];
            
        
            [tabla reloadData];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//metodos delegados de UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //devolvemos tantas filas como elementos tenga el array de listas de usuario.
    // return [listavinos count];
    
    if ([listasUsuario count]==0)
    {
        return 0;
    }
    else{
        
        return [listasUsuario count];
    }

    
    }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CeldaLista *celda = [tableView dequeueReusableCellWithIdentifier:@"celdaLista"];
    
    
    NSDictionary *datosLista = [listasUsuario objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[CeldaLista alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celdaLista"];
        
    }
    
    celda.nombreListaLabel.text=[datosLista objectForKey:@"descripcion"];
    celda.visibleLabel.text=[datosLista objectForKey:@"compartida"];
    
    
    //NSNumber *valoracion= [NSNumber numberWithDouble:[datosLista objectForKey:@"notamedia"]];
    
    celda.valoracionLabel.text=[NSString stringWithFormat:@"%.2f", [datosLista[@"notamedia"] floatValue]];
    
    
    
    return celda;
    
    
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
        HUD.labelText=@"Borrando lista...";
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            
            NSDictionary *datosLista = [listasUsuario objectAtIndex:indexPath.row];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[datosLista objectForKey:@"idbodega"], @"idlista",nil];
            
            NSString *post = [dic JSONString];
            
            
            
            
            NSString *url = [NSString stringWithFormat:@"lista/borrar"];
            
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
                            [listasUsuario removeObjectAtIndex:indexPath.row];
                    
                            [tabla reloadData];
                    
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

    
    if ([segue.identifier isEqualToString:@"listavinos"]) {
        
    
    
    VinosEnListaController *listavinos = [segue destinationViewController];
    
    NSDictionary *datosLista = [listasUsuario objectAtIndex:[self.tabla indexPathForSelectedRow].row];
    
    
    [listavinos setIdLista:[[datosLista objectForKey:@"idbodega"] intValue]];
    [listavinos setNombreLista:[datosLista objectForKey:@"descripcion"]];
    }
    else
    {
    
       // [self performSegueWithIdentifier:@"crearLista" sender:self];
        
        CrearListaViewController *nuevalistaView = [segue destinationViewController];
    
    }


}






- (void)viewDidUnload {
    
    
   
    
    [super viewDidUnload];
}
@end
