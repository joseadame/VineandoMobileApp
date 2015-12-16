//
//  VinosEnListaController.h
//  Vineando
//
//  Created by Jose Adame on 10/04/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface VinosEnListaController : UIViewController <MBProgressHUDDelegate>{

    NSString *nombreLista;
    int idlista;
    NSMutableArray *listaVinos;
    MBProgressHUD *HUD;

}

@property (weak, nonatomic) IBOutlet UITableView *tabla;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) UIRefreshControl *refreshControl;

-(void)setIdLista:(int)idlistavinos;
-(void)setNombreLista:(NSString *)nombre;

@end
