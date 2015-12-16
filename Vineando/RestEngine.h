//
//  RestEngine.h
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 22/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RespuestaREST.h"

#define BASE_URL @"http://beta.vineando.com/ws/"

@interface RestEngine : NSObject


-(RespuestaREST * ) llamarServicioREST:(NSString *)post url:(NSString *)urlString;
-(RespuestaREST * ) llamarServicioRESTConsulta:(NSString *)urlString;
-(RespuestaREST*) llamarURL:(NSString*)urlString;

@end
