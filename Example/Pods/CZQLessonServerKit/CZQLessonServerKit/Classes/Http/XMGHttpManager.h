//
//  XMGHttpManager.h
//  码哥课堂
//
//  Created by yz on 2016/12/11.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGHttpManager : NSObject


+ (void)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task , id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task , NSError * error))failure;

@end
