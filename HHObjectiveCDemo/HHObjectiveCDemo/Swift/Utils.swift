//
//  Utils.swift
//  HHSwift
//
//  Created by Michael on 2022/4/10.
//

import Foundation

protocol BrigeProtocol {}

//协议添加默认方法
extension BrigeProtocol {
    static func get(from pointer: UnsafeRawPointer) -> Any {
        pointer.assumingMemoryBound(to: Self.self).pointee
    }
}

//协议的Metadata:
//1. type的元类，真实类的信息
//2. 协议见证表：谁遵循了协议，实现了什么方法
struct BrigeProtocolMetadata {
    let type: Any.Type
    let witness: Int
}

func customCast(type: Any.Type) -> BrigeProtocol.Type {
    let container = BrigeProtocolMetadata(type: type, witness: 0)
    var protocolType = BrigeProtocol.Type.self
    let cast = unsafeBitCast(container, to: BrigeProtocol.Type.self/*协议的metadata*/)
    return cast
}
