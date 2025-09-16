//
//  FirebaseManager.swift
//  TrackReportDemo
//
//  Created by 笔尚文化 on 2025/9/15.
//

import AppTrackingTransparency
import Combine
import FirebaseCore
import FirebaseRemoteConfig
import Foundation

final class FirebaseManager {
    static let shared = FirebaseManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var remoteConfig: RemoteConfig?
    private var isFetching = false
    private var pendingCompletions: [(Bool) -> Void] = []

    private init() {
        if #available(iOS 14, *) {
            NotificationCenter.default.publisher(for: UIScene.didActivateNotification)
                .filter({ _ in
                    ATTrackingManager.trackingAuthorizationStatus == .notDetermined
                })
                .sink(receiveValue: { _ in
                    DispatchQueue.main.async {
                        ATTrackingManager.requestTrackingAuthorization {
                            kLog("请求IDFA的授权，结果：\($0.description)（原始值：\($0.rawValue)）")
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }

    func config() {
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
    }
    
    /// 对外提供的获取RemoteConfig方法（支持多次异步调用）
    /// - Parameters:
    ///   - key: 配置键名
    ///   - complete: 结果回调（返回对应key的字符串值）
    func getRemoteConfig(key: String, complete: ((String?) -> Void)? = nil) {
        // 先检查RemoteConfig是否已初始化
        guard let remoteConfig = remoteConfig else {
            kLog("RemoteConfig 未初始化，请先调用 config()")
            complete?(nil)
            return
        }
        
        // 3. 调用fetchAndActivate，并传入“获取到配置后的回调”
        fetchAndActivate { success in
            if success {
                complete?(remoteConfig.configValue(forKey: key).stringValue)
            } else {
                complete?(nil)
            }
        }
    }
}

private extension FirebaseManager {
    /// 控制串行执行的fetchAndActivate（支持多回调等待）
    /// - Parameter completion: 单个请求的回调
    func fetchAndActivate(completion: @escaping (Bool) -> Void) {
        // 4. 确保在同一队列中操作（避免多线程竞争isFetching和pendingCompletions）
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            // 将当前回调加入等待队列
            self.pendingCompletions.append(completion)
            
            // 如果正在请求中，直接返回（等待已有请求完成）
            guard !self.isFetching else {
                kLog("已有RemoteConfig请求在执行，当前请求加入等待队列（队列长度：\(self.pendingCompletions.count)）")
                return
            }
            
            // 标记为“正在请求中”
            self.isFetching = true
            kLog("发起RemoteConfig请求（等待队列长度：\(self.pendingCompletions.count)）")
            
            // 发起远程请求
            self.remoteConfig?.fetch { [weak self] status, error in
                guard let self = self else { return }
                
                var fetchSuccess = false
                if let error = error {
                    kLog("RemoteConfig fetch失败: \(error.localizedDescription)")
                } else {
                    fetchSuccess = true
                }
                
                // 激活配置（无论fetch是否成功，都尝试激活本地缓存）
                self.remoteConfig?.activate { changed, activateError in
                    let finalSuccess = fetchSuccess && (activateError == nil)
                    if let activateError = activateError {
                        kLog("RemoteConfig activate失败: \(activateError.localizedDescription)")
                    } else if changed {
                        kLog("RemoteConfig 配置已更新（新值已生效）")
                    } else {
                        kLog("RemoteConfig 配置未变更（使用缓存值）")
                    }
                    
                    // 5. 执行所有等待中的回调，并清空队列
                    let pendingCompletions = self.pendingCompletions
                    self.pendingCompletions.removeAll()
                    self.isFetching = false // 重置“请求中”标记
                    
                    // 回调结果（确保在主线程，避免UI线程问题）
                    DispatchQueue.main.async {
                        pendingCompletions.forEach { $0(finalSuccess) }
                    }
                }
            }
        }
    }
}

@available(iOS 14, *)
private extension ATTrackingManager.AuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "notDetermined（未决策：用户尚未做出选择）"
        case .restricted:
            return "restricted（受限制：设备设置限制，无法请求授权）"
        case .denied:
            return "denied（用户拒绝：用户明确不允许跟踪）"
        case .authorized:
            return "authorized（用户允许：用户同意跟踪，可获取IDFA）"
        @unknown default:
            return "unknown（未知状态：可能是未来新增的状态）"
        }
    }
}
