//
//  CeldaLista.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 10/03/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CeldaLista : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nombreListaLabel;
@property (weak, nonatomic) IBOutlet UILabel *visibleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valoracionLabel;


@end
