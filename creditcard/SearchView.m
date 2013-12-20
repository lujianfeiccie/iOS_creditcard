//
//  SearchView.m
//  creditcard
//
//  Created by Apple on 13-10-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "SearchView.h"
#import "SVProgressHUD.h"
#define NUMBERS @"0123456789\n" //只能输入数字的实现方法

@interface SearchView ()

@end

@implementation UserEntity
@synthesize title;
@synthesize maxIntegral;
@synthesize minIntegral;
@synthesize selectedIndex;
-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init])
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.maxIntegral = [aDecoder decodeIntegerForKey:@"maxIntegral"];
        self.minIntegral = [aDecoder decodeIntegerForKey:@"minIntegral"];
        self.selectedIndex = [aDecoder decodeIntegerForKey:@"selectedIndex"];
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeInteger:maxIntegral forKey:@"maxIntegral"];
    [aCoder encodeInteger:minIntegral forKey:@"minIntegral"];
    [aCoder encodeInteger:selectedIndex forKey:@"selectedIndex"];
}
@end
typedef NS_ENUM(NSInteger, Test1) {
    //以下是枚举成员
    VALUE1_999 = 0,
    VALUE1000_1999 = 1,
    VALUE2000_2999 = 2,
    VALUE3000_3999 = 3,
    VALUE4000_4999 = 4,
    VALUE5000_10000 = 5,
    VALUE10000MORE = 6,
    VALUE_OTHER = 7,
    VALUE_NONE = 8
};
@implementation SearchView
@synthesize txtTitle;
@synthesize txtIntegral;
@synthesize txtMaxIntegral;
@synthesize txtMinIntegral;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    for (id obj in self.view.subviews)  {
        [ImageHelper setRect:obj];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    txtTitle.text =  @"";
    
    
    _otherIntegralView.hidden = YES;
	// Do any additional setup after loading the view.
    NSArray *array = [[NSArray alloc] initWithObjects:@"1-999",
                                                      @"1000-1999",
                                                      @"2000-2999",
                                                      @"3000-3999",
                                                      @"4000-4999",
                                                      @"5000-10000",
                                                      @">10000",
                                                      @"其它",
                                                      @"无",nil];
    _pickerData = array;
    txtIntegral.items = _pickerData;
    txtIntegral.delegateForItemSelected = self;
    txtIntegral.selectedIndex = array.count-1;
    
    //读取用户信息
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData* udObject = [ud objectForKey:@"UserEntity"];
    UserEntity* mUserEntity = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    if(mUserEntity!=nil){
        txtTitle.text = mUserEntity.title;
        txtIntegral.selectedIndex = mUserEntity.selectedIndex;//setter getter
        [self MyLog:[NSString stringWithFormat:@"NSUserDefaults %i",mUserEntity.selectedIndex]];
    }
    
    
    //加入返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backbtnClick)];
    
    [ImageHelper setToolBarBtn:backButton];    //加入返回按钮
    self.navigationItem.leftBarButtonItem = backButton;
    
    //加入筛选按钮
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"查询"style:UIBarButtonItemStyleBordered target:self action:@selector(searchbtnClick)];
   [ImageHelper setToolBarBtn:searchButton];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    
    
    //触摸其它地方让键盘隐藏
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textfieldTouchUpOutside:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    //最大积分和最小积分使用数字键盘
    txtMaxIntegral.keyboardType= UIKeyboardTypeNumberPad;
    txtMinIntegral.keyboardType= UIKeyboardTypeNumberPad;

    txtTitle.clearButtonMode = UITextFieldViewModeAlways; //清空内容
    txtMinIntegral.clearButtonMode = UITextFieldViewModeAlways;
    txtMaxIntegral.clearButtonMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backbtnClick {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)searchbtnClick {
   if(!_otherIntegralView.hidden){
        if ([txtMaxIntegral.text isEqual:@""] ||
            [txtMinIntegral.text isEqual:@""]) {
           [SVProgressHUD showErrorWithStatus:@"输入不能为空"];
            return;
        }
        maxIntegral = txtMaxIntegral.text.integerValue;
        minIntegral = txtMinIntegral.text.integerValue;
    }
    if( _delegate !=nil){
        UserEntity* value = [[UserEntity alloc] init];
        
        value.title = txtTitle.text;
        value.maxIntegral = maxIntegral;
        value.minIntegral = minIntegral;
        value.selectedIndex = txtIntegral.selectedIndex;
        //保存配置信息
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:value];
        [ud setObject:udObject forKey:@"UserEntity"];
        
      
        [[self navigationController] popViewControllerAnimated:YES];
        [_delegate passValue:value];
        _delegate = nil;
    }
}
-(void) viewDidDisappear:(BOOL)animated{
   [self MyLog:@"SearchView======viewDidDisappear"];
    txtTitle = nil;
    _delegate = nil;
}
-(IBAction)IntegralSelect:(id)sender{
   // pickview_integral set
   [self MyLog:@"textfieldTouchUpInside"];
}
 


 -(IBAction)textfieldTouchUpOutside:(id)sender{
    NSLog(@"textfieldTouchUpOutside");
     [txtTitle resignFirstResponder];
     [txtMaxIntegral resignFirstResponder];
     [txtMinIntegral resignFirstResponder];
}

-(void)onItemSelected:(UICombox*) uiCombox Index:(NSInteger) index;{
    NSLog(@"onItemSelected %i",index);
    
    switch (index) {
        case VALUE1_999:
            maxIntegral = 999;
            minIntegral = 1;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE1000_1999:
            maxIntegral = 1999;
            minIntegral = 1000;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE2000_2999:
            maxIntegral = 2999;
            minIntegral = 2000;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE3000_3999:
            maxIntegral = 3999;
            minIntegral = 3000;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE4000_4999:
            maxIntegral = 4999;
            minIntegral = 4000;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE5000_10000:
            maxIntegral = 10000;
            minIntegral = 5000;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE10000MORE:
            minIntegral = 10000;
            maxIntegral = 1000000;
            _otherIntegralView.hidden = YES;
            break;
        case VALUE_OTHER:
            _otherIntegralView.hidden = NO;
            break;
        case VALUE_NONE:
            minIntegral = 0;
            maxIntegral = 0;
            _otherIntegralView.hidden = YES;
            break;
        default:
            break;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest)
    {
      return NO;
    }
    //其他的类型不需要检测，直接写入
    return YES;
}

-(void) MyLog: (NSString*) msg{
#if defined(LOG_DEBUG)
    NSLog(@"%@ %@",NSStringFromClass([self class]),msg);
#endif
}
@end
