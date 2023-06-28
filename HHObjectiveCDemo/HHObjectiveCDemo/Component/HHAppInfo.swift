//
//  HHAppInfo.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/6/28.
//

import UIKit
import Foundation

class HHAppInfo: NSObject {
    @objc static let appInfo = String(format: "\nApp : %@ %@ %@\nDevice : %@\nOS Version : %@\nUDID : %@\nDateime: %@",
                                // 应用名
                                Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "",
                                // 应用版本号
                                Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
                                Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "",
                                UIDevice.current.systemName,
                                UIDevice.current.systemVersion,
                                UIDevice.current.identifierForVendor?.uuidString ?? "",
                                Date() as CVarArg)
}
