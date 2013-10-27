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

//筛选对话框
- (void) filterDlg {
    SearchView* view = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchview"];
    view.delegate = self;
    [[self navigationController] pushViewController:view animated:YES];
}
- (void) initData{
    flagRefresh = NO;
    loadingMore = NO;
    page = 1;   //第一页
    count = 10; //每页大小为十条数据
    selectedBankIndex = 0;
    bank_array = [NSArray arrayWithObjects:@"平安银行", @"农业银行", @"中国银行", @"招商银行", nil];
    
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
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关于"style:UIBarButtonItemStyleBordered target:self action:@selector(aboutDlg)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        //加入筛选按钮
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选"style:UIBarButtonItemStyleBordered target:self action:@selector(filterDlg)];
        self.navigationItem.rightBarButtonItem = filterButton;
    }
    
    //加入列表
    mUITableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [mUITableView setDelegate:self];
    [mUITableView setDataSource:self];
    [self.view addSubview:mUITableView];
    
    [self createTableFooter]; //加入footer
         //加入List
    NSMutableArray *MutableArray = [[NSMutableArray alloc] init];
    self.list = MutableArray;
    
    //初始化异步队列线程类
    queue = [[NSOperationQueue alloc] init];
    
   
    [self requestData:[ self getTypeId:0]];//一开始就加入平安银行的数据
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
    CGSize mCGSize = CGSizeMake(CELL_IMAGE_WIDTH, CELL_IMAGE_HEIGHT);
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
    NSString* temp_integral = @"";
    if ([good.cash floatValue] == 0.0f) {
        temp_integral = [NSString stringWithFormat:@"%@",good.integral];
    }else{
        temp_integral = [NSString stringWithFormat:@"%@ ￥%@",good.integral,good.cash];
    }
    [cell setIntegral:temp_integral];
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
   // NSLog(@"didSelectRowAtIndexPath %ld",(long)[indexPath row]);
    Good *good = [self.list objectAtIndex:[indexPath row]];
    selectedIndex = [indexPath row];
    NSString* message = [NSString stringWithFormat:@"复制编号:%@ ?",good.no];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert = nil;

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickedButtonAtIndex %i",buttonIndex);
    switch (buttonIndex) {
        case 0://取消
            break;
        case 1:{//确定
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            Good *good = [self.list objectAtIndex:selectedIndex];
            pboard.string = good.no;
            [SVProgressHUD showSuccessWithStatus:@"已成功复制!"];
        }break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}
-(NSInteger) getTypeId:(NSInteger)bank{
    NSInteger result = 0;
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
        case 3:
            result = 4;
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
    [queue cancelAllOperations];//取消所有操作
    page = 1;
    
    [self requestData:[ self getTypeId:index ]];
}

//请求服务器数据
-(void)requestData:(NSUInteger)index{
    
    if (loadingMore) {
        return;
    }
     ++page;
    loadingMore = YES;
     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear]; //弹出等待提示
    NSString* request_url = [NSString stringWithFormat:@"%@?good_typeid=%i&count=%i&page=1",API_URL,index,count*page];
    mHttpRequestTool.url = request_url;
    
    //NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threafunc) object:nil];
    NSThread* myThread = [[NSThread alloc] initWithTarget:mHttpRequestTool selector:@selector(startRequest) object:nil];
    [myThread start];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    NSLog(@"offset y=%f bounds.height=%f size1.height=%f",offset.y,bounds.size.height,size.height);
    float y1 = offset.y + bounds.size.height;
    float h1 = size.height;
    float offset_pull_up = 100;//上拉的偏移量
    if ((y1 - h1) > offset_pull_up) {
        flagRefresh = YES;
    }
    else {
        flagRefresh = NO;
    }
    if(flagRefresh){
     
    NSLog(@"上拉刷新");
        [self requestData:[self getTypeId:menu.selectedIndex]];
    }else{
        NSLog(@"取消刷新");
       
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// 创建表格底部
- (void) createTableFooter
{
    mUITableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mUITableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];
    
    mUITableView.tableFooterView = tableFooterView;
    [mUITableView.tableFooterView setHidden:YES];
}
//回调方法,接收http返回json数据
-(void)onMsgReceive :(NSData*) msg :(NSError*) error
{
    [SVProgressHUD dismiss];//消除等待提示
    
  [mUITableView.tableFooterView setHidden:NO];//让Footer显示出来 
    
    loadingMore = NO;
    if(selectedBankIndex != menu.selectedIndex){ //切换银行时，回到顶部
        CGPoint point = CGPointMake(0, 0);
        [mUITableView setContentOffset:point]; //回到顶端
        
        selectedBankIndex = menu.selectedIndex;
    }
    if(error != Nil){
        NSInteger code = [error code];
        NSLog(@"%i %@",[error code],error);
        switch (code) {
            case NSURLErrorNotConnectedToInternet://网络断开
                [SVProgressHUD showErrorWithStatus:@"无法连接到网络!"];
                break;
                
            default:
                break;
        }
        return;
    }
    
    NSError *parse_error=Nil;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:msg options:NSJSONReadingMutableLeaves error:&parse_error];
    
    
    if(parse_error != Nil){
        NSLog(@"%i",[parse_error code]);
        return;
    }
    
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
        NSString *good_cash =[each_data objectForKey:@"good_cash"];
        Good *good = [[Good alloc]init];
        good.title = good_name;
        good.integral = good_integral;
        good.no = good_no;
        good.image_url = good_imgurl;
        good.cash =good_cash;
        if(good_name==nil) continue;
        
        [self.list addObject:good];//加入到list
    }
    
    [mUITableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];//主线程更新列表数据
    
    
}
-(void)passValue:(UserEntity *)value{
    NSLog(@"%@ %i %i",value.title,value.minIntegral,value.maxIntegral);
}
@end
