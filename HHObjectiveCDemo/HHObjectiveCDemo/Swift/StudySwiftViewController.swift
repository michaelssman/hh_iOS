//
//  StudySwiftViewController.swift
//  HHSwift
//
//  Created by Michael on 2022/4/2.
//

import UIKit
import RxSwift
import RxCocoa

let key:String = "key"
let valueStr:String = "valueStr"

class StudySwiftViewController: BaseViewController {
    
    var demos: Bool = false
    
    // MARK: 创建了一个DisposeBag实例，以便在视图控制器被销毁时正确处理可观察序列
    let disposeBag = DisposeBag()
    
    convenience init(demos: Bool) {
        self.init()
        self.demos = demos
        if demos == true {
            self.title = "首页"
        } else {
            self.title = "demo"
        }
    }
    
    //数据源
    private lazy var array: Array = {
        if !self.demos {
            return [
                [key:"TargetClassMetadataViewController包",valueStr:"TargetClassMetadataViewController"],
                [key:"Collection集合",valueStr:"HH_CollectionVC"],
                [key:"指针和内存",valueStr:"HHPointerMemoryVC"],
            ]
        } else {
            return [
                [key:"通讯录",valueStr:"ContactsViewController"],
                [key:"HHPickerView",valueStr:"HHPickerView"]
            ]
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - UIDevice.vg_navigationFullHeight() - UIDevice.vg_tabBarFullHeight())),
                                    style: .plain)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HHBaseTableViewCell")
        tableView.rowHeight = 80
        // MARK: 下拉刷新
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.rx.controlEvent(.valueChanged)
            .filter { refreshControl.isRefreshing }
            .bind { [weak self] _ in /*加载数据方法*/ }
            .disposed(by: disposeBag)
        tableView.refreshControl = refreshControl
        // MARK: 结束刷新 必须在主线程！！！！！
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        
    }
    
}


extension StudySwiftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HHBaseTableViewCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row][key]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if array[indexPath.row][valueStr] == "HHPickerView" {
            var hs: Array = Array<String>()
            for i in 1...12 {
                hs.append("\(i)时")
            }
            var ms: Array = Array<String>()
            for i in 1..<60 {
                ms.append("\(i)分")
            }
            let pv: HHPickerView = HHPickerView.pickerView(CGRect(x: 0, y: SCREEN_HEIGHT - 281, width: SCREEN_WIDTH, height: 280), dataSource: [["上午","下午"],hs,ms])
            let bgV: UIView = UIView(frame: UIScreen.main.bounds)
            bgV.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            
            //添加一个点击手势
            let tapBackground = UITapGestureRecognizer()
            bgV.addGestureRecognizer(tapBackground)
            //页面上任意处点击，输入框便失去焦点
            tapBackground.rx.event.subscribe(onNext: { _ in
                bgV.removeFromSuperview()
            }).disposed(by: disposeBag)
            bgV.addSubview(pv)
            keyWindow().addSubview(bgV)
            return;
        }
        navigationController?.pushViewController(classFromString(array[indexPath.row][valueStr]!), animated: true)
    }
}

func classFromString(_ className:String) -> UIViewController{
    //1、获swift中的命名空间名
    var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
    //2、如果包名中有'-'横线这样的字符，在拿到包名后，还需要把包名的'-'转换成'_'下横线
    name = name?.replacingOccurrences(of: "-", with: "_")
    //3、拼接命名空间和类名，”包名.类名“
    let fullClassName = name! + "." + className
    //通过NSClassFromString获取到最终的类，由于NSClassFromString返回的是AnyClass，这里要转换成UIViewController.Type类型
    guard let classType = NSClassFromString(fullClassName) as? UIViewController.Type  else{
        fatalError("转换失败")
    }
    return classType.init()
}


