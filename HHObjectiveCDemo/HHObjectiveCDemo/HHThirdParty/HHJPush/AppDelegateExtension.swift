//
//  AppDelegateExtension.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/3/16.
//

import Foundation
import UIKit
import AdSupport    //广告
import AppTrackingTransparency

extension AppDelegate: JPUSHRegisterDelegate {
    
    //常量
    static let appKey: String = "JPUSHAPPKEY"
    static let channel: String = "app store"
    
    // MARK: 初始化APNs
    @objc func setUpJPush(launchOptions: [AnyHashable : Any]!) {
        let entity: JPUSHRegisterEntity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions([.alert, .sound, .badge, .providesAppNotificationSettings]).rawValue)
        } else {
            // Fallback on earlier versions
            entity.types = Int(JPAuthorizationOptions([.alert, .sound, .badge]).rawValue)
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
        /**
         说明：直译就是广告id， 在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪 里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了。
         注意：由于idfa会出现取不到的情况，故绝不可以作为业务分析的主id，来识别用户。
         */
        var advertisingId: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if status == .authorized {
                    advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                }
            }
        } else {
            // Fallback on earlier versions
        }
        /**
         部分参数说明：
         appKey
         选择极光控制台的应用 ，点击“设置”获取其 appkey 值。请确保应用内配置的 appkey 与极光控制台上创建应用后生成的 appkey 一致。
         channel
         指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
         apsForProduction
         1.3.1 版本新增，用于标识当前应用所使用的 APNs 证书环境。
         0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
         注：此字段的值要与 Build Settings 的 Code Signing 配置的证书环境一致。
         advertisingIdentifier
         详见 关于 IDFA。
         */
        JPUSHService.setup(withOption: launchOptions, appKey: Self.appKey, channel: Self.channel, apsForProduction: true, advertisingIdentifier: advertisingId)
        
        // 收到消息(非APNS)
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
    }
    
    // 收到消息(非APNS)
    @objc func networkDidReceiveMessage(notification: Notification) {
        guard let userInfo: [AnyHashable : Any] = notification.userInfo else { return }
        print(userInfo)
    }
    
    
    /*
     * @param notification 前台得到的的通知对象
     * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
     */
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo: [AnyHashable : Any] = notification.request.content.userInfo
        if ((notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self)) != nil) {
            /// iOS10处理远程推送
            JPUSHService.handleRemoteNotification(userInfo)
        }
        /// 应用处于前台收到本地通知不会出现在通知中心 借用极光推送的方法将本地通知添加到通知栏。不写就不会显示通知栏弹窗。
        completionHandler(Int(UNNotificationPresentationOptions([.badge, .sound, .alert]).rawValue))
    }
    /*
     点击通知栏消息
     程序运行于前台，后台 或杀死，只要是点击推送通知 都会走这个方法
     * @param response 通知响应对象
     * @param completionHandler
     */
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo: [AnyHashable : Any] = response.notification.request.content.userInfo
        // TODO: 这里是根据收到的消息的消息体去做不同的处理。例如跳转app内的页面。
        if ((response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self)) != nil) {
            /// 处理收到的 APNs 消息
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler();
    }
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        if ((notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self)) != nil) {
            //从通知界面直接进入应用
        } else {
            //从通知设置界面进入应用
        }
    }
    public func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        //
    }
    
    
    // MARK: 设置别名
    // 设置别名，新设置的别名会覆盖之前设置的别名，别名只有一个
    func setUpAlias() {
        let aliasKey: String = "aliasKey"
        var uuidString: String? = UserDefaults.standard.value(forKey: aliasKey) as? String
        if (uuidString == nil) {
            uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            UserDefaults.standard.set(uuidString, forKey: aliasKey)
        }
        JPUSHService.setAlias(uuidString, completion: { iResCode, iAlias, seq in
            if iResCode == 0 {
                print("别名设置成功！")
            }
        }, seq: 110)
    }
    // 删除别名，别名只有一个
    func deleteAlias() {
        JPUSHService.deleteAlias({ iResCode, iAlias, seq in
            //
        }, seq: 110)
    }
}

extension AppDelegate {
    func addLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "提醒标题"
        content.body = "提醒内容"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 2 // 每周二
        dateComponents.hour = 8
        dateComponents.minute = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "com.example.notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func deleteLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["com.example.notification"])
    }
}
