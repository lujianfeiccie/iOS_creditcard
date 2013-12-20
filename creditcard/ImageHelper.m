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

+ (void) setRect:(UIView*) view{
    [view setFrame:CGRECT_HAVE_NAV(view.frame.origin.x,
                                               view.frame.origin.y,
                                               view.frame.size.width,
                                               view.frame.size.height)];
}
+ (void) setToCircle:(UIImageView*) imageView{
    [imageView setFrame:CGRectMake(imageView.frame.origin.x,
                                       imageView.frame.origin.y,
                                       imageView.frame.size.width,
                                       imageView.frame.size.height)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
}
+ (void) setToCircleWithRing:(UIImageView*) imageView : (UIView*) view : (NSUInteger) width;{
    UIImageView *imageView_bg = [[UIImageView alloc] init];
    [imageView_bg setBackgroundColor:[UIColor whiteColor]];
    [imageView_bg setFrame:CGRectMake(imageView.frame.origin.x-width,
                                      imageView.frame.origin.y-width,
                                      imageView.frame.size.width + width*2,
                                      imageView.frame.size.height + width*2)];
    [ImageHelper setToCircle:imageView];
    [ImageHelper setToCircle:imageView_bg];
    [view addSubview:imageView_bg];
    [view bringSubviewToFront:imageView];
}
@end
