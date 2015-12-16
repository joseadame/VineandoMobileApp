//
//  ComentariosViewController.h
//  Vineando
//
//  Created by Jose Adame on 06/06/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComentariosViewController : UIViewController{

    int idvino;


}

@property (nonatomic,retain) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tablaComentarios;

-(void)setIdVino:(int)id;



@end
