//
//  SwiftUIWebView.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/2/2.
//

import SwiftUI

struct SwiftUIWebView: View {
    
    let url: String
    let title: String
    @StateObject var viewModel: WebViewModel
    
    init(url: String, title: String) {
        self.url = url
        self.title = title
        
        self._viewModel = StateObject(wrappedValue: WebViewModel(url: url, title: title))
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        WebView(viewModel: viewModel)
            .navigationTitle(Text(viewModel.title))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                
                Button {

                    if self.viewModel.webView.canGoBack {
                        self.viewModel.webView.goBack()
                    }else {
                        self.presentationMode.wrappedValue.dismiss()
                    }

                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 25, alignment: .leading)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct SwiftUIWebView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIWebView(url: "https://www.baidu.com", title: "标题")
    }
}
