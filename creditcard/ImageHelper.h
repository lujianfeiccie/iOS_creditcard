//
//  ImageHelper.h
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface ImageHelper : NSObject
+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize;
+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize;
+ (void) setToolBarBtn:(UIBarButtonItem*) btn;
+ (void) setRect:(UIView*) view;
+ (void) setToCircle:(UIImageView*) imageView;
+ (void) setToCircleWithRing:(UIImageView*) imageView : (UIView*) view : (NSUInteger) width;
@end
