//
//  HHPointerMemoryVC.swift
//  HHSwift
//
//  Created by Michael on 2022/4/6.
//  指针&内存管理

/// 内存对齐，为了寻址高效。

import UIKit
import MachO

// MARK: 测量大小
func memSizeDemo() {
    struct HHTeacherST {
        var age: Int = 18
        var sex: Bool = true
    }
    print(MemoryLayout<HHTeacherST>.size)//9 实际大小
    print(MemoryLayout<HHTeacherST>.stride)//16 步长信息
    print(MemoryLayout<HHTeacherST>.alignment)//8 对齐
}

// MARK: 原生指针
/**
 如何使⽤ Raw Pointer 来存储 4 个整型的数据，这⾥我们需要选取的是UnsafeMutableRawPointer
 1、首先开辟一块内存空间
 byteCount：当前总的字节大小。int是4字节 占32。
 alignment：对齐的大小。8字节对齐。
 2、调用store方法存储当前的整型数值
 3、调用load方法加载当前内存当中，这里的fromByteOffset就是距离首地址的字节大小，每次移动i*8的字节
 */
func createMem(){
    let p = UnsafeMutableRawPointer.allocate(byteCount: 32, alignment: 8)
    //存 storeBytes as：存的类型
    for i in 0..<4{
        //p是起始地址，基地址
        //移动p：advanced，存的时候需要移动指针（移动步长信息）
        p.advanced(by: i * MemoryLayout<Int>.stride).storeBytes(of: i, as: Int.self)
    }
    //取
    for i in 0..<4{
        let value = p.load(fromByteOffset: i * 8, as: Int.self)
        print("index\(i),value:\(value)")
    }
    //销毁内存p
    p.deallocate()
}

// MARK: 泛型指针
func unsafePointerDemo() {
    var age = 18
    withUnsafePointer(to: &age) { ptr in
        print(ptr)//打印age的内存指针
    }
    //修改指针
    age = withUnsafePointer(to: &age) { ptr in
        ptr.pointee + 21//pointee指针指向的数据类型
    }
    //    withUnsafeMutablePointer(to: &age) { prt in
    //        ptr.pointee += 10
    //    }
    print(age)
}

