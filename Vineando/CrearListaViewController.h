//
//  CrearListaViewController.h
//  Vineando
//
//  Created by Jose Adame on 24/04/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface CrearListaViewController : UIViewController <MBProgressHUDDelegate>{

        MBProgressHUD *HUD;

}


@property (weak, nonatomic) IBOutlet UITextField *nombreListaText;

@property (weak, nonatomic) IBOutlet UISwitch *compartidaSwitch;


//metodo del boton Crear Lista.
- (IBAction)crearLista:(id)sender;

- (IBAction)pulsarSelector:(id)sender;

-(void)mostrarVistaNotificaciones:(NSMutableArray*)notificaciones;






@end
