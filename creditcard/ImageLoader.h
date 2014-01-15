//
//  ImageLoader.h
//  creditcard
//
//  Created by Apple on 14-1-12.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLoader : NSObject
{
    NSMutableDictionary *ImageCache;
    //压缩图片
    CGSize ImageSize;
    //线程池
    NSOperationQueue* queue;
}
-(void)displayImage: (UIImageView*) imageView ImageUrl :(NSString*) imageUrl TableView :(UITableView*) tableView;
-(void)ClearCache;
@end
