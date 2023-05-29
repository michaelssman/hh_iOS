//
//  HHMemento.swift
//  HHSwift
//
//  Created by Michael on 2022/4/22.
//  备忘录模式

/**
 备忘录模式：把某个对象保存在本地，并在适当的时候恢复出来。
 
 备忘录模式总体来说分为三部分:
 
 发起人(Originator): 负责创建一个备忘录对象，用以保存当前的状态，并可使用备忘录恢复内部状态。
 
 Memento(备忘录): 负责存储Originator对象,在swift中由Codable实现.
 
 Caretaker(管理者): 负责备忘录的保存与恢复工作.
 
 备忘录的最大好处就是可以恢复到特定的状态,但每次的读写操作需要消耗一定的系统资源,所以在某些场景下可以将单例模式和备忘录模式结合来统一管理操作数据.
 */

import Foundation

// MARK: - Originator(发起人)
public class UserInfo: Codable {
    
    static let shared = UserInfo()
    private init() {}
    
    public var isLogin: Bool = false
    public var account: String?
    public var age: Int?
    
    var description: String {
        return "account:\(account ?? "为空"), age:\(age ?? 0)"
    }
}

// MARK: - 备忘录(Memento): 负责存储Originator对象,swift中由Codable实现


// MARK: - 管理者(CareTaker)
public class UserInfoTaker {
    
    public static let UserInforKey = "UserInfoKey"
    
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    private static let userDefaults = UserDefaults.standard
    
    public static func save(_ p: UserInfo) throws {
        let data = try encoder.encode(p)
        userDefaults.set(data, forKey: UserInforKey)
    }
    
    public static func load() throws -> UserInfo {
        guard let data = userDefaults.data(forKey: UserInforKey),
              let userInfo = try? decoder.decode(UserInfo.self, from: data)
        else {
            throw Error.UserInfoNotFound
        }
        
        // decode生成的对象不是单例对象,需要转换成单例对象
        let userInfoS = UserInfo.shared
        userInfoS.account = userInfo.account
        userInfoS.age = userInfo.age
        userInfoS.isLogin = userInfo.isLogin
        
        return userInfoS
    }
    
    public enum Error: String, Swift.Error {
        case UserInfoNotFound
    }
}


func testM() {
    let userInfo = UserInfo.shared
    userInfo.isLogin = true
    userInfo.account = "132154"
    userInfo.age = 16
    
    // 保存
    do {
        try UserInfoTaker.save(userInfo)
    } catch {
        print(error)
    }
    
    // 读取
    do {
        let newUserInfo = try UserInfoTaker.load()
        print(newUserInfo.description)        
    } catch {
        print(error)
    }
}
