//
//  NetworkManager.h
//  
//
//  Created by Fahad Azeem on 02/02/2015.
//  Copyright (c) 2015 Informerly. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

///// Convenient macros for AF Network blocks
//typedef void (^AFHTTPClientSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
//typedef void (^AFHTTPClientFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
//
//
//// Convenient macros for Network blocks
typedef void (^NetworkClientSuccessBlock) (int requestStatus, id processedData);
typedef void (^NetworkClientFailureBlock) (int requestStatus,NSString *msg, NSError *error);


@interface NetworkManager : AFHTTPSessionManager

@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSString *baseUrl;

+ (NetworkManager *)sharedNetworkClient;

- (void)processGetRequestWithPath:(NSString *)path parameter:(NSDictionary *)parameter
                          success: (NetworkClientSuccessBlock) successBlock
                          failure:(NetworkClientFailureBlock) failureBlock;

- (void)processUXDataRequestWithPath:(NSString *)path parameter:(NSDictionary *)parameter
                             success: (NetworkClientSuccessBlock) successBlock
                             failure:(NetworkClientFailureBlock) failureBlock;

- (void)processPostRequestWithPath:(NSString *)path parameter:(NSDictionary *)parameter
                           success: (NetworkClientSuccessBlock) successBlock
                           failure:(NetworkClientFailureBlock) failureBlock;


@end
