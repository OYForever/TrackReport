//
//  ViewController.m
//  TrackReportDemo
//
//  Created by 笔尚文化 on 2025/4/27.
//

#import "ViewController.h"
@import TrackReport;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TrackReportKit tr_configWithHost:@"https://mac.bsfss.com" appId:@"50"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [TrackReportKit registerUser];
//    });
    [TrackReportKit tr_subscriptionWithTransactionId:@"12123" page:TrackReportSubscriptionPageSubscriptionPage];
}


@end
