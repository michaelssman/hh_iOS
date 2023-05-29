//
//  HHSingleton.swift
//  HHSwift
//
//  Created by Michael on 2022/4/12.
//

import Foundation

// MARK: 单例
class HHTeacherS{
    static let sharedInstance = HHTeacherS()//使用let这种方式来保证线程安全
    
    private init(){}// 私有化构造方法(如果有需要也可以去掉)
}

func test_Singleton() {
    let s1 = HHTeacherS.sharedInstance
    let s2 = HHTeacherS.sharedInstance
    print(s1)
    print(s2)
}
