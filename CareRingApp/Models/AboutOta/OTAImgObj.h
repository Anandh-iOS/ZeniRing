//
//  OTAImgObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTAImgObj : NSObject<NSURLSessionTaskDelegate>

@property(strong, nonatomic)NSString *ver; // 最新版本    1.0.3
@property(strong, nonatomic)NSString *desc; // 版本描述
@property(strong, nonatomic)NSString *uri; // 该版本下载地址，为http格式，支持断点续传
@property(strong, nonatomic)NSString *sign; //  文件的md5签名
@property(strong, nonatomic)NSString *size; // 文件长度，单位字节

@property(strong, nonatomic)NSURL *sandBoxFileUrl;

@property(copy, nonatomic) void(^downLoadCBK)(NSURL *imgFileUrl); // 下载完成回调
- (instancetype)initWithDict:(NSDictionary *)dict;

-(BOOL)download;

@end

NS_ASSUME_NONNULL_END
