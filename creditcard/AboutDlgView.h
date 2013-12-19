//
//  AboutDlgView.h
//  creditcard
//
//  Created by Apple on 13-12-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"
#import "AppDelegate.h"
@interface AboutDlgView : UIViewController
{
NSTimer *updateTimer;  //timer对象
    NSUInteger red,green,blue;
    CGFloat alpha;
    BOOL show;
    NSUInteger count;
}
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *label_line1;

@property (weak, nonatomic) IBOutlet UILabel *label_line2;
@end
