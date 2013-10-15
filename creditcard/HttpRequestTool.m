//
//  HttpRequestTool.m
//  creditcard
//
//  Created by Apple on 13-10-1.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "HttpRequestTool.h"

@interface HttpRequestTool()
@end

@implementation HttpRequestTool

@synthesize delegate;
@synthesize url;

-(void)startRequest{
    if(url==nil ||
       delegate == nil){
        return;
    }
    NSError *error = Nil;
    //加载一个NSURL对象
 //   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
       NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
 
    [delegate onMsgReceive:response:error];
 }

@end



