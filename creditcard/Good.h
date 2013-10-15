//
//  Good.h
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Good : NSObject{
UIImage *image;
NSString *image_url;
NSString *title;
NSString *integral;
NSString *no;
NSString *cash;
}
@property(nonatomic) UIImage *image;
@property(nonatomic) NSString *image_url;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *integral;
@property(nonatomic) NSString *no;
@property(nonatomic) NSString *cash;
@end
