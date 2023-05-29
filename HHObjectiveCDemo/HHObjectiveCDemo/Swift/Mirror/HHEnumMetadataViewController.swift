//
//  HHEnumMetadataViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/4/10.
//

import UIKit

// MARK: EnumMetadata
// 还原TargetRelativeDirectPointer
// 相对地址信息
struct TargetRelativeDirectPointer<Pointee>{
    var offset: Int32
    
    mutating func getmeasureRelativeOffset() -> UnsafeMutablePointer<Pointee> {
        let offset = self.offset
        
        return withUnsafePointer(to: &self) { p in
           return UnsafeMutablePointer(mutating: UnsafeRawPointer(p).advanced(by: numericCast(offset)).assumingMemoryBound(to: Pointee.self))
        }
    }
}

struct FieldDescriptor {
    var MangledTypeName: TargetRelativeDirectPointer<CChar>
    var Superclass: TargetRelativeDirectPointer<CChar>
    var kind: UInt16
    var fieldRecordSize: Int16
    var numFields: Int32
    var fields: FiledRecordBuffer<FieldRecord>
}

struct FieldRecord {
    var fieldRecordFlags: Int32
    var mangledTypeName: TargetRelativeDirectPointer<CChar>
    var fieldName: TargetRelativeDirectPointer<UInt8>
}

struct FiledRecordBuffer<Element>{
    var element: Element
    
    mutating func buffer(n: Int) -> UnsafeBufferPointer<Element> {
        return withUnsafePointer(to: &self) {
            let ptr = $0.withMemoryRebound(to: Element.self, capacity: 1) { start in
                return start
            }
            return UnsafeBufferPointer(start: ptr, count: n)
        }
    }
    
    mutating func index(of i: Int) -> UnsafeMutablePointer<Element> {
        return withUnsafePointer(to: &self) {
            return UnsafeMutablePointer(mutating: UnsafeRawPointer($0).assumingMemoryBound(to: Element.self).advanced(by: i))
        }
    }
}


struct ValueWitnessFlags {
    static let alignmentMask: UInt32 = 0x0000FFFF
    static let isNonPOD: UInt32 = 0x00010000
    static let isNonInline: UInt32 = 0x00020000
    static let hasExtraInhabitants: UInt32 = 0x00040000
    static let hasSpareBits: UInt32 = 0x00080000
    static let isNonBitwiseTakable: UInt32 = 0x00100000
    static let hasEnumWitnesses: UInt32 = 0x00200000
}

//描述信息
struct TargetEnumDescriptor{
    var flags: Int32
    var parent: TargetRelativeDirectPointer<UnsafeRawPointer>
    var name: TargetRelativeDirectPointer<CChar>
    var accessFunctionPointer: TargetRelativeDirectPointer<UnsafeRawPointer>
    var fieldDescriptor: TargetRelativeDirectPointer<UnsafeRawPointer>
    var NumPayloadCasesAndPayloadSizeOffset: UInt32
    var NumEmptyCases: UInt32
}

struct TargetEnumMetadata{
    var kind: Int
    var typeDescriptor: UnsafeMutablePointer<TargetEnumDescriptor>
}

// MARK: 测试
func test_mirror() {
    enum TerminalChar{
        case Plain(Bool)
        case Bold
        case Empty
        case Cursor
    }
    let e = TerminalChar.self//e存储元类
    //按位转换，返回首地址
    let ptr = unsafeBitCast(TerminalChar.self as Any.Type, to: UnsafeMutablePointer<TargetEnumMetadata>.self)
    let namePtr = ptr.pointee.typeDescriptor.pointee.name.getmeasureRelativeOffset()
    print(String(cString: namePtr))
    print(ptr.pointee.typeDescriptor.pointee.NumPayloadCasesAndPayloadSizeOffset)
    print(ptr.pointee.typeDescriptor.pointee.NumEmptyCases)

    let age = 10
    let age1 = unsafeBitCast(age, to: Double.self)//按位转换。age二进制数据按位放在Double类型里面
    print(age1)//age1打印浮点类型
}

class HHEnumMetadataViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
