//
//  BiometricLoginViewController.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/5/15.
//

import UIKit
import RxSwift
import RxCocoa
class BiometricLoginViewController: BaseViewController {

    let disposeBag = DisposeBag()

    lazy var iconImageV: UIImageView = {
        let iconImageV: UIImageView = UIImageView()
        iconImageV.backgroundColor = .lightGray
        return iconImageV
    }()
    lazy var statusLab: UILabel = {
        let statusLab: UILabel = UILabel(textColor: UIColor(hex: 0x333333), fontSize: 24)
        statusLab.text = "欢迎登录"
        return statusLab
    }()
    lazy var biometricImageV: UIImageView = {
        let biometricImageV: UIImageView = UIImageView()
        biometricImageV.backgroundColor = .lightGray
        return biometricImageV
    }()
    lazy var infoLab: UILabel = {
        let infoLab: UILabel = UILabel(textColor: UIColor.designKit.primary, fontSize: 24)
        infoLab.text = "点击进行Face ID登录"
        return infoLab
    }()
    lazy var changeLogin: UIButton = {
        let changeLogin = UIButton(type: .custom)
        changeLogin.setTitle("切换登录方式", for: .normal)
        changeLogin.setTitleColor(UIColor.designKit.primary, for: .normal)
        return changeLogin
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(iconImageV)
        view.addSubview(statusLab)
        view.addSubview(biometricImageV)
        view.addSubview(infoLab)
        view.addSubview(changeLogin)
        
        iconImageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(115)
            make.size.equalTo(CGSize(width: 71, height: 72))
        }
        statusLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageV.snp.bottom).offset(19)
        }
        biometricImageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusLab.snp.bottom).offset(107)
            make.size.equalTo(CGSize(width: 59, height: 58))
        }
        infoLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(biometricImageV.snp.bottom).offset(18)
        }
        changeLogin.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-62)
        }
        
        
        changeLogin.rx.tap.subscribe { [weak self] _ in
            let vc = LoginViewController()
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
