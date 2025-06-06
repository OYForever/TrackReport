//
//  TrackReportKit.swift
//  TrackReportKit
//
//  Created by 笔尚文化 on 2025/4/25.
//

import Foundation

/// 订阅所在页面
@objc
public enum TrackReportSubscriptionPage: Int {
    /// 订阅页
    case subscriptionPage
    /// 引导订阅页
    case guideSubscriptionPage
    /// 引导订阅挽回页
    case guideSubscriptionRecoveryPage
    /// 首页弹窗
    case homePopPage
    /// 新增订阅
    case newSubscription
    /// 自动续费
    case automaticRenewal
}

@objc
public class TrackReportKit: NSObject {
    @objc private override init() {}
    
    /// 初始化配置
    /// - Parameters:
    ///   - host: 上报域名
    ///   - appId: 上报平台的appid
    @objc(tr_configWithHost:appId:)
    public class func config(host: String = "https://mac.bsfss.com", appId: String) {
        ReportManager.shared.config(host: host, appId: appId)
    }
    
    /// 获取APP配置
    /// - Parameters:
    ///   - id: 配置项的ID
    ///   - complete: 值的回调
    @objc(tr_getAppConfigWithId:complete:)
    public class func getAppConfig(with id: String, complete: ((String?) -> Void)? = nil) {
        ReportManager.shared.getAppConfig(with: id, complete: complete)
    }
    
    /// 新增用户，只需调用一次
    @objc
    public class func registerUser() {
        ReportManager.shared.registerUser()
    }
    
    /// 用户订阅成功
    /// - Parameters:
    ///   - transactionId: 交易id
    ///   - page: 订阅所在页面
    @objc(tr_subscriptionWithTransactionId:page:)
    public class func subscription(with transactionId: String, page: TrackReportSubscriptionPage) {
        ReportManager.shared.subscription(with: transactionId, page: page)
    }
    
    /// 自定义事件
    /// - Parameters:
    ///   - eventId: 事件id
    ///   - behaviorContent: 额外信息，可为空
    @objc(tr_customEventWithEventId:behaviorContent:)
    public class func customEvent(with eventId: String, behaviorContent: String? = nil) {
        ReportManager.shared.customEvent(with: eventId, behaviorContent: behaviorContent)
    }
}

// MARK: - App Store
public
extension TrackReportKit {
    /// 检查APP版本更新
    /// - Parameter complete: 线上版本号回调
    @objc(tr_checkAppVersionWithAutoPopAlterWithComplete:)
    class func checkAppVersionWithAutoPopAlter(complete: ((String?) -> Void)? = nil) {
        AppVersionCheckTool.checkAppVersionWithAutoPopAlter(complete: complete)
    }
}
