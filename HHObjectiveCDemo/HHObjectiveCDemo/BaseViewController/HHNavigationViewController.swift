//
//  HHNavigationViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/5/28.
//

import UIKit

class HHNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIColor(UIColor(0xFFFFFF), darkColor: UIColor(0x1B1B21)).toImage()
            appearance.backgroundColor = UIColor(UIColor(0xFFFFFF), darkColor: UIColor(0x1B1B21))
            appearance.shadowColor = .clear
            appearance.backgroundEffect = UIBlurEffect(style: .regular);
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
        
    }
    
    //push隐藏底部Tabbar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let leftButton: UIButton = UIButton(type: .custom)
            leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            leftButton.setTitle("返回", for: .normal)
            leftButton.setTitleColor(UIColor(0x0D0D0D), for: .normal)
            leftButton.addTarget(self, action: #selector(popViewController(animated:)), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}

enum NavigationBarStyle {
    ///navbar APP主题
    case theme
    ///navbar 透明
    case clear
    ///navbar 白色的
    case white
}

extension UINavigationController {
    
    func navBarStyle(_ style:NavigationBarStyle) {
        navigationBar.barStyle = .default
        let attrDic = [NSAttributedString.Key.foregroundColor:UIColor.black,
                       NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18.0)]
        if #available(iOS 13.0, *) {
            let barApp = UINavigationBarAppearance()
            //            barApp.backgroundColor = .white
            //基于backgroundColor或backgroundImage的磨砂效果
            barApp.backgroundEffect = nil
            //阴影颜色（底部分割线），当shadowImage为nil时，直接使用此颜色为阴影色。如果此属性为nil或clearColor（需要显式设置），则不显示阴影。
            //barApp.shadowColor = nil;
            //标题文字颜色
            barApp.titleTextAttributes = attrDic
            navigationBar.scrollEdgeAppearance = barApp
            navigationBar.standardAppearance = barApp
        }else {
            navigationBar.titleTextAttributes = attrDic
            
            let navBgImg = UIImage(named: "nav_bg")!.withRenderingMode(.alwaysOriginal)
            
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(navBgImg, for: .default)
            //                navigationBar.setBackgroundImage(UIColor.white.toImage(), for: .default)
            
        }
        //透明设置
        navigationBar.isTranslucent = false;
        //navigationItem控件的颜色
        navigationBar.tintColor = .white
    }
    
}
