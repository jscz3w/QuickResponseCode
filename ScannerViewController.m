//
//  ScannerViewController.m
//  WorkApproval
//
//  Created by WangZhengHong on 15/7/24.
//  Copyright (c) 2015年 WangZhengHong. All rights reserved.
//

#import "ScannerViewController.h"


#import <AudioToolbox/AudioToolbox.h>
#define SCANNER_WIDTH 200.0f

@interface ScannerViewController () <ZXCaptureDelegate>

@property (nonatomic,strong) UIImageView *centerView;
@property (nonatomic,strong) ZXCapture *capture;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic,strong) UIImageView *lineView;//扫描线
@property (nonatomic,assign) BOOL willUp;//扫描移动方向
@property (nonatomic,strong) NSTimer *timer;//扫描线定时器

@end

@implementation ScannerViewController
{

        CGFloat scanner_X;
        CGFloat scanner_Y;
        CGRect viewFrame;
    
}

//扫描线动画
-(void)lineAnimation{
    float y=self.lineView.frame.origin.y;
    if (y<=scanner_Y) {
        self.willUp=NO;
    }else if(y>=scanner_Y+SCANNER_WIDTH){
        self.willUp=YES;
    }
    if(self.willUp){
        y-=2;
        self.lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
    }else{
        y+=2;
        self.lineView.frame=CGRectMake(scanner_X, y, SCANNER_WIDTH, 2);
    }
}
-(void)initBackgroundView{
    CGRect scannerFrame=CGRectMake(scanner_X, scanner_Y,SCANNER_WIDTH, SCANNER_WIDTH);
    float x=scannerFrame.origin.x;
    float y=scannerFrame.origin.y;
    float width=scannerFrame.size.width;
    float height=scannerFrame.size.height;
    float mainWidth=viewFrame.size.width;
    float mainHeight=viewFrame.size.height;
    
    UIView *upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, y)];
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, y, x, height)];
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(x+width, y, mainWidth-x-width, height)];
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0, y+height, mainWidth, mainHeight-y-height)];
    
    NSArray *viewArray=[NSArray arrayWithObjects:upView,downView,leftView,rightView, nil];
    for (UIView *view in viewArray) {
        view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        [self.view addSubview:view];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.centerView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.centerView setImage:[UIImage imageNamed:@"border"]];
    self.centerView.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
    self.centerView.center=self.view.center;
    [self.view addSubview:self.centerView];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.centerView];
    
    
    viewFrame=self.view.frame;
    
    CGPoint centerPoint=CGPointMake(viewFrame.size.width/2, viewFrame.size.height/2);
    //扫描框的x、y坐标
    scanner_X=centerPoint.x-(SCANNER_WIDTH/2);
    scanner_Y=centerPoint.y-(SCANNER_WIDTH/2);
    //半透明背景初始化
    [self initBackgroundView];
    
    //扫描线
    self.lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    self.lineView.frame=CGRectMake(scanner_X, scanner_Y, SCANNER_WIDTH, 2);
    [self.view addSubview:self.lineView];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];

    
    //菜单
    float viewHeight=viewFrame.size.height;
    float viewWidth=viewFrame.size.width;
    UIView *menuView=[[UIView alloc]initWithFrame:CGRectMake(0, viewHeight-100, viewWidth, 100)];
    menuView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self.view addSubview:menuView];
    
    self.resultLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, viewWidth-20, 40)];
    self.resultLabel.backgroundColor=[UIColor grayColor];
    [menuView addSubview:self.resultLabel];
    
    UIButton *clearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame=CGRectMake(10, 50, 100, 40);
    [clearBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:clearBtn];
    
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake(viewWidth-110, 50, 100, 40);
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:submitBtn];

    
}

-(void)clear{
    self.resultLabel.text=@"";
}

-(void)submit{
    NSString *codeStr=self.resultLabel.text;
    if (codeStr.length==0) {
        codeStr=@"没有内容";
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate scanResult:codeStr];
   }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.centerView.frame, captureSizeTransform);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
        case kBarcodeFormatCodabar:
            return @"CODABAR";
        case kBarcodeFormatCode39:
            return @"Code 39";
        case kBarcodeFormatCode93:
            return @"Code 93";
        case kBarcodeFormatCode128:
            return @"Code 128";
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
        case kBarcodeFormatEan8:
            return @"EAN-8";
        case kBarcodeFormatEan13:
            return @"EAN-13";
        case kBarcodeFormatITF:
            return @"ITF";
        case kBarcodeFormatPDF417:
            return @"PDF417";
        case kBarcodeFormatQRCode:
            return @"QR Code";
        case kBarcodeFormatRSS14:
            return @"RSS 14";
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
        case kBarcodeFormatUPCA:
            return @"UPCA";
        case kBarcodeFormatUPCE:
            return @"UPCE";
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
        default:
            return @"Unknown";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result){
        return;
    }
    
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSLog(@"%@",[NSString stringWithFormat:@"条码格式:%@ \n内容:%@", formatString, result.text]);
    self.resultLabel.text=result.text;
    [self.capture stop];
    //震动提示
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSString *codeStr=self.resultLabel.text;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate scanResult:codeStr];
    }];

}

@end
