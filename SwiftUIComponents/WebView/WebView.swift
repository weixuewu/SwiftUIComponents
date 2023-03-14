//
//  WebView.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/2/2.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    var viewModel: WebViewModel

    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> WKWebView {
        return self.viewModel.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

        guard let url = URL(string: self.viewModel.url) else { return }
        let request = URLRequest(url: url)
        uiView.load(request)
        
        // 添加代理
        uiView.navigationDelegate = self.viewModel
        
        // 添加进度条
        uiView.addSubview(self.viewModel.line)
        
        // 监听加载进度
        uiView.addObserver(self.viewModel, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(viewModel: WebViewModel(url: "https://www.baidu.com"))
    }
}
