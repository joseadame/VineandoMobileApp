//
//  comentarioCell.h
//  Vineando
//
//  Created by Jose Adame on 06/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface comentarioCell : UITableViewCell


@property (nonatomic,retain) IBOutlet UIImageView *imagenUsuario;

@property (weak, nonatomic) IBOutlet UITextView *textoComentario;

@property (weak, nonatomic) IBOutlet UILabel *fechaLabel;

@property (weak, nonatomic) IBOutlet UILabel *aliasUsuario;

@property (weak,nonatomic) IBOutlet UILabel *puntuacionComentario;


@end
