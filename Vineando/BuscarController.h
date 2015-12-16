//
//  BuscarController.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 02/02/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuscarController : UIViewController {
    
    int primeravez;
    
}

@property (nonatomic,retain) NSMutableArray *listavinos;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UITableView *tabla;

@property (weak, nonatomic) IBOutlet UISearchBar *buscador;


@end
