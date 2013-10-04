//
//  Good.h
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject{
NSString *image;
NSString *title;
NSString *integral;
NSString *no;
}
@property(strong,nonatomic) NSString *image;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *integral;
@property(strong,nonatomic) NSString *no;
@end
