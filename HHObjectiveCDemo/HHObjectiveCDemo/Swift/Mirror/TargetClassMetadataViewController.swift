//
//  TargetClassMetadataViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/4/10.
//  获取类中的属性类型和值

import UIKit


struct TargetClassDescriptor{//描述信息
    var flags: Int32
    var parent: Int32
    var name: TargetRelativeDirectPointer<CChar>
    var accessFunctionPointer: TargetRelativeDirectPointer<UnsafeRawPointer>
    var fieldDescriptor: TargetRelativeDirectPointer<FieldDescriptor>//属性信息
    var superClassType: TargetRelativeDirectPointer<CChar>
    var metadataNegativeSizeInWords: Int32
    var metadataPositiveSizeInWords: Int32
    var numImmediateMembers: Int32
    var numFields: Int32
    var fieldOffsetVectorOffset: Int32//存的每一个属性距离当前实例对象地址的偏移量
    
    func getFieldOffsets(_ metadata: UnsafeRawPointer) -> UnsafePointer<Int>{
      return metadata.assumingMemoryBound(to: Int.self).advanced(by: numericCast(self.fieldOffsetVectorOffset))
    }
    
    var genericArgumentOffset: Int {
        return 2
    }
}

struct TargetClassMetadata{
    var kind: Int
    var superClass: Any.Type
    var cacheData: (Int, Int)
    var data: Int
    var classFlags: Int32
    var instanceAddressPoint: UInt32
    var instanceSize: UInt32
    var instanceAlignmentMask: UInt16
    var reserved: UInt16
    var classSize: UInt32
    var classAddressPoint: UInt32
    var typeDescriptor: UnsafeMutablePointer<TargetClassDescriptor>
    var iVarDestroyer: UnsafeRawPointer
}

// MARK: 测试
func testClassMetadata() {
    /*
     这里我们测试一下 ClassMetadata
     */
    class LGTeacher{
        var age: Int = 18
        var name: String = "Kody"
    }

    let t = LGTeacher()
    
    let ptr = unsafeBitCast(LGTeacher.self as Any.Type, to: UnsafeMutablePointer<TargetClassMetadata>.self)
    
    let namePtr = ptr.pointee.typeDescriptor.pointee.name.getmeasureRelativeOffset()
    print("current class name: \(String(cString: namePtr))")
    
    let numFileds = ptr.pointee.typeDescriptor.pointee.numFields
    print("当前类属性的个数: \(numFileds)")
    //
    let superClassType = ptr.pointee.typeDescriptor.pointee.superClassType.getmeasureRelativeOffset()
    print("current superClassType: \(String(cString: superClassType))")
    //
    
    let offsets = ptr.pointee.typeDescriptor.pointee.getFieldOffsets(UnsafeRawPointer(ptr).assumingMemoryBound(to: Int.self))
    
    print("======= start fetch filed ======")
    
    for i in 0..<numFileds{
        
        //类型的描述信息
        let fieldDespritor = ptr.pointee.typeDescriptor.pointee.fieldDescriptor.getmeasureRelativeOffset().pointee.fields.index(of: Int(i)).pointee.fieldName.getmeasureRelativeOffset()
        print("--- filed: \(String(cString: fieldDespritor)) info begin ----")
        
        let fieldOffset = offsets[Int(i)]//下一个属性值的偏移量
        //Int ，String 属性的类型（swift混写过后的）
        let typeMangleName = ptr.pointee.typeDescriptor.pointee.fieldDescriptor.getmeasureRelativeOffset().pointee.fields.index(of: Int(i)).pointee.mangledTypeName.getmeasureRelativeOffset()
        print("typeManglename:\(typeMangleName)")
        
        
        let genericVector = UnsafeRawPointer(ptr).advanced(by: ptr.pointee.typeDescriptor.pointee.genericArgumentOffset * MemoryLayout<UnsafeRawPointer>.size).assumingMemoryBound(to: Any.Type.self)
        
        // Int ，String 属性的类型（swift混写过的需要还原）。
        let fieldType = swift_getTypeByMangledNameInContext(//调用C
            typeMangleName,
            256,
            UnsafeRawPointer(ptr.pointee.typeDescriptor),
            UnsafeRawPointer(genericVector)?.assumingMemoryBound(to: Optional<UnsafeRawPointer>.self))
        //
        //    print(fieldType as Any)
        
        //比较难理解，HandJSON
        let type = unsafeBitCast(fieldType, to: Any.Type.self)
        
        print(type)
        
        let instanceAddress = Unmanaged.passUnretained(t as AnyObject).toOpaque()
        
        //属性值的地址信息
        let FiledAddress = instanceAddress.advanced(by: fieldOffset)
        
        let value = customCast(type: type)
        //
        print("fieldType:\(type) \nfieldValue: \(value.get(from: instanceAddress.advanced(by: fieldOffset))) ")
        //
        //    print("--- filed: \(String(cString: fieldDespritor)) info end ---- \n")

    }
}

class TargetClassMetadataViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
