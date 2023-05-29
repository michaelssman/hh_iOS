//
//  BaseViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/4/13.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.view.bounds)
        //始终可以上下滑动
        scrollView.alwaysBounceVertical = true
        scrollView.contentSize = self.view.bounds.size;
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(0xf2f4f7)

        ///navigationBar
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(0x333333)]
        
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
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
