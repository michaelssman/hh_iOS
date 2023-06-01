//
//  HHPlaceHolderTV.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/17.
//  占位文字的TextView

import UIKit

private let kTextKey: String = "text"

class HHPlaceHolderTV: UITextView {
    private let placeholderV = UITextView()
    
    @objc var placeHolder: String? {
        didSet {
            placeholderV.text = placeHolder
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpPlaceholderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpPlaceholderView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        removeObserver(self, forKeyPath: kTextKey)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderV.frame = bounds
    }
    
    private func setUpPlaceholderView() {
        placeholderV.isEditable = false
        placeholderV.isScrollEnabled = false
        placeholderV.showsHorizontalScrollIndicator = false
        placeholderV.showsVerticalScrollIndicator = false
        //userInteractionEnabled为YES 会拦截输入框的粘贴功能
        placeholderV.isUserInteractionEnabled = false
        placeholderV.font = font
        placeholderV.contentInset = contentInset
        placeholderV.contentOffset = contentOffset
        placeholderV.textContainerInset = textContainerInset
        placeholderV.textColor = .gray
        placeholderV.backgroundColor = .clear
        addSubview(placeholderV)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        
        addObserver(self, forKeyPath: kTextKey, options: .new, context: nil)
        
        ///刚开始的时候点击输入框要有反应 能够输入内容
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPlaceholderView))
        placeholderV.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var font: UIFont? {
        didSet {
            placeholderV.font = font
        }
    }
    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderV.textAlignment = textAlignment
        }
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            placeholderV.contentInset = contentInset
        }
    }
    
    override var contentOffset: CGPoint {
        didSet {
            placeholderV.contentOffset = contentOffset
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            placeholderV.textContainerInset = textContainerInset
        }
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        placeholderV.isHidden = hasText
    }
    
    ///点击输入框要有反应 能够输入内容
    @objc private func tapPlaceholderView() {
        becomeFirstResponder()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kTextKey {
            placeholderV.isHidden = hasText
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //占位文字的自适应高度
    func placeHolderMeasureHeight() -> Float {
        return ceilf(Float(placeholderV.sizeThatFits(frame.size).height) + 10)
    }
}

//// MARK: UITextViewDelegate
//extension HHPlaceHolderTV: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        //限制输入字数
//        if textView.text.count + text.count > 55 {
//            return false
//        }
//        return true
//    }
    func textViewDidChange(_ textView: UITextView) {
        let maxCharacterCount = 55 // 最大字符数
        if textView.text.count > maxCharacterCount {
            // 超过限制的字符数
            let excessText = textView.text.prefix(maxCharacterCount)
            // 更新textView的文本为限制的字符数
            textView.text = String(excessText)
        }
    }
//}

class HHGrowingTextV: HHPlaceHolderTV {
    let maxNumberOfLines: Int = 4
    @objc var maxHeight: Float {
        get {
            ceilf(Float(font!.lineHeight) * Float(maxNumberOfLines) + 15 + 4 * (Float(maxNumberOfLines) - 1))
        }
    }
    
    
    
    @objc init(placeholder: String) {
        super.init(frame: .zero, textContainer: nil)
        placeHolder = placeholder
        font = .systemFont(ofSize: 16)
        tintColor = .blue
        isScrollEnabled = false
        scrollsToTop = false
        showsHorizontalScrollIndicator = false
        enablesReturnKeyAutomatically = true
        textContainerInset = UIEdgeInsets(top: 7.5, left: 3.5, bottom: 7.5, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 根据textView的内容和size，获取自适应高度
    @objc func measureHeight() -> Float {
        if text.count == 0 {
            return placeHolderMeasureHeight()
        } else {
            return ceilf(Float(sizeThatFits(frame.size).height) + 10)
        }
    }
}
