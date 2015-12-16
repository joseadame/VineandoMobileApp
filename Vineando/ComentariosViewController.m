//
//  ComentariosViewController.m
//  Vineando
//
//  Created by Jose Adame on 06/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "ComentariosViewController.h"
#import "RestEngine.h"
#import "Utils.h"
#import "JSONKit.h"
#import "comentarioCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "NuevoComentarioViewController.h"


@interface ComentariosViewController (){

    NSMutableArray *listaComentarios;


}

@end

@implementation ComentariosViewController

@synthesize tablaComentarios;

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
    
    
    //configuramos los espacios entre comentarios.
    self.tablaComentarios.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    
    self.tablaComentarios.separatorColor = [UIColor clearColor];
    
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];    
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Desliza para refrescar..."];
    
    [refresh addTarget:self
                action:@selector(cargarComentarios:)
      forControlEvents:UIControlEventValueChanged];
    
    
    self.refreshControl = refresh;
    [self.tablaComentarios addSubview:refresh];
    
    [self setTitle:@"Comentarios"];
   
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarVino.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self cargarComentarios:refresh];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    listaComentarios=nil;
    
}




-(void)setIdVino:(int)id{

    idvino=id;



}



-(void)cargarComentarios:(UIRefreshControl*)refresh{

    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Actualizando..."];
    NSDateFormatter *formateador = [[NSDateFormatter alloc]init];
    [formateador setDateFormat:@"MMM d,hh:mm a"];
    NSString *ultimafecha = [NSString stringWithFormat:@"Ultima actualización %@ ",[formateador stringFromDate:[NSDate date]]];
    
    // llamamos al servicio para recuperar los comentarios del usuario.
    //recuperamos el id del vino para recuperar sus comentarios.
   
   
    NSString *url = [NSString stringWithFormat:@"vino/comentarios/%d",idvino];
    NSLog(@"%@",url);
    RestEngine *restengine = [[RestEngine alloc] init];
    //llamamos al webservice para recuperar la listas del usuario.
    RespuestaREST *respuesta = [restengine llamarServicioRESTConsulta:url];
    
    if ([respuesta.response statusCode ] >=200 && [respuesta.response  statusCode] <300)
    {
        NSString *responseData = [[NSString alloc]initWithData:respuesta.urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        listaComentarios = [responseData objectFromJSONString];
        
        NSLog(@"%d",[listaComentarios count]);
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:ultimafecha];
        [self.refreshControl endRefreshing];
        
        [tablaComentarios reloadData];
        
        
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
    
    
    
    if ([listaComentarios count]==0)
    {
        return 0;
    }
    else{
        
        return [listaComentarios count];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    comentarioCell *celda = [tableView dequeueReusableCellWithIdentifier:@"comentarioCelda"];
    
    
    NSDictionary *datosComentario = [listaComentarios objectAtIndex:indexPath.row];
    
    
    if(celda == nil)
    {
        celda = [[comentarioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comentarioCelda"];
        
    }
    
    NSString *url = [NSString stringWithFormat:@"%@",[datosComentario objectForKey:@"rutaAvatar"]];
    
    
        
    [celda.imagenUsuario setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"estrella.png"]];
    
    
    
    //Redondeamos la imagen del usuario.
    celda.imagenUsuario.contentMode = UIViewContentModeScaleAspectFill;
    celda.imagenUsuario.clipsToBounds = YES;
    celda.imagenUsuario.layer.cornerRadius = 48.0f;
    celda.imagenUsuario.layer.borderWidth = 4.0f;
    celda.imagenUsuario.layer.borderColor = [UIColor whiteColor].CGColor;
    

    
    celda.textoComentario.text=[datosComentario objectForKey:@"comentario"];
   
   
    celda.fechaLabel.text = [datosComentario objectForKey:@"fecha"];    
    celda.aliasUsuario.text=[datosComentario objectForKey:@"usuario"] ;
    celda.puntuacionComentario.text=[NSString stringWithFormat:@"%@",[[datosComentario objectForKey:@"numerovotaciones"] stringValue] ];
    
    return celda;
    
    
    
    
    
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"addComentario"]) {
        
        NuevoComentarioViewController *comentario = [segue destinationViewController];
        [comentario setIdvino:idvino];
        
       
    }





}













@end
