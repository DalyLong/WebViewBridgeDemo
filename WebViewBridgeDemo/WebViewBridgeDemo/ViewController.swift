//
//  ViewController.swift
//  WebViewBridgeDemo
//
//  Created by Public on 2018/11/9.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    fileprivate var tableView : UITableView!
    fileprivate var titles : Array<String> = ["WebViewJavascriptBridge实现与js交互"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI() {
        self.navigationItem.title = "首页"
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height+44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-UIApplication.shared.statusBarFrame.height-44))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        self.view.addSubview(self.tableView)
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = self.titles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(WebViewVC(), animated: true)
    }
    
}


