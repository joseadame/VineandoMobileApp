//
//  PerfilUsuarioViewController.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 22/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilUsuarioViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imagenUsuario;
@property (nonatomic,retain) IBOutlet UILabel *alias;
@property (nonatomic,retain) IBOutlet UILabel *puntuacion;
@property (nonatomic,retain) IBOutlet UILabel *rango;
@property (nonatomic,retain) NSDictionary *datosUsuario;
@property (nonatomic,retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic,retain) IBOutlet UILabel *numCheckins;
@property (nonatomic,retain) IBOutlet UILabel *numLogros;
@property (nonatomic,retain) IBOutlet UILabel *numWish;


-(void)actualizarEstadisticasUsurio;


@end
