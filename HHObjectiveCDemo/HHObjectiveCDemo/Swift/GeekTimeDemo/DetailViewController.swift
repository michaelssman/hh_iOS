//
//  DetailViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/11/4.
//

import UIKit
import Kingfisher

class DetailViewController: BaseViewController {
    
    var product: Product!
    var avatarView: UIImageView!
    var nameLabel: UILabel!
    var descLabel: UILabel!
    var teacherLabel: UILabel!
    var courseCountLabel: UILabel!
    var studentCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "详情"
        crateTop()
    }
    
    private func crateTop() {
        let topView = UIView()
        topView.layer.contents = R.image.detailBg()?.cgImage
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.masksToBounds = true
        blurView.alpha = 0.7
        view.addSubview(topView)
        topView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(200)
        }
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(200)
        }
        
        avatarView = UIImageView()
        let round = RoundCornerImageProcessor(cornerRadius: 10)
        avatarView.kf.setImage(with: URL(string: product.imageUrl), placeholder: nil, options: [.processor(round)])
        topView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.left.top.equalTo(topView).offset(20)
            make.width.equalTo(82)
            make.height.equalTo(108)
        }
        
        nameLabel = UILabel(frame: .zero)
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.text = product.name
        topView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp_right).offset(10)
            make.top.equalTo(avatarView)
            make.right.equalTo(topView).offset(-15)
        }
        
        descLabel = UILabel(frame: .zero)
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.text = product.desc
        descLabel.numberOfLines = 2
        topView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp_right).offset(10)
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
            make.right.equalTo(topView).offset(-15)
        }
        
        teacherLabel = UILabel(frame: .zero)
        teacherLabel.textColor = .white
        teacherLabel.font = UIFont.systemFont(ofSize: 14)
        teacherLabel.text = "讲师：\(product.teacher)"
        topView.addSubview(teacherLabel)
        teacherLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp_right).offset(10)
            make.bottom.equalTo(avatarView)
            make.right.equalTo(topView).offset(-15)
        }
        
        
        let bookAttachment = NSTextAttachment()
        bookAttachment.image = R.image.book()
        bookAttachment.bounds = CGRect(x: -2, y: -3, width: bookAttachment.image?.size.width ?? 0, height: bookAttachment.image?.size.height ?? 0)
        let bookAttachmentString = NSAttributedString(attachment: bookAttachment)
        let courseCountString = NSMutableAttributedString(string: "")
        courseCountString.append(bookAttachmentString)
        
        let courseCountStringAfterIcon = NSAttributedString(string: " 共 \(product.total) 讲 更新至 \(product.update) 讲")
        courseCountString.append(courseCountStringAfterIcon)
        
        courseCountLabel = UILabel(frame: .zero)
        courseCountLabel.textColor = .white
        courseCountLabel.font = UIFont.systemFont(ofSize: 14)
        courseCountLabel.attributedText = courseCountString
        topView.addSubview(courseCountLabel)
        courseCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(20)
            make.bottom.equalTo(topView).offset(-15)
        }
        
        
        let studentAttachment = NSTextAttachment()
        studentAttachment.image = R.image.student()
        studentAttachment.bounds = CGRect(x: -2, y: -3, width: studentAttachment.image?.size.width ?? 0, height: studentAttachment.image?.size.height ?? 0)
        let studentAttachmentString = NSAttributedString(attachment: studentAttachment)
        let studentCountString = NSMutableAttributedString(string: "")
        studentCountString.append(studentAttachmentString)
        
        let studentCountStringAfterIcon = NSAttributedString(string: " 共 \(product.studentCount) 人学习")
        studentCountString.append(studentCountStringAfterIcon)
        
        studentCountLabel = UILabel(frame: .zero)
        studentCountLabel.textColor = .white
        studentCountLabel.font = UIFont.systemFont(ofSize: 14)
        studentCountLabel.attributedText = studentCountString
        topView.addSubview(studentCountLabel)
        studentCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(topView).offset(-20)
            make.bottom.equalTo(topView).offset(-15)
        }
        
    }

  }
