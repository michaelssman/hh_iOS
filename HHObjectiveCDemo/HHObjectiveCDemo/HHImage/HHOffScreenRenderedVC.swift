//
//  HHOffScreenRenderedVC.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/6/19.
//  离屏渲染

import UIKit

class HHOffScreenRenderedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //按钮存在背景图片(not offscreen rendering)
        //单层视图 不离屏
        let btn1: UIButton = UIButton(type: .custom)
        btn1.frame = CGRect(x: 100, y: 30, width: 100, height: 100)
        btn1.setImage(UIImage(named: "mew_baseline.png"), for: .normal)
        view.addSubview(btn1)
        //使用这个会触发离屏渲染
//        btn1.layer.cornerRadius = 50
        //使用这个不会触发离屏渲染
        btn1.imageView?.layer.cornerRadius = 50
        btn1.clipsToBounds = true
        
        //按钮不存在背景图片
        //单层视图 不离屏
        let btn2: UIButton = UIButton(type: .custom)
        btn2.frame = CGRect(x: 100, y: 180, width: 100, height: 100)
        btn2.backgroundColor = .blue
        view.addSubview(btn2)
        btn2.imageView?.layer.cornerRadius = 50
        btn2.clipsToBounds = true
        
        //UIImageView 多层：图片+背景色 会触发离屏渲染。
        let img1: UIImageView = UIImageView()
        img1.frame = CGRect(x: 100, y: 320, width: 100, height: 100)
        img1.backgroundColor = .blue
        img1.image = UIImage(named: "mew_baseline.png")
        view.addSubview(img1)
        img1.layer.cornerRadius = 50
        img1.layer.masksToBounds = true
        
        //UIImageView 只设置了图片,无背景色。不会触发离屏渲染。
        let img2: UIImageView = UIImageView()
        img2.frame = CGRect(x: 100, y: 480, width: 100, height: 100)
        img2.image = UIImage(named: "mew_baseline.png")
        view.addSubview(img2)
        img2.layer.cornerRadius = 50
        img2.layer.masksToBounds = true
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
