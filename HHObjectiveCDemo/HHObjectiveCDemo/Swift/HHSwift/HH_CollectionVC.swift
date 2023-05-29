//
//  HH_CollectionVC.swift
//  HHSwift
//
//  Created by Michael on 2022/4/15.
//  集合

import UIKit

//Collection表达一个环形数组
extension FixedWidthInteger {
    /// Returns the next power of two.
    @inlinable
    func nextPowerOf2() -> Self {
        guard self != 0 else {
            return 1
        }
        //
        return 1 << (Self.bitWidth - (self - 1).leadingZeroBitCount)
    }
}
struct RingBuffer<Element>{
    //ContiguousArray和Array差不多，swift使用ContiguousArray更高效
    internal var _buffer: ContiguousArray<Element?>
    internal var headIndex: Int = 0
    internal var tailIndex: Int = 0
    
    internal var mask: Int{
        return self._buffer.count - 1
    }
    
    init(initalCapacity: Int) {
        let capcatiy = initalCapacity.nextPowerOf2()
        
        self._buffer = ContiguousArray<Element?>.init(repeating: nil, count:capcatiy)
    }
    
    mutating func advancedTailIndex(by: Int){
        self.tailIndex = self.indexAdvanced(index: self.tailIndex, by: by)
    }
    
    mutating func advancedHeadIndex(by: Int){
        self.headIndex = self.indexAdvanced(index: self.headIndex, by: by)
    }
    //移动
    func indexAdvanced(index: Int, by: Int) -> Int{
        return (index + by) & self.mask
    }
    
    //拼接元素
    mutating func append(_ value: Element){
        _buffer[self.tailIndex] = value
        self.advancedTailIndex(by: 1)
        
        if self.tailIndex == self.headIndex {
            fatalError("out of bounds")
        }
    }
    //读一个元素
    mutating func read() -> Element?{
        let element = _buffer[self.headIndex]
        self.advancedHeadIndex(by: 1)
        return element
    }
}

// MARK: RingBuffer遵循Collection, MutableCollection协议：通过下标修改元素
extension RingBuffer: Collection, MutableCollection{
    //开始下标
    var startIndex: Int{
        return self.headIndex
    }
    //结束下标
    var endIndex: Int{
        return self.tailIndex
    }
    
    subscript(position: Int) -> Element? {
        get{
            return self._buffer[position]
        }
        //MutableCollection协议需要实现，修改元素
        set{
            self._buffer[position] = newValue
        }
    }
    //位置
    func index(after i: Int) -> Int {
        return (i + 1) & self.mask
    }
}

//允许集合修改任意区间的元素
//extension RingBuffer: RangeReplaceableCollection{
//    
//    init() {
//        self.init(initalCapacity: 20)
//    }
//    
//    mutating func remove(at position: Int) -> Element? {
//        var currentIndex = position
//        let element = self._buffer[position]
//        switch position {
//        case self.headIndex://删除第一个元素 头节点
//            self.advancedHeadIndex(by: 1)
//            self._buffer[currentIndex] = nil
//        default:
//            self._buffer[position] = nil
//            var nextIndex = self.indexAdvanced(index: position, by: 1)
//            //交换下标
//            while nextIndex != self.tailIndex {
//                self._buffer.swapAt(currentIndex, nextIndex)
//                currentIndex = nextIndex
//                nextIndex = self.indexAdvanced(index: currentIndex, by: 1)
//            }
//            //移动尾节点 向前移动一个
//            self.advancedTailIndex(by: -1)
//            
//        }
//        return element
//    }
//}
//extension RingBuffer:ExpressibleByArrayLiteral{
//    init(arrayLiteral elements: Element...) {
//        self.init(elements)
//    }
//}

// MARK: BidirectionalCollection协议 可以向前 向后遍历集合
extension RingBuffer: BidirectionalCollection{
    func index(before i: Int) -> Int {//返回一个向前的index
        return (i - 1) & self.mask
    }
}

// MARK: RandomAccessCollection 任意访问集合
extension RingBuffer: RandomAccessCollection{
    func index(_ i: Int, offsetBy distance: Int) -> Int {
        return (i + distance) & self.mask
    }
        
    func distance(from start: Int, to end: Int) -> Int {
        return end - start
    }
}

func testCollection() {
    var buff: RingBuffer = RingBuffer<Int>.init(initalCapacity: 10)
    for i in 1...10{
        buff.append(i)
    }
    print(buff.index(0, offsetBy: 6))//访问第6个元素
}

class HH_CollectionVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        testCollection()
    }
    
}
