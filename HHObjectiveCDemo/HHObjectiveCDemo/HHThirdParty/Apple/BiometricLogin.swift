//
//  BiometricLogin.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/5/11.
//

import Foundation
//Face 指纹 ID
import LocalAuthentication
//钥匙串
import Security

class BiometricManager: NSObject {
    
    /// 检查设备是否支持Face ID功能。
    /// - Returns: 如果支持，则返回 true，否则返回 false。
    static func BiometricSupprot() -> Bool {
        if #available(iOS 11.2, *) {
            return self.biometryType() != .none
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    /// 判断设备支持的身份验证方式
    /// - Returns: 返回一个 LABiometryType 枚举值，可以使用该值来确定应该使用 Face ID 还是 Touch ID
    static func biometryType() -> LABiometryType {
        let context = LAContext()
        var error: NSError?
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return context.biometryType
    }
    
    // MARK: 向用户请求授权
    static func BiometricAuthentication(completionHandler: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var localizedReasonString = "请使用Face ID登录"
        if self.biometryType() == .touchID {
            localizedReasonString = "请使用Touch ID登录"
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonString) { success, error in
            if let error = error as NSError? {
                if error.code == LAError.biometryLockout.rawValue {
                    // Touch ID 或 Face ID 验证超过次数，需要输入设备密码、
                    // 在 iOS 中，Touch ID 或 Face ID 验证失败的次数和时间限制都由系统控制，并且无法通过代码来修改。
                    authenticateWithPassword(completionHandler: completionHandler)
                } else if error.code == LAError.userFallback.rawValue {
                    // 用户选择了密码输入选项
                    authenticateWithPassword(completionHandler: completionHandler)
                } else {
                    // 其他错误
                    DispatchQueue.main.async {
                        completionHandler(false, error)
                    }
                }
            } else {
                // 验证成功
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }
        }
    }
    
    // 进行设备密码验证
    static func authenticateWithPassword(completionHandler: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "进行设备密码验证") { success, error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            } else {
                // 验证成功
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            }
        }
    }
}

class KeychainManager {
    static let secAttrAccount = "myToken"
    // 将 dictionary 保存到 Keychain 中
    static func saveToken(_ dictionary: [String: Any]) -> Bool {
        //序列化
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false) else { return false }
        //        let data = token.data(using: .utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: secAttrAccount,
                                    kSecValueData as String: data]
        SecItemDelete(query as CFDictionary) // 先删除旧的
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // 从 Keychain 中读取 token
    static func loadToken() -> [String: Any]? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: secAttrAccount,
                                    kSecReturnData as String: kCFBooleanTrue!,
                                    kSecMatchLimit as String: kSecMatchLimitOne]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data, let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] else {
            return nil
        }
        //        return String(data: data, encoding: .utf8)
        return dictionary
    }
    
    // 从 Keychain 中删除 token
    static func deleteToken() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: secAttrAccount]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
