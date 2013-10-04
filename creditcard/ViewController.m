//
//  ViewController.m
//  creditcard
//
//  Created by Apple on 13-9-29.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "CustomCell.h"
#import "Good.h"
#import "CellAndImage.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize list = _list;
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
    
    mUITableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [mUITableView setDelegate:self];
    [mUITableView setDataSource:self];
    [self.view addSubview:mUITableView];
    
    NSMutableArray *MutableArray = [[NSMutableArray alloc] init];
    self.list = MutableArray;
   
    [mUITableView separatorStyle ];
    //queue = [[NSOperationQueue alloc] init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        NSLog(@"numberOfRowsInSection");
    return [self.list count];
}
-(UIImage*) getImageByUrl:(NSString*) temp_image_url{
    NSURL *imageUrl = [NSURL URLWithString:temp_image_url];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    return image;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CustomCellIdentifier];
 
    NSUInteger row = [indexPath row];

    
    Good *good =[self.list objectAtIndex:row];
   
    [cell initStyle];
    [cell setTitle:good.title];
    [cell setIntegral:good.integral];
    [cell setNo:good.no];
    
    if(good.image!=nil){
      /*
       NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:mCellAndImage];
     [queue addOperation:op];*/
        [cell setImage:good.image];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath %ld",(long)[indexPath row]);
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
   
   // [self.list performSelectorOnMainThread:@selector(addObject:) withObject:@"wokao" waitUntilDone:YES]; //addObject:@"wokao"];
}
-(void) threafunc{
    [mHttpRequestTool startRequest];
}

-(void)requestData:(NSUInteger)index{
    
    NSString* request_url = [NSString stringWithFormat:@"%@?good_typeid=%i&count=10&page=1",API_URL,index];
    mHttpRequestTool.url = request_url;
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threafunc) object:nil];
    [myThread start];
}


//回调方法
-(void)onMsgReceive:(NSData*) msg
{
       NSError *error;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:msg options:NSJSONReadingMutableLeaves error:&error];

    [self.list removeAllObjects];
    for (NSDictionary* temp_data in [dataDic objectForKey:@"data"]) {
       
        NSString *good_name =[temp_data objectForKey:@"good_name"];
        NSString *good_integral =[temp_data objectForKey:@"good_integral"];
        NSString *good_no =[temp_data objectForKey:@"good_no"];
        NSString *good_imgurl =[temp_data objectForKey:@"good_imgurl"];
        Good *good = [[Good alloc]init];
        good.title = good_name;
        good.integral = good_integral;
        good.no = good_no;
        good.image = [self getImageByUrl:good_imgurl];
        if(good_name==nil) continue;
        
        [self.list addObject:good];
    }
    [mUITableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
