//
//  JHBaseWebViewVC.swift
//  JHWebview
//
//  Created by Jonhory on 2017/2/26.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit
import WebKit

class JHBaseWebViewVC: BaseViewController {

    /// 网页
    var webView: WKWebView!
    /// 网址链接
    var url: String!
    /// 与JS通讯的标志符
    var iOSToJSName: String!
    /// 进度条
    var progressView: UIProgressView?
    
    class func create(_ url:String , iOSToJSName: String?) -> JHBaseWebViewVC {
        let vc = JHBaseWebViewVC()
        vc.url = url
        vc.iOSToJSName = iOSToJSName
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.leftHelpBtn?.isHidden = true
        self.titleLabel?.backgroundColor = UIColor.yellow
        
        if !checkUrlIsSafe() {
            return
        }
        loadWebView()
        loadProgressView()
    }
    
    override func leftBtnClicked(btn: UIButton) {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        popBack()
    }
    
    override func leftHelpBtnClicked(btn: UIButton) {
        popBack()
    }
    
    func popBack() {
        if iOSToJSName != nil {
            removeWKScriptMessageHandler()
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func checkUrlIsSafe() -> Bool {
        if url == nil  {
            print("当前URL为空，请检查")
            return false
        }
        return true
    }
    
    func loadWebView() {
        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        if iOSToJSName != nil {
            userContent.add(self, name: iOSToJSName)
        }
        config.userContentController = userContent
        
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL!)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
        
        self.view.addSubview(webView)
    }

    func loadProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.frame = CGRect(x: webView.frame.origin.x, y: 64, width: webView.bounds.size.width, height: 10)
        progressView?.progressTintColor = UIColor.red
        progressView?.trackTintColor = UIColor.blue
        progressView?.progress = 0.00
        self.view.addSubview(progressView!)
    }
    
    //MARK: 原生调用JS
    func handleWebViewWithJS() {
        webView.evaluateJavaScript("showAlert('奏是一个弹框')") { (item, error) in
            // 闭包中处理是否通过了或者执行JS错误的代码
        }
    }
    
    /// 记得移除 ===>>>
    func removeWKScriptMessageHandler() {
        if iOSToJSName != nil {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: iOSToJSName)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("已释放➡️ \(self)")
    }
}


// MARK: - WKNavigationDelegate
extension JHBaseWebViewVC: WKNavigationDelegate {
    /// 准备加载页面
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("准备加载页面 ",webView.estimatedProgress)
        self.progressView?.isHidden = false
        self.progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    /// 内容开始加载
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("内容开始加载 ",webView.estimatedProgress)
        self.progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    /// 页面加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成 ",webView.estimatedProgress)
        self.progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
        if webView.estimatedProgress >= 1 {
            self.progressView?.isHidden = true
        }
        handleWebViewWithJS()
    }
    
    /// 页面加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败",error)
        self.progressView?.isHidden = true
    }
    
    /// 页面加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败",error)
        self.progressView?.isHidden = true
    }
    
    /// 接收到服务器跳转请求
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接收到服务器跳转请求")
    }
    
    /// 在收到响应后，决定是否跳转 (如果设置为不允许响应decisionHandler(.cancel)，web内容就不会传过来)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("在收到响应后，决定是否跳转")
        decisionHandler(.allow)
        if webView.canGoBack {
            leftHelpBtn?.isHidden = false
        }else{
            leftHelpBtn?.isHidden = true
        }
    }
    
    /// 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let host = navigationAction.request.url?.host?.lowercased()
        print("在发送请求之前，决定是否跳转,链接===\(host)")
        if navigationAction.navigationType == .linkActivated  {
            print("跳转到App Store等链接==>>")
            UIApplication.shared.openURL(navigationAction.request.url!)
            //本地网页不跳转外链
            decisionHandler(.cancel)
//            webView.load(navigationAction.request)
            
        } else {
            decisionHandler(.allow)
        }
    }
}


// MARK: - WKUIDelegate
extension JHBaseWebViewVC: WKUIDelegate {
    
}

// MARK: - WKScriptMessageHandler JS调用原生
extension JHBaseWebViewVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if iOSToJSName == message.name {
            if "close" == message.body as! String {
                
            }
        }
    }
}
