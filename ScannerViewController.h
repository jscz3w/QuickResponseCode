//
//  ScannerViewController.h
//  WorkApproval
//
//  Created by WangZhengHong on 15/7/24.
//  Copyright (c) 2015年 WangZhengHong. All rights reserved.
//

#import <ZXingObjC.h>
#import <UIKit/UIKit.h>

@protocol ScannerViewControllerDelegate <NSObject>
-(void)scanResult:(NSString *)result;
@end

@interface ScannerViewController : UIViewController<ZXCaptureDelegate>
@property (nonatomic,assign) id<ScannerViewControllerDelegate> delegate;

@end

