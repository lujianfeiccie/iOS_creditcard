//
//  HttpRequestTool.h
//  creditcard
//
//  Created by Apple on 13-10-1.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//接口定义
@protocol HttpRequestToolDelegate <NSObject>
@required
-(void) onMsgReceive :(NSData*) msg :(NSError*) error;
@end

@interface HttpRequestTool : NSObject{
    id<HttpRequestToolDelegate> delegate;
    NSString* url;
}
@property(nonatomic,retain) id delegate;
@property(nonatomic,retain) NSString* url;
-(void)startRequest;
@end