// MARK: 指针访问结构体
func pointVS() {
    struct LGStruct{
        var age: Int
        var height: Double
    }
    let tPtr = UnsafeMutablePointer<LGStruct>.allocate(capacity: 5)//5个LGStruct
    tPtr[0] = LGStruct(age: 18, height: 20.9)
    tPtr[1] = LGStruct(age: 19, height: 21.9)
    
    tPtr.deinitialize(count: 5)//把内存空间中数据抹0
    tPtr.deallocate()//回收内存
    //或者
    //    tPtr.advanced(by: <#T##Int#>).initialize(to: <#T##LGStruct#>)
}
// MARK: 指针读取machO中的属性名称
func loadMachO() {
    print(#function)
    class HHTeacherM{
        var age: Int = 18
        var name: String = "machh"
    }
    
    var size: UInt = 0
    //macho中__swift5_types section 的pFile
    let ptr = getsectdata("__TEXT", "__swift5_types", &size)
    //print(ptr)
    //获取当前程序运行地址 0x0000000100000000
    let mhHeaderPtr = _dyld_get_image_header(0)
    let setCommond64Ptr = getsegbyname("__LINKEDIT")
    var linkBaseAddress: UInt64 = 0
    if let vmaddr = setCommond64Ptr?.pointee.vmaddr, let fileOff = setCommond64Ptr?.pointee.fileoff{
        linkBaseAddress = vmaddr - fileOff//链接的基地址
    }
    
    var offset: UInt64 = 0
    if let unwrappedPtr = ptr{
        let intRepresentation = UInt64(bitPattern: Int64(Int(bitPattern: unwrappedPtr)))
        offset = intRepresentation - linkBaseAddress
    }
    
    //DataLo的内存地址
    let mhHeaderPtr_IntRepresentation = UInt64(bitPattern: Int64(Int(bitPattern: mhHeaderPtr)))
    
    var dataLoAddress = mhHeaderPtr_IntRepresentation + offset
    //print(UnsafePointer<UInt32>.init(bitPattern: Int(exactly: dataLoAddress) ?? 0)?.pointee)
    
    let dataLoAddressPtr = withUnsafePointer(to: &dataLoAddress){return $0}
    print(dataLoAddressPtr)
    
    let dataLoContent = UnsafePointer<UInt32>.init(bitPattern: Int(exactly: dataLoAddress) ?? 0)?.pointee
    
    let typeDescOffset = UInt64(dataLoContent!) + offset - linkBaseAddress
    
    let typeDescAddress = typeDescOffset + mhHeaderPtr_IntRepresentation
    
    //print(typeDescAddress)
    struct TargetClassDescriptor{
        var flags: UInt32
        var parent: UInt32
        var name: Int32
        var accessFunctionPointer: Int32
        var fieldDescriptor: Int32
        var superClassType: Int32
        var metadataNegativeSizeInWords: UInt32
        var metadataPositiveSizeInWords: UInt32
        var numImmediateMembers: UInt32
        var numFields: UInt32
        var fieldOffsetVectorOffset: UInt32
        var Offset: UInt32
        var size: UInt32
    }
    
    let classDescriptor = UnsafePointer<TargetClassDescriptor>.init(bitPattern: Int(exactly: typeDescAddress) ?? 0)?.pointee
    
    
    if let name = classDescriptor?.name{
        let nameOffset = Int64(name) + Int64(typeDescOffset) + 8
        print(nameOffset)
        let nameAddress = nameOffset + Int64(mhHeaderPtr_IntRepresentation)
        print(nameAddress)
        if let cChar = UnsafePointer<CChar>.init(bitPattern: Int(nameAddress)){
            print(String(cString: cChar))
        }
    }
    
    let filedDescriptorRelaticveAddress = typeDescOffset + 16 + mhHeaderPtr_IntRepresentation
    //print(filedDescriptorAddress)
    
    struct FieldDescriptor  {
        var mangledTypeName: Int32
        var superclass: Int32
        var Kind: UInt16
        var fieldRecordSize: UInt16
        var numFields: UInt32
        //    var fieldRecords: [FieldRecord]
    }
    
    struct FieldRecord{
        var Flags: UInt32
        var mangledTypeName: Int32
        var fieldName: UInt32
    }
    
    let fieldDescriptorOffset = UnsafePointer<UInt32>.init(bitPattern: Int(exactly: filedDescriptorRelaticveAddress) ?? 0)?.pointee
    //print(fieldDescriptorOffset)
    let fieldDescriptorAddress = filedDescriptorRelaticveAddress + UInt64(fieldDescriptorOffset!)
    
    let fieldDescriptor = UnsafePointer<FieldDescriptor>.init(bitPattern: Int(exactly: fieldDescriptorAddress) ?? 0)?.pointee
    
    
    for i in 0..<fieldDescriptor!.numFields{
        let stride: UInt64 = UInt64(i * 12)
        let fieldRecordAddress = fieldDescriptorAddress + stride + 16
        //    print(fieldRecordRelactiveAddress)
        //    let fieldRecord = UnsafePointer<FieldRecord>.init(bitPattern: Int(exactly: fieldRecordAddress) ?? 0)?.pointee
        //    print(fieldRecord)
        let fieldNameRelactiveAddress = UInt64(2 * 4) + fieldRecordAddress - linkBaseAddress + mhHeaderPtr_IntRepresentation
        let offset = UnsafePointer<UInt32>.init(bitPattern: Int(exactly: fieldNameRelactiveAddress) ?? 0)?.pointee
        //    print(offset)
        let fieldNameAddress = fieldNameRelactiveAddress + UInt64(offset!) - linkBaseAddress
        if let cChar = UnsafePointer<CChar>.init(bitPattern: Int(fieldNameAddress)){
            print(String(cString: cChar))
        }
    }
    
}

// MARK: 内存绑定。绕过编译器
func assumingMemoryBoundDemo() {
    func testPoint(_ p: UnsafePointer<Int>) {
        print(p)
    }
    let tuple = (10,20)
    withUnsafePointer(to: tuple) { (tuplePtr:UnsafePointer<(Int,Int)>) in
        testPoint(UnsafeRawPointer(tuplePtr).assumingMemoryBound(to: Int.self))
    }
}

class HHPointerMemoryVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        memSizeDemo()
        unsafePointerDemo()
    }
    
}
