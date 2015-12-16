 //
//  RestEngine.m
//  Vineando
//
//  Created by Jose Antonio Adame Fernandez on 22/01/13.
//  Copyright (c) 2013 Jose Antonio Adame Fernandez. All rights reserved.
//

#import "RestEngine.h"
#import "RespuestaREST.h"

@implementation RestEngine




-(RespuestaREST*) llamarURL:(NSString*)urlString{


    
    
    NSURL *url=[NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RespuestaREST *respuesta = [[RespuestaREST alloc] init];
    
    
    
    [respuesta setError:error];
    [respuesta setUrlData:urlData];
    [respuesta setResponse:response];
    
    
    return respuesta;






}




//Metodo que se encarga de llamar un servicio REST (urlString) y devuelve los datos de la peticion.
-(RespuestaREST * ) llamarServicioREST:(NSString *)post url:(NSString *)urlString{
    
    //formamos la url del servicio REST.
    
    NSString *cadena = [NSString stringWithFormat:@"%@%@",BASE_URL,urlString];
    
    NSURL *url=[NSURL URLWithString:cadena];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setTimeoutInterval:10];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];    
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
   
    // RespuestaREST *respuesta = [[RespuestaREST alloc] init];
   
   /* [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
    
       
        
        [respuesta setError:error];
        [respuesta setUrlData:data];
        [respuesta setResponse:response];
    
    
    }];*/
    
    
    
    
   NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
      RespuestaREST *respuesta = [[RespuestaREST alloc] init];
    
      [respuesta setError:error];
      [respuesta setUrlData:urlData];
      [respuesta setResponse:response];
    
    
    return respuesta;

}


//llama a un servicio rest tipo GET

-(RespuestaREST * ) llamarServicioRESTConsulta:(NSString *)urlString{
    
    //NSLog(@"PostData: %@",post);
    
    //formamos la url del servicio REST.
    
    NSString *cadena = [NSString stringWithFormat:@"%@%@",BASE_URL,urlString];
    
    NSURL *url=[NSURL URLWithString:cadena];
    
   // NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    //NSLog(postData);
    
    //NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:10];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RespuestaREST *respuesta = [[RespuestaREST alloc] init];
    
    
    
    [respuesta setError:error];
    [respuesta setUrlData:urlData];
    [respuesta setResponse:response];
    
    
    return respuesta;
    




}

@end
