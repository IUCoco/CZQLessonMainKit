//
//  XMGHttpManager.m
//  码哥课堂
//
//  Created by yz on 2016/12/11.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "XMGHttpManager.h"
#import "AFNetworking.h"

@implementation XMGHttpManager

+ (void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 自定义请求，为JSON格式
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 自定义响应
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    mgr.responseSerializer = responseSerializer;
    
    [mgr POST:URLString parameters:parameters progress:nil success:success failure:failure];
    
}

@end
