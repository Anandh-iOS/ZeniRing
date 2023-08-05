//
//  OTAImgObj.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/9/7.
//

#import "OTAImgObj.h"
#import "ConfigModel.h"
NSString * const IMG_FLODER = @"devImgs";

@implementation OTAImgObj
{
    NSURLSessionDataTask *_dataTask;
    NSURLSession *_session;
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        /*
         {
             desc = "SR03 V1.0.0 TEST";
             sign = fa5e262f7c91464c6627a4c700f176c1;
             size = 37156;
             uri = "http://hccvin.com:9037/ota/6af1c8c4c0";
             ver = "1.0.0";
         }
         */
        if (dict) {
            self.desc = dict[@"desc"];
            self.sign = dict[@"sign"];
            self.size = dict[@"size"];
            self.uri = dict[@"uri"];
            self.ver = dict[@"ver"];
            
        }
        
    }
    return self;
}

-(BOOL)download {
    if (!self.uri) {
        return NO;
    }
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    NSString *cache =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *floderPath = [cache stringByAppendingFormat:@"/%@/", IMG_FLODER];
    NSString *file = [cache stringByAppendingFormat:@"/%@/%@_%@.img", IMG_FLODER, self.sign, self.ver];

    if ([fileMgr fileExistsAtPath:file]) { // 已存在
        self.sandBoxFileUrl = [NSURL fileURLWithPath:file];
        if (self.downLoadCBK) {
            self.downLoadCBK(self.sandBoxFileUrl);
        }
        return YES;
        
    }
    
    WEAK_SELF
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;//最大并发= 1 = 串行
    NSURLSession *_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:queue];
//
////
    NSURL *url = [NSURL URLWithString:self.uri];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
//    NSString *header = [NSString stringWithFormat:@"bytes=0-%zd",self.size.integerValue];
//         [request setValue:header forHTTPHeaderField:@"Range"];
//    _dataTask = [session dataTaskWithRequest:request];
//    [_dataTask resume];
    
//    NSURLSession *session = [NSURLSession sharedSession];
    //         DebugNSLog(@"文件URL: %@", location);

    NSURLSessionDownloadTask * downloadTask = [_session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        STRONG_SELF_NOT_CHECK
        DebugNSLog(@"文件URL: %@", location);
        


        BOOL exist = [fileMgr fileExistsAtPath:floderPath];
        if (!exist) {
            [fileMgr createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
//            try! fileManager.createDirectory(atPath: filePath,withIntermediateDirectories: true, attributes: nil)
        }
        
        
        NSError *  copyError;
        [fileMgr moveItemAtPath:location.path toPath:file error:&copyError];
        DebugNSLog(@"拷贝文件URL: %@", file);
        strongSelf.sandBoxFileUrl = [NSURL fileURLWithPath:file];
        if (strongSelf.downLoadCBK) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.downLoadCBK(strongSelf.sandBoxFileUrl);

            });
        }
        
    }];
    [downloadTask resume];
    
    return YES;
}

#pragma mark -- NSURLSessionDelegate
//01 接收到响应的时候调用，每发送一次请求就会调用一次该方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                                 didReceiveResponse:(NSURLResponse *)response
                                  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    DebugNSLog(@"本次请求大小 %lld",  response.expectedContentLength);
    
    
    completionHandler(NSURLSessionResponseAllow);
}

//02 接收服务器返回的数据 （可能调用多次）
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    DebugNSLog(@"下载 size:%lu", (unsigned long)data.length);
    
}


//03 结束
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    DebugNSLog(@"下载结束!");
}

@end
