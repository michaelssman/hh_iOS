//
//  HHPickerView.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/13.
//

/**
 1. 弯曲弧度
 UIPickerView是1列的时候 没有弯曲弧度
 当UIPickerView有多列的时候，会有一个默认弯曲弧度，此时可以使用多个UIPickerView，每个UIPickerView都是单列。根据UIPickerView的tag来判断是哪一列。
 2. 有单位的时候
 选中的row有一个单位，可以创建一个label放在UIPickerView上，高度是row的高度，y是UIPickerView的高度减去row的高度除以2.
 */

import UIKit
import SnapKit
class HHPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    private let kRowHeight: CGFloat = 48
    private let selectedColor: UIColor = UIColor(0x323233)
    private let normalColor: UIColor = UIColor(0x646566)
    @objc lazy var pickerViews: Array<UIPickerView> = {
        let pickerViews: Array = Array<UIPickerView>()
        return pickerViews
    }()
    private var dataSource: [Any] = [] {
        didSet {
            
        }
    }
    
    @objc static func pickerView(_ frame: CGRect, dataSource: [Any]) -> HHPickerView {
        let pickView = HHPickerView(frame: frame)
        pickView.backgroundColor = .white
        pickView.dataSource = dataSource
        pickView.setUpSubViews()
        return pickView
    }
    
    private func setUpSubViews() {
        let pickerCount = dataSource.count
        let pickerWidth = SCREEN_WIDTH * 1.0 / CGFloat(pickerCount)
        for i in 0..<pickerCount {
            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.tag = i
            // pickerView 初始化显示
            pickerView.selectRow(0, inComponent: 0, animated: true)
            addSubview(pickerView)
            pickerView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(pickerWidth * CGFloat(i))
                make.width.equalTo(pickerWidth)
                make.top.height.equalToSuperview()
            }
            pickerViews.append(pickerView)
        }
        for i in 0...1 {
            let lineView: UIView = UIView(frame: CGRect(x: 15, y: (bounds.height - kRowHeight) * 0.5 + kRowHeight * CGFloat(i), width: SCREEN_WIDTH - 30, height: 0.5))
            lineView.backgroundColor = UIColor(0xEBEDF0)
            addSubview(lineView)
        }
    }
    
    // MARK: - UIPickerViewDataSource & UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (dataSource[pickerView.tag] as! Array<Any>).count
    }
    // MARK: 滑动结束
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select:\(row)")
        let newLab: UILabel = pickerView.view(forRow: row, forComponent: component) as! UILabel
        newLab.textColor = selectedColor
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kRowHeight
    }
    
    // MARK: 滑动过程调用。即将选中的row、新出现的row、取消选中的row。
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //MARK: iOS14取消UIPickerView的选中颜色
        for subview in pickerView.subviews {
            subview.backgroundColor = UIColor.clear
        }
        
        let pickerLabel: UILabel = view as? UILabel ?? UILabel()
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .center
        //        pickerLabel.attributedText = self.pickerView(pickerView, attributedTitleForRow: row, forComponent: component)
        pickerLabel.textColor = normalColor
        let titleString = "\((dataSource[pickerView.tag] as! Array<Any>)[row])"
        pickerLabel.text = titleString
        return pickerLabel
    }
    
}
