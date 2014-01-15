//
//  CellAndImage.m
//  creditcard
//
//  Created by Apple on 13-10-4.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "CellAndImage.h"

@implementation CellAndImage
@synthesize imageView;
@synthesize image_url;
@synthesize tableView;
-(UIImageView*) getImageView{
    return imageView;
}
-(NSString*) getImageUrl{
    return image_url;
}
-(NSString*) getTableView{
    return tableView;
}
@end
