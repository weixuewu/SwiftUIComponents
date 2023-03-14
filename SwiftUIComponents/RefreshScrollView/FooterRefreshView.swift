//
//  FooterRefreshView.swift
//  Refresh
//
//  Created by xuewu wei on 2023/1/16.
//

import SwiftUI

struct FooterRefreshView: View {
    
    @Binding var footerRefreshing: Bool
    @Binding var noMore: Bool

    var body: some View {
        
        VStack {
            
            if footerRefreshing {
                ResizbaleLottieView(fileName: "loading", isPlaying: $footerRefreshing)
            }
            else if noMore {
                Text("到底啦~")
            }
            else {
                Text("加载更多...\(noMore ? "true": "false")")
            }
        }
        .frame(height: 50)
    }
}

struct FooterRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        FooterRefreshView(footerRefreshing: .constant(true), noMore: .constant(false))
    }
}
