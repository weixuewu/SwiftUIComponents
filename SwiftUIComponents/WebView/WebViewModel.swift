//
//  WebViewModel.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/2/2.
//

import SwiftUI
import WebKit

class WebViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    
    // @Published 修饰，用于外层SwiftUIWebView 里返回判断 self.viewModel.webView.canGoBack 和 self.viewModel.webView.goBack() 事件调用
    // 普通属性则无法调用 canGoBack goBack
    @Published var webView: WKWebView
    let url: String
    let title: String
    var line: UIView
    
    init(url: String, title: String = "") {
        self.url = url
        self.title = title
        self.webView = WKWebView()
        // 进度条
        self.line = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.line.backgroundColor = .blue
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let web = object as? WKWebView, web == self.webView, keyPath == #keyPath(WKWebView.estimatedProgress) {
            
            self.line.frame.size.width = (web.estimatedProgress) * web.frame.size.width
        }
    }
}

// MARK: WKNavigationDelegate
extension WebViewModel {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.line.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.line.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.line.removeFromSuperview()
    }
}
