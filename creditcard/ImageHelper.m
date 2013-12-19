//
//  ImageHelper.m
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize
{
    CGFloat scale;
    CGSize newsize = thisSize;
    
    if (newsize.height && (newsize.height > aSize.height))
    {
        scale = aSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    if (newsize.width && (newsize.width >= aSize.width))
    {
        scale = aSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    return newsize;
}

+ (UIImage *) image: (UIImage *) image fitInSize: (CGSize) viewsize
{
    // calculate the fitted size
    CGSize size = [ImageHelper fitSize:image.size inSize:viewsize];
    
    UIGraphicsBeginImageContext(viewsize);
    
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}
+ (void) setToolBarBtn:(UIBarButtonItem*) btn{
    [btn setBackgroundImage:[UIImage imageNamed:@"toolbar_btn.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"toolbar_btn_s.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    [btn setTintColor:[UIColor whiteColor]];
}
@end
