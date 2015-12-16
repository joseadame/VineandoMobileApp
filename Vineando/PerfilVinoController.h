//
//  PerfilVinoController.h
//  Vineando
//
//  Created by Jose Adame on 01/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilVinoController : UIViewController{

    NSDictionary *datosVino;

}



@property (weak, nonatomic) IBOutlet UIImageView *imagenVino;

@property (weak, nonatomic) IBOutlet UILabel *nombreVino;

@property (weak, nonatomic) IBOutlet UILabel *anioVino;

@property (weak, nonatomic) IBOutlet UILabel *tipoVino;

@property (weak, nonatomic) IBOutlet UILabel *puntuacionVino;

@property (weak, nonatomic) IBOutlet UILabel *bodegaVino;



- (IBAction)checkin:(id)sender;

- (IBAction)addWishList:(id)sender;

- (IBAction)buscarVino:(id)sender;

-(void)setDatosVino:(NSDictionary *)datos;






@end
