//
//  Good.m
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "Good.h"

@implementation Good
@synthesize image;
@synthesize image_url;
@synthesize title;
@synthesize integral;
@synthesize no;

-(id) init{
    NSLog(@"good init");
    image = Nil;
    image_url = @"";
    title = @"";
    integral = @"";
    no = @"";
    return self;
}
@end
