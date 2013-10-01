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
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:response
                                                 encoding:NSUTF8StringEncoding];
    [delegate onMsgReceive:jsonString];
 }

@end



