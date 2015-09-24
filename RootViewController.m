//
//  RootViewController.m
//  QuickResponseCode
//
//  Created by WangZhengHong on 15/9/23.
//  Copyright © 2015年 WangZhengHong. All rights reserved.
//

#import "RootViewController.h"
#import "ScannerViewController.h"

@interface RootViewController ()
@property (nonatomic,strong)UITextView * txtView ;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *bkTopImg =[UIImage imageNamed:@"top@2x"];
    NSLog(@"bkImg size= %d",(int)bkTopImg.size.width);
    UIImageView *bkTopView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 135)];
    [bkTopView setImage:bkTopImg];
    [self.view addSubview:bkTopView];
    
    UIImage *aBackGround=[UIImage imageNamed:@"background@2x"];
    
    UIColor *aColor =[UIColor colorWithPatternImage:aBackGround];
    
    self.view.backgroundColor=aColor;
    
    
    
    UIImage *bkDownImg =[UIImage imageNamed:@"down@2x"];
    
    UIImageView *bkDownView = [[UIImageView alloc]initWithFrame:CGRectMake(0, bkTopView.bounds.size.height+bkTopView.bounds.origin.y, self.view.bounds.size.width, 431)];
    [bkDownView setImage:bkDownImg];
    [self.view addSubview:bkDownView];
    
    
    UIImage *imgScanBtn =  [UIImage imageNamed:@"scanBtn@2x"];
    UIImage *imgAceessBtn =  [UIImage imageNamed:@"aceessBtn@2x"];
    
    UIButton * scanBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, self.view.bounds.size.height-90, 95, 36)];
    [scanBtn setBackgroundImage:imgScanBtn forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    
    
    UIButton * aceessBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-50-95, self.view.bounds.size.height-90, 95, 36)];
    [aceessBtn setBackgroundImage:imgAceessBtn forState:UIControlStateNormal];
    [self.view addSubview:aceessBtn];
    [aceessBtn addTarget:self
                  action:@selector(accessBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
     _txtView = [[UITextView alloc]initWithFrame:CGRectMake(16, bkDownView.frame.origin.y+2, self.view.bounds.size.width-32, 310)];
    
    
     _txtView.backgroundColor =[UIColor clearColor];
    
     _txtView.font=[UIFont boldSystemFontOfSize:22];
    
    _txtView.editable=NO;
    
   [self.view addSubview:_txtView];

    
}

-(void)accessBtnClick{
    
    NSURL* MISurl = [[ NSURL alloc ] initWithString :_txtView.text];
    [[UIApplication sharedApplication ] openURL:MISurl];
}

-(void)scanBtnClick{

        ScannerViewController *svc=[[ScannerViewController alloc]init];
        svc.delegate=self;
        [self presentViewController:svc animated:YES completion:nil];
    
    
}

-(void)scanResult:(NSString *)result{
    self.txtView.text=result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
