//
//  ViewController.m
//  creditcard
//
//  Created by Apple on 13-9-29.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    [self initData];
    
    }
- (void) initData{
    bank_array = [NSArray arrayWithObjects:@"平安银行", @"农业银行", @"中国银行", nil];
    
    mHttpRequestTool = [HttpRequestTool alloc]; //初始化HTTP请求类
    mHttpRequestTool.delegate = self;           //注册回调
    
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"平安银行"];
        [menu displayMenuInView:self.view];
        menu.items = bank_array;
        menu.delegate = self;
        self.navigationItem.titleView = menu;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSUInteger) getTypeId:(NSUInteger)bank{
    NSUInteger result = 0;
    switch (bank) {
        case 0:
            result = 1;
            break;
        case 1:
            result = 2;
            break;
        case 2:
            result = 3;
            break;
        default:
            break;
    }
    return result;
}

//回调方法
- (void)didSelectItemAtIndex:(NSUInteger)index{
    NSString* bank = bank_array[index];
    [menu setTitle:bank];
    [self requestData:[ self getTypeId:index ]];
}
-(void) threafunc{
    [mHttpRequestTool startRequest];
}

-(void)requestData:(NSUInteger)index{
    
    NSString* request_url = [NSString stringWithFormat:@"%@?good_typeid=%i&count=2&page=1",API_URL,index];
    mHttpRequestTool.url = request_url;
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threafunc) object:nil];
    [myThread start];
}

//回调方法
-(void)onMsgReceive:(NSString*) msg
{
    NSData* jsonData = [msg dataUsingEncoding:NSASCIIStringEncoding];
    NSError *error;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];

    for (NSDictionary* temp_data in [dataDic objectForKey:@"data"]) {
        NSLog(@"%@",[temp_data objectForKey:@"good_name"]);
    }
}
@end
