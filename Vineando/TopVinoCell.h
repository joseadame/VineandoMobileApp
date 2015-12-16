//
//  TopVinoCell.h
//  Vineando
//
//  Created by Jose Adame on 05/10/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopVinoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *nombreVino;

@property (weak, nonatomic) IBOutlet UILabel *anioVino;

@property (weak, nonatomic) IBOutlet UILabel *tipoVino;

@property (weak, nonatomic) IBOutlet UILabel *denominacion;

@property (weak, nonatomic) IBOutlet UILabel *puntuacion;


@property (weak, nonatomic) IBOutlet UILabel *posicion;



@end
