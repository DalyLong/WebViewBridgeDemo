//
//  WebViewVC.swift
//  WebViewBridgeDemo
//
//  Created by Public on 2018/11/9.
//  Copyright © 2018 Long. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

class WebViewVC: UIViewController {
    
    fileprivate var webView : WKWebView!
    fileprivate var progressView : UIProgressView!
    fileprivate var bridge : WebViewJavascriptBridge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initBridge()
        self.loadUrl()
    }
    
    func initUI(){
        self.navigationItem.title = "加载网页"
        self.view.backgroundColor = UIColor.white
        self.webView = WKWebView.init(frame: CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height+44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-UIApplication.shared.statusBarFrame.height-44))
        
        //禁止3DTouch
        self.webView.allowsLinkPreview = false
        self.webView.navigationDelegate = self
        //添加监听
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        //这行代码可以是侧滑返回webView的上一级，而不是根控制器（*只针对侧滑有效）
        self.webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(self.webView)
        
        self.progressView = UIProgressView.init(progressViewStyle: .default)
        self.progressView.frame = CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.height+44, width: UIScreen.main.bounds.width, height: 5)
        self.progressView.trackTintColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.progressView.progressTintColor = UIColor.green
        self.progressView.isHidden = true
        self.view.addSubview(self.progressView)
        
        self.addRightItem()
    }
    
    func addRightItem() {
        let button = UIButton.init(type: .custom)
        button.isUserInteractionEnabled = true
        button.setTitleColor(UIColor.init(red: 54/255, green: 147/255, blue: 249/255, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.init(red: 100/255, green: 174/255, blue: 235/255, alpha: 1), for: .highlighted)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .right
        button.frame = CGRect.init(x: 0, y: 0, width: 70, height: 44)
        button.addTarget(self, action: #selector(righItemAction), for: .touchUpInside)
        button.setTitle("调用js", for: .normal)
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        let backItem = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItems = [negativeSpacer,backItem]
    }
    
    @objc func righItemAction(){
        //通过bridge调用js方法
        self.bridge.callHandler("showAlert", data: "这是Swift传向js的字符串!")
        self.bridge.callHandler("getCurrentPageUrl", data: nil) { responseData in
            let str : String = responseData as! String
            print("获得js返回的地址:"+str)
        }
    }
    
    func initBridge() {
        //注册方法，js可以调用注册过后的方法
        self.bridge = WebViewJavascriptBridge.init(forWebView: self.webView)
        self.bridge.registerHandler("getScreenHeight") { data, responseCallback in
            responseCallback!(UIScreen.main.bounds.size.height)
            let str : String = data as! String
            print("获得js传递的字符串:"+str)
        }
    }
    
    private func loadUrl(){
        let url = URL.init(fileURLWithPath:Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "vue")!)
        let request = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15.0)
        self.webView?.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.alpha = 1
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= Double(1) {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finished) in
                    self.progressView.setProgress(0, animated: false)
                })
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension WebViewVC : WKNavigationDelegate{
    ///页面开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
    }
    ///开始获取到网页内容时返回
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    ///页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.isHidden = true
    }
    ///页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}
