//
//  RespuestaREST.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 22/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespuestaREST : NSObject
 
@property(nonatomic,retain) NSData *urlData;
@property (nonatomic,retain)NSHTTPURLResponse *response;
@property (nonatomic,retain) NSError *error;

@end
