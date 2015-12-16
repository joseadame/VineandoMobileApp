//
//  LogrosController.h
//  Vineando
//
//  Created by Jose Adame on 18/05/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface LogrosController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>{


     MBProgressHUD *HUD;

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;




@end
