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
#import "SVProgressHUD.h"
#import "ImageHelper.h"
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
//关于对话框
- (void) aboutDlg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于" message:@"作者：陆键霏" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}

- (void) initData{
    bank_array = [NSArray arrayWithObjects:@"平安银行", @"农业银行", @"中国银行", nil];
    
    mHttpRequestTool = [HttpRequestTool alloc]; //初始化HTTP请求类
    mHttpRequestTool.delegate = self;           //注册回调
    
    //加入标题下拉按钮
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"平安银行"];
        [menu displayMenuInView:self.view];
        menu.items = bank_array;
        menu.delegate = self;
        self.navigationItem.titleView = menu;
        
        //加入关于按钮
           UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"关于"style:UIBarButtonItemStyleBordered target:self action:@selector(aboutDlg)];
        self.navigationItem.rightBarButtonItem = backButton;
    }
    
    //加入列表
    mUITableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [mUITableView setDelegate:self];
    [mUITableView setDataSource:self];
    [self.view addSubview:mUITableView];
    
    //加入List
    NSMutableArray *MutableArray = [[NSMutableArray alloc] init];
    self.list = MutableArray;
    
    //初始化异步队列线程类
    queue = [[NSOperationQueue alloc] init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRowsInSection");
    return [self.list count];
}

//下载图片
-(void) downloadImage:(CellAndImage*) mCellAndImage{
    NSURL *imageUrl = [NSURL URLWithString:mCellAndImage.image_url];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    //压缩图片
    CGSize mCGSize = CGSizeMake(120, 120);
    UIImage* after_image = [ImageHelper image:image fitInSize:mCGSize];
    
    [[self.list objectAtIndex:mCellAndImage.index] setImage:after_image];
    [mCellAndImage.cell setImage:after_image];
    //即时更新
    [mUITableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

//Cell适配, 给每项Cell赋值
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
    
    //图片处理
    if(good.image==nil){
        CellAndImage* mCellAndImage = [[CellAndImage alloc] init];
        [mCellAndImage setCell:cell];
        [mCellAndImage setImage_url:good.image_url];
        [mCellAndImage setIndex:row];
        //加入到异步队列线程里
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:mCellAndImage];
        [queue addOperation:op];
    }else{
        //更新图片
        [cell setImage:good.image];
    }
    
    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

//选中某个Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath %ld",(long)[indexPath row]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
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

//回调方法,下拉框
- (void)didSelectItemAtIndex:(NSUInteger)index{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSString* bank = bank_array[index];
    [menu setTitle:bank];
    [self requestData:[ self getTypeId:index ]];
}

//请求服务器数据
-(void)requestData:(NSUInteger)index{
    
    NSString* request_url = [NSString stringWithFormat:@"%@?good_typeid=%i&count=10&page=1",API_URL,index];
    mHttpRequestTool.url = request_url;
    
    //NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threafunc) object:nil];
    NSThread* myThread = [[NSThread alloc] initWithTarget:mHttpRequestTool selector:@selector(startRequest) object:nil];
    [myThread start];
}


//回调方法,接收http返回json数据
-(void)onMsgReceive:(NSData*) msg
{
    NSError *error;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:msg options:NSJSONReadingMutableLeaves error:&error];
    
   
    for (Good* temp_good in self.list) { //清除旧数据
        [temp_good setImage:nil];
    }
     [self.list removeAllObjects];
    
    NSDictionary* data =[dataDic objectForKey:@"data"];//解析得到数据集
    
    for (NSDictionary* each_data in data) {//遍历数据集
        
        NSString *good_name =[each_data objectForKey:@"good_name"];
        NSString *good_integral =[each_data objectForKey:@"good_integral"];
        NSString *good_no =[each_data objectForKey:@"good_no"];
        NSString *good_imgurl =[each_data objectForKey:@"good_imgurl"];
        
        Good *good = [[Good alloc]init];
        good.title = good_name;
        good.integral = good_integral;
        good.no = good_no;
        good.image_url = good_imgurl;
        
        if(good_name==nil) continue;
        
        [self.list addObject:good];//加入到list
    }
    
    [mUITableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];//主线程更新列表数据
    
    [SVProgressHUD dismiss];//消除等待提示
}

@end
