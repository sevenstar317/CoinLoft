//
//  Created by Fahad Azeem on 02/02/2015.
//  Copyright (c) 2015. All rights reserved.
//

#import "NetworkManager.h"
#define BASE_URL @"https://devretailapi.coinloft.com.au/v1"
#define KEY @"AUTHENTICATION"
//#define VALUE @"HMAC ANDRIY:fupcoins:jRZmut6l"

@implementation NetworkManager

static NetworkManager *_sharedClient = nil;
+ (NetworkManager *)sharedNetworkClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
    });
    return _sharedClient;
    
}

- (id)initWithBaseURL:(NSURL *)url {
    
    if (self = [super initWithBaseURL:url]) {
        _manager = [[AFHTTPSessionManager manager] initWithBaseURL:url];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

- (void)processGetRequestWithPath:(NSString *)path parameter:(NSDictionary *)parameter
                          success:(NetworkClientSuccessBlock) successBlock
                          failure:(NetworkClientFailureBlock) failureBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *merchantCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantCode"];
    NSString *nonce = [[NSUserDefaults standardUserDefaults] objectForKey:@"nonce"];
    NSString *hash = [[NSUserDefaults standardUserDefaults] objectForKey:@"hash"];
    
    if (merchantCode) {
        NSString *value = [NSString stringWithFormat:@"HMAC %@:%@:%@", merchantCode,hash,nonce];
        [_manager.requestSerializer setValue:value forHTTPHeaderField:KEY];
    }
    
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = parameter==nil? [NSMutableDictionary dictionary] : [NSMutableDictionary dictionaryWithDictionary:parameter];
    
    [self.manager GET:path parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            [_manager.requestSerializer setValue:NULL forHTTPHeaderField:KEY];
            successBlock(200, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            [_manager.requestSerializer setValue:NULL forHTTPHeaderField:KEY];
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger statusCode = response.statusCode;

            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) {
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                failureBlock((int)statusCode,errorResponse[@"message"], error);
            } else {
                failureBlock((int)statusCode,error.localizedDescription, error);
            }
            
        }
    }];

    
}


- (void)processUXDataRequestWithPath:(NSString *)path parameter:(NSDictionary *)parameter
                          success:(NetworkClientSuccessBlock) successBlock
                          failure:(NetworkClientFailureBlock) failureBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *merchantCode = @"RETAILIOS";
    NSString *merchantPassword = @"b9340dc322623960713caaf7b96ba895fe826d48";
    
    NSString *value = [NSString stringWithFormat:@"HMAC %@:fupcoins:%@", merchantCode ,merchantPassword];
    [_manager.requestSerializer setValue:value forHTTPHeaderField:KEY];
    
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = parameter==nil? [NSMutableDictionary dictionary] : [NSMutableDictionary dictionaryWithDictionary:parameter];
    
    [self.manager GET:path parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            [_manager.requestSerializer setValue:NULL forHTTPHeaderField:KEY];
            successBlock(200, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            [_manager.requestSerializer setValue:NULL forHTTPHeaderField:KEY];
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger statusCode = response.statusCode;
            
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) {
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                failureBlock((int)statusCode,errorResponse[@"message"], error);
            } else {
                failureBlock((int)statusCode,@"An error occurred", error);
            }
            
        }
    }];
    
    
}

- (void)processPostRequestWithPath:(NSString *)path parameter:(NSDictionary*)parameter
                           success: (NetworkClientSuccessBlock) successBlock
                           failure:(NetworkClientFailureBlock) failureBlock {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *merchantCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"merchantCode"];
    NSString *nonce = [[NSUserDefaults standardUserDefaults] objectForKey:@"nonce"];
    NSString *hash = [[NSUserDefaults standardUserDefaults] objectForKey:@"hash"];
    
    if (merchantCode) {
        NSString *value = [NSString stringWithFormat:@"HMAC %@:%@:%@", merchantCode,hash,nonce];
        [_manager.requestSerializer setValue:value forHTTPHeaderField:KEY];
    }
    
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableDictionary *param = parameter==nil? [NSMutableDictionary dictionary] : [NSMutableDictionary dictionaryWithDictionary:parameter];

    [self.manager POST:path parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            [_manager.requestSerializer setValue:NULL forHTTPHeaderField:KEY];
            successBlock(200, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock){
            [_manager.requestSerializer setValue:NULL forHTTPHeaderField:KEY];
            NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
            NSInteger statusCode = response.statusCode;
            
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) {
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                int code = [errorResponse[@"code"] intValue];
                failureBlock(code,errorResponse[@"message"], error);
            } else {
                failureBlock((int)statusCode,@"An error occurred", error);
            }
        }
    }];
}


@end
