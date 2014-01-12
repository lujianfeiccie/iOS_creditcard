//
//  CellAndImage.h
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCell.h"
#import "Good.h"
@interface CellAndImage : NSObject
{
    UIImageView* imageView;
    NSString* image_url;
}
@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) NSString* image_url;
-(UIImageView*) getImageView;
-(NSString*) getImageUrl;
@end
