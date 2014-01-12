//
//  CustomCell.m
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "CustomCell.h"
#import "Constants.h"
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
   /* if (![t_image isEqual:image]) {
        image = [t_image copy];
        self.imageView.image = image;
    }*/
    self.imageView.image = image;
}
-(void) initStyle{
    /*self.titleLabel.numberOfLines = 1000;
    self.noLabel.numberOfLines=1000;
    [self.imageView setFrame:CGRectMake(CELL_IMAGE_LEFT, CELL_IMAGE_TOP,CELL_IMAGE_WIDTH, CELL_IMAGE_HEIGHT)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //无色
    self.selectionStyle = UITableViewCellSelectionStyleGray;*/
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
@end
