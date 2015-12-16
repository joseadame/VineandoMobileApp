//
//  CeldaVino.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 03/02/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CeldaVino : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *nombreVino;
@property (nonatomic,retain) IBOutlet UILabel *anioVino;
@property (nonatomic,retain) IBOutlet UILabel *puntuacion;
@property (nonatomic,retain) IBOutlet UILabel *denominacion;
@property (nonatomic,retain) IBOutlet UIImageView *imagenVino;
@property (nonatomic,retain) IBOutlet UILabel *tipovino;

@end
