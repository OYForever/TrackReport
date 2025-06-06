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
    
//    [TrackReportKit registerUser];
    
//    [TrackReportKit tr_subscriptionWithTransactionId:@"12123" page:TrackReportSubscriptionTypeNewSubscription];
    
//    [TrackReportKit tr_customEventWithEventId:@"123123" behaviorContent:@"哈哈哈"];
    [TrackReportKit tr_checkAppVersionWithAutoPopAlterWithComplete:^(NSString * _Nullable version) {
        NSLog(@"版本号：%@", version);
    }];
    [TrackReportKit tr_getAppConfigWithId:@"19" complete:^(NSString * _Nullable value) {
        NSLog(@"APP配置值：%@", value);
    }];
}


@end
