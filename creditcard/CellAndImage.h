//
//  CellAndImage.h
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCell.h"
@interface CellAndImage : NSObject
{
    CustomCell* cell;
    NSString* image_url;
}
@property(nonatomic,retain) CustomCell* cell;
@property(nonatomic,retain) NSString* image_url;
@end
