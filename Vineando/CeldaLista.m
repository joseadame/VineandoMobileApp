//
//  CeldaLista.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 10/03/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "CeldaLista.h"

@implementation CeldaLista


@synthesize nombreListaLabel;
@synthesize visibleLabel;
@synthesize valoracionLabel;



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
