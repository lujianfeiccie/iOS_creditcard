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
    CustomCell* cell;
    NSUInteger index;
    NSString* image_url;
}
@property(nonatomic,retain) CustomCell* cell;
@property(nonatomic,retain) NSString* image_url;
@property(nonatomic) NSUInteger index;
@end
