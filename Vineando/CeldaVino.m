//
//  CeldaVino.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 03/02/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "CeldaVino.h"

@implementation CeldaVino


@synthesize nombreVino;
@synthesize anioVino;
@synthesize puntuacion;
@synthesize denominacion;
@synthesize imagenVino;
@synthesize tipovino;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
