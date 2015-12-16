//
//  Utils.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 22/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "Utils.h"

@implementation Utils

- (void)alertStatus:(NSString *)mensaje titulo:(NSString *)title{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:mensaje
                                                       delegate:Nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}
@end
