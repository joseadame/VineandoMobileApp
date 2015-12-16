//
//  CheckinViewController.h
//  Vineando
//
//  Created by Jose Adame on 23/08/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelEstablecimientoViewController.h"

@interface CheckinViewController : UIViewController <UITextViewDelegate,UIGestureRecognizerDelegate,SeleccionarEstablecimientoDelegate>{

    NSDictionary *datosVino;

}


@property (weak, nonatomic) IBOutlet UITextView *comentarioText;


@property (weak, nonatomic) IBOutlet UIImageView *imagenVino;

@property (weak, nonatomic) IBOutlet UILabel *nombreVinoLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipoVinoLabel;

@property (weak, nonatomic) IBOutlet UILabel *anioVinoLabel;


@property (weak, nonatomic) IBOutlet UISlider *sliderPuntuacion;

@property (weak, nonatomic) IBOutlet UILabel *puntuacionLabel;


- (IBAction) sliderValueChanged:(UISlider *)sender;
-(void)setDatosVino:(NSDictionary*)datos;
-(void)obtenerFechaUltimaCata;
@end
