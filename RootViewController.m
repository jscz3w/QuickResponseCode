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
@property (nonatomic,strong)UILabel * txtLabel;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *bkImg =[UIImage imageNamed:@"background@2x"];
    NSLog(@"bkImg size= %d",(int)bkImg.size.width);
    UIImageView *bkView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [bkView setImage:bkImg];
    [self.view addSubview:bkView];
    
    
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
    
    
    //UIImage *txtImg = [UIImage imageNamed:@"txtImg@2x"];
    //NSLog(@"txtImg size= %d",(int)txtImg.size.width);
    
   
    //[self.view addSubview:bktxtView];
    
    
    // _txtView = [[UITextView alloc]initWithFrame:CGRectMake(16, self.view.bounds.size.height-310-108, self.view.bounds.size.width-32, 310)];
    
    //[txtView setBackgroundColor:[UIColor colorWithPatternImage:txtImg]];
    
    //UIImageView *bktxtView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2, txtView.bounds.size.width, txtView.bounds.size.height)];
    //[bktxtView setImage:txtImg];
    
    //[txtView addSubview:bktxtView];
    
   // _txtView.backgroundColor =[UIColor clearColor];
    
    //[self.view addSubview:_txtView];
    _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, self.view.bounds.size.height-310-108, self.view.bounds.size.width-32, 310)];
    _txtLabel.numberOfLines=0;
    [self.view addSubview:_txtLabel];
    
   // UIColor *aColor = [UIColor colorWithPatternImage:bkImg];
   // self.view.backgroundColor=aColor;
    
}

-(void)accessBtnClick{
    
    NSURL* MISurl = [[ NSURL alloc ] initWithString :_txtLabel.text];
    [[UIApplication sharedApplication ] openURL:MISurl];
}

-(void)scanBtnClick{

        ScannerViewController *svc=[[ScannerViewController alloc]init];
        svc.delegate=self;
        [self presentViewController:svc animated:YES completion:nil];
    
    
}

-(void)scanResult:(NSString *)result{
    self.txtLabel.text=result;
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
