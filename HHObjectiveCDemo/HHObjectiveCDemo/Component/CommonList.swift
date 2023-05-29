//
//  CommonList.swift
//  HHSwift
//
//  Created by Michael on 2022/11/5.
// cell不一样，model不一样。使用泛型抽象出来。cell是类型转换，model是范型。
// 分页，刷新等等都可以在这里面实现

import Foundation
import UIKit
import SnapKit

//支持泛型
class CommonListCell<ItemType>: UITableViewCell {
    var item: ItemType?//ItemType是数据模型model
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //设置背景颜色
        backgroundColor = UIColor.designKit.background
        contentView.backgroundColor = UIColor.designKit.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// cell不一样，model不一样。使用泛型抽象出来。Cell的类型就是CommonListCell基类
class CommonList<ItemType, CellType: CommonListCell<ItemType>>: UIView, UITableViewDataSource {
    
    var tableView: UITableView
    var items: [ItemType]! = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        self.setupViews()
    }
    
    func setupViews() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //as? UITableViewCell转ProductCell（具体的cellType）
        var cell: CellType? = tableView.dequeueReusableCell(withIdentifier: "cellId") as? CellType
        if cell == nil {
            cell = CellType(style: .subtitle, reuseIdentifier: "cellId")
        }
        cell?.item = items[indexPath.row]
        return cell!
    }
}
