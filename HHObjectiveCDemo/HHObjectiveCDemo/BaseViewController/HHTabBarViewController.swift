//
//  HHTabBarViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/4/12.
//

import UIKit

class HHTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addChildViewController(ViewController(type: VCType(rawValue: 0)!), title: "呵呵", image: R.image.home(), selectedImage: R.image.home_selected())
        addChildViewController(ViewController(type: VCType(rawValue: 1)!), title: "Demos", image: R.image.home(), selectedImage: R.image.home_selected())

        addChildViewController(StudySwiftViewController(), title: "基础", image: R.image.home(), selectedImage: R.image.home_selected())
        addChildViewController(StudySwiftViewController(demos: true), title: "Demos", image: R.image.mine(), selectedImage: R.image.mine_selected())
        addChildViewController(MineViewController(), title: "我的", image: R.image.mine(), selectedImage: R.image.mine_selected())
        
        setUpStyle()
//        setUpShadow()
    }
    
}

extension UITabBarController {
    func addChildViewController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
        let navVC: HHNavigationViewController = HHNavigationViewController(rootViewController: childController)
        navVC.navigationBar.isTranslucent = false
        navVC.tabBarItem = UITabBarItem(title: title,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        navVC.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.hexColor(0x333333), .font:UIFont.systemFont(ofSize: 11)], for: .normal)
        navVC.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.black, .font:UIFont.systemFont(ofSize: 11)], for: .selected)
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        }
        addChild(navVC)
    }
    
    func setUpStyle() {
        if #available(iOS 13.0, *) {
            let appearance: UITabBarAppearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.designKit.background
            appearance.backgroundImage = UIImage()
            appearance.shadowColor = .clear
            tabBar.standardAppearance = appearance
            //滑动到底部，变色
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
        }
        //选中字体颜色
        tabBar.tintColor = UIColor.black
    }
    
    // MARK: 设置阴影
    func setUpShadow() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity = 0.1
    }
}
