//
//  BuscarController.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 02/02/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "BuscarController.h"
#import "Utils.h"
#import "RestEngine.h"
#import "RespuestaREST.h"
#import "JSONKit.h"
#import "CeldaVino.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AltaVinoCell.h"
#import "PerfilVinoController.h"

@interface BuscarController ()




@end



@implementation BuscarController

@synthesize tabla;
@synthesize buscador;

@synthesize listavinos;



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
   // _navItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBarVino.png"]];
    _navItem.title=@"Buscar";
    primeravez=0;//indicamos que no hemos realizado ninguna busqueda todavia.
    tabla.alpha=1;
    [tabla reloadData];
}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBuscador:nil];
    [self setTabla:nil];
    
   
    [super viewDidUnload];
}


- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar{

//realizamos la busqueda en el servicio rest
//para realizar la busqueda al menos tienen que ser introducidos 3 caracteres
    
    int longitud = [ [buscador.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    
    if (longitud >=3)
    {
       
        [buscador resignFirstResponder];
        
        //llamamos al servicio rest para realizar la busqueda con el termino del searchbar.
        
        NSString *cadenabusqueda= [buscador.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSString *url = [NSString stringWithFormat:@"vino/buscar/%@",cadenabusqueda];
        
        NSLog(@"%@",url);
        
        RestEngine *rest = [[RestEngine alloc]init];
        RespuestaREST *respuestaREST=[rest llamarServicioRESTConsulta:url];
        
        if ([respuestaREST.response statusCode ] >=200 && [respuestaREST.response  statusCode] <300)
        {
            NSString *responseData = [[NSString alloc]initWithData:respuestaREST.urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            listavinos = [responseData objectFromJSONString];
            if ([listavinos count] > 0 ){
                
            
            NSLog(@"%d",[listavinos count]);
                primeravez=1;//indicamos que hemos realizado la busqueda.
                tabla.alpha=1;
            [tabla reloadData];
            }
            else{
                //Utils *utilidad = [[Utils alloc]init];
                //[utilidad alertStatus:@"¡¡Upps!! No se han encontrado datos para tu busqueda" titulo:@"No hay datos"];
                // [activityIndicator stopAnimating];
                tabla.alpha=1;
                primeravez=1;//indicamos que hemos realizado  la busqueda.
                [tabla reloadData];
                
            }
            
            
            
        }
        else{
            Utils *utilidad = [[Utils alloc]init];
            [utilidad alertStatus:@"Ha habido un problema de conexion" titulo:@"conexion fallida"];
           // [activityIndicator stopAnimating];
            
        }
        
        
        
        
        
        
        
    }
    else{
        
        Utils *utilidad = [[Utils alloc]init];
        [utilidad alertStatus:@"Debe introducir al menos tres caracteres para la busqueda" titulo:@"Busqueda fallida"];
        [buscador resignFirstResponder];

    }




}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
    
    if ([listavinos count]==0 && primeravez==0)
    {
        return 0;
    }
    if ([listavinos count]==0 && primeravez==1)
    {
    
        return 1;
    }
    else{
    
        return [listavinos count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
  if ([listavinos count]!=0)
    {
    CeldaVino *celda = [tableView dequeueReusableCellWithIdentifier:@"celdaVino"];
    
    
    NSDictionary *datosvino = [listavinos objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[CeldaVino alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celdaVino"];
        
    }
    
    
    celda.nombreVino.text = [datosvino objectForKey:@"nombre"];
    celda.anioVino.text=[datosvino objectForKey:@"anio"];
    celda.denominacion.text=[datosvino objectForKey:@"zona"];
    //hay que convertir el double a string
    
    celda.puntuacion.text= [NSString stringWithFormat:@"%.2f",[datosvino[@"notamedia"] floatValue]];
    celda.tipovino.text=[datosvino objectForKey:@"tipovino"];
    NSString *url = [NSString stringWithFormat:@"%@",[datosvino objectForKey:@"rutaimagen"]];
    
    //NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    //UIImage *myimage = [[UIImage alloc] initWithData:imageData];
    
    //celda.imagenVino.image = myimage;
   
    [celda.imagenVino setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
        
        return celda;
    }
    else
    {
        AltaVinoCell *celda = [tableView dequeueReusableCellWithIdentifier:@"altaVino"];
        
        
       if(celda == nil)
        {
            celda = [[AltaVinoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"altaVino"];
            
        }
        return celda;
    
    }
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //cogemos los datos del vino seleccionado en la lista.
     if ([segue.identifier isEqualToString:@"perfilVino"]) {
        
         NSDictionary *datos = [listavinos objectAtIndex:[self.tabla indexPathForSelectedRow].row];
         // *perfilvino = [[PerfilVinoController alloc]init];
         PerfilVinoController *perfilvino = [segue destinationViewController];
         [perfilvino setDatosVino:datos];
    
         
    }
    
    
    
    
    
}




@end
