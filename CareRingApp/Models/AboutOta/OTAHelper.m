//
//  OTAHelper.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/9/7.
//

#import "OTAHelper.h"
#import "ConfigModel.h"

@implementation OTAHelper

+(OTAHelper *) Instance
{
    static OTAHelper * otahelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        otahelper = [OTAHelper new];
    });
    return otahelper;
}

-(void)otaQueryUpgrade:(NSString *)host Port:(NSString *)port Version:(NSString *)ver Cat:(NSString *)cat Pid:(NSString *)pid CBK:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error, NSDictionary* _Nullable resultDict))cbk
{
    // query_upgrade
    // query_upgrade?ver=0.0.1&cat=nexring03&pid=30300000
//    [[self class]URLEncodeString: ];
    WEAK_SELF
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/query_upgrade?ver=%@&cat=%@&pid=%@",host, port, [[self class]URLEncodeString: ver], [[self class]URLEncodeString: cat], [[self class]URLEncodeString: pid]] ];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        STRONG_SELF_NOT_CHECK
        NSDictionary* dic = nil;
        if (data)
        {
             dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        
        if (cbk) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cbk(data, (NSHTTPURLResponse *)response, error, dic);
            });
        }
        return;
    }];
    
    [sessionTask resume];

}

+(NSString *)URLEncodeString:(NSString *)string
{
    NSString * encodestring = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    //@"!$&'()*+,-./:;=?@_~%#[]"
    
    //!*'();:@&=+$,/?%#[]
    //@" !$&'()*,/:;=?@~%#[]"
    
    //    //NSLog(@"before:%@\nencode: %@",string,encodestring);
    
    
    NSMutableString * outputStr = [NSMutableString stringWithString:encodestring];
    [outputStr replaceOccurrencesOfString:@"%20" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
//      [outputStr replaceOccurrencesOfString:@"%2A" withString:@"*" options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
//      [outputStr replaceOccurrencesOfString:@"%7E" withString:@"~" options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
    
    
//    NSLog(@"before:%@\nencode: %@",encodestring,outputStr);
    return outputStr;
}

@end
