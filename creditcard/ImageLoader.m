//
//  ImageLoader.m
//  creditcard
//
//  Created by Apple on 14-1-12.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "ImageLoader.h"
#import "ImageHelper.h"
#import "Constants.h"
#import "CellAndImage.h"
@implementation ImageLoader
-(id) init{
    ImageCache = [[NSMutableDictionary alloc] init];
    ImageSize = CGSizeMake(CELL_IMAGE_WIDTH, CELL_IMAGE_HEIGHT);
    queue = [[NSOperationQueue alloc]init];
    [queue setMaxConcurrentOperationCount:5];
    return self;
}
-(void)displayImage: (UIImageView*) imageView ImageUrl :(NSString*) imageUrl TableView :(UITableView*) tableView{
   UIImage* image = [ImageCache objectForKey:imageUrl];
    if(image!=Nil){
        imageView.image = image;
    }else{
        [self getImage:imageView ImageUrl:imageUrl TableView:tableView];
    }
}
-(void) getImage:(UIImageView*) imageView ImageUrl :(NSString*) imageUrl TableView :(UITableView*) tableView{
    
    //NSLog(@"width=%f height%f",ImageSize.width,ImageSize.height);
    
    imageView.image = [ImageHelper image:[UIImage imageNamed:@"loading.png"] fitInSize:ImageSize];
    
    CellAndImage* mCellAndImage = [[CellAndImage alloc] init];
    
    [mCellAndImage setImageView:imageView];
    [mCellAndImage setImage_url:imageUrl];
    [mCellAndImage setTableView:tableView];
    
    NSOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getImageByUrl:) object:mCellAndImage];
    
    [queue addOperation:op];
    
   /* NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(getImageByUrl:) object:mCellAndImage];
    [myThread start];*/
    
}
-(void) getImageByUrl:(CellAndImage*) mCellAndImage{
    NSURL *Url = [NSURL URLWithString:[mCellAndImage getImageUrl]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:Url]];
    
    UIImage* after_image = [ImageHelper image:image fitInSize:ImageSize];
   // NSLog(@"after width=%f height=%f",after_image.size.width,after_image.size.height);
    [ImageCache setObject:after_image forKey:[mCellAndImage getImageUrl]];//加入到缓存中

    [mCellAndImage.getImageView performSelectorOnMainThread:@selector(image) withObject:after_image waitUntilDone:YES];//在主线程中加载图片
    
    [mCellAndImage.getTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    image = nil;
}
-(void)ClearCache{
    [ImageCache removeAllObjects];
    ImageCache = nil;
}
@end
