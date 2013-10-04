//
//  CustomCell.m
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize image;
@synthesize title;
@synthesize integral;
@synthesize no;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)t_image {
    if (![t_image isEqual:image]) {
        image = [t_image copy];
        self.imageView.image = image;
    }
}
-(void) initStyle{
    self.titleLabel.numberOfLines = 1000;
    self.noLabel.numberOfLines=1000;
    [self.imageView setFrame:CGRectMake(0, 18,120, 120)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)setTitle:(NSString *)t_title {
    
    if (![t_title isEqual:title]) {
        title = [t_title copy];
        self.titleLabel.text = title;
    }
}
- (void)setIntegral:(NSString *)t_integral {
    if (![t_integral isEqual:integral]) {
        integral = [t_integral copy];
        self.integralLabel.text = integral;
    }
}
- (void)setNo:(NSString *)t_no {
    if (![t_no isEqual:no]) {
        no = [t_no copy];
        self.noLabel.text = no;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(0, 18,120, 120)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
@end
