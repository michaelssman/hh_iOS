//
//  MineViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/11/5.
//

import UIKit
import SnapKit

class MineViewController: BaseViewController {
    
    var accountCell: CommonCell!
    var purchasedCell: CommonCell!
    var dealCell: CommonCell!
    var groupCell: CommonCell!
    
    var avatarView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTopViews()
        self.createFirstGroupCells()
    }
    
    private func createTopViews() {
        let topView = UIView(frame: .zero)
        topView.backgroundColor = .white
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        avatarView = UIImageView(image: R.image.defaultAvatarJpg())
        avatarView.layer.cornerRadius = 60
        avatarView.layer.masksToBounds = true
        topView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(120)
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("点击登录", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(UIColor.hexColor(0x333333), for: .normal)
        button.addTarget(self, action: #selector(didClickLoginButton), for: .touchUpInside)
        topView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(15)
            make.top.equalTo(avatarView).offset(15)
        }
    }
    
    @objc func didClickLoginButton() {
        let vc = BiometricLoginViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true)
    }
    
    @objc func didClickPurchasedCell() {
    }
    
    private func createFirstGroupCells() {
        accountCell = CommonCell()
        accountCell.icon = R.image.icon_life()
        accountCell.title = "账户"
        view.addSubview(accountCell)
        accountCell.snp.makeConstraints { (make) in
            make.top.equalTo(170)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        
        purchasedCell = CommonCell()
        purchasedCell.icon = R.image.icon_between()
        purchasedCell.title = "已购"
        purchasedCell.addTarget(self, action: #selector(didClickPurchasedCell), for: .touchUpInside)
        view.addSubview(purchasedCell)
        purchasedCell.snp.makeConstraints { (make) in
            make.top.equalTo(accountCell.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        
        dealCell = CommonCell()
        dealCell.icon = R.image.icon_live()
        dealCell.title = "商城订单"
        view.addSubview(dealCell)
        dealCell.snp.makeConstraints { (make) in
            make.top.equalTo(purchasedCell.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        
        groupCell = CommonCell()
        groupCell.icon = R.image.icon_document()
        groupCell.title = "我的拼团"
        view.addSubview(groupCell)
        groupCell.snp.makeConstraints { (make) in
            make.top.equalTo(dealCell.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
    }
}
