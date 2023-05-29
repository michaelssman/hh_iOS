//
//  BottomView.swift
//  HHSwift
//
//  Created by Michael on 2022/12/28.
//

import UIKit
class BottomTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 120, height: bounds.height))
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    lazy var desLabel: UILabel = {
        let desLabel: UILabel = UILabel(frame: CGRect(x: 250, y: 0, width: UIScreen.main.bounds.width - 260, height: bounds.height))
        desLabel.textAlignment = .left
        return desLabel
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(desLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BottomView: UIView {
    @objc var selectTitle: String?
    @objc var didSelectRow: ((_ bottomV: BottomView,_ index: Int) -> Void)?
    @objc var didRemoveFromSuperview: ((_ bottomV: BottomView) -> Void)?
    @objc lazy var objects: Array<[String:Any]> = [] {
        didSet{
            tableView.reloadData()
        }
    }
    lazy var titleView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: bounds.height - 343, width: bounds.width, height: 43))
        titleView.backgroundColor = UIColor(0xF7F7F8)
        //圆角
        let bezierPath: UIBezierPath = UIBezierPath(roundedRect: titleView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = titleView.bounds
        shapeLayer.path = bezierPath.cgPath
        titleView.layer.mask = shapeLayer
        
        let titleLabel = UILabel(frame: titleView.bounds)
        titleLabel.text = "销售记录"
        titleLabel.textColor = UIColor(0x0D0D0D)
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 13)
        titleView.addSubview(titleLabel)
        return titleView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: bounds.height - 300, width: bounds.width, height: 300), style: .plain)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BottomTableViewCell.self, forCellReuseIdentifier: "BottomTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgV: UIView = UIView(frame: bounds)
        bgV.backgroundColor = UIColor(0x000000, alphaValue: 0.5)
        bgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeFromSuperview)))
        addSubview(bgV)
        addSubview(titleView)
        addSubview(tableView)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if let didRemoveFromSuperview = didRemoveFromSuperview {
            didRemoveFromSuperview(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension BottomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BottomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BottomTableViewCell", for: indexPath) as! BottomTableViewCell
        cell.titleLabel.text = objects[indexPath.row]["ModifiedDate"] as? String
        cell.desLabel.text = "¥ \(objects[indexPath.row]["LatestPrice"] ?? "")"
        
        //        if objects[indexPath.row] == selectTitle {
        //            cell.titleLabel.textColor = UIColor(0x477AFF)
        //            cell.desLabel.textColor = UIColor(0x477AFF)
        //        } else {
        //            cell.titleLabel.textColor = UIColor(0x0D0D0D)
        //            cell.desLabel.textColor = UIColor(0x0D0D0D)
        //        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hv: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        hv.backgroundColor = .white
        let lv: UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 44))
        lv.textColor = UIColor(0x7E7E7E)
        lv.text = "最近销售时间"
        lv.font = .systemFont(ofSize: 14)
        hv.addSubview(lv)
        let rv: UILabel = UILabel(frame: CGRect(x: 250, y: 0, width: UIScreen.main.bounds.width - 260, height: 44))
        rv.text = "最近销售价"
        rv.textColor = UIColor(0x7E7E7E)
        rv.font = .systemFont(ofSize: 14)
        hv.addSubview(rv)
        return hv
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectRo = didSelectRow {
            didSelectRo(self,indexPath.row)
        }
        removeFromSuperview()
    }
}
