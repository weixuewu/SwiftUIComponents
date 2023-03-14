//
//  PresentTestView.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/3/14.
//

import SwiftUI

struct PresentTestView: View {
    
    @State var isShow: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(0.3).ignoresSafeArea().onTapGesture {
                
                // 内容先消失
                withAnimation {
                    isShow = false
                }
                
                // 随后页面消失
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    RootViewController.shared.dismiss(animated: true)
                }
            }
            
            Text("我是根控制器上的弹窗")
                .font(.system(.title))
                .padding(15)
                .frame(width: 300, height: 200)
                .foregroundColor(.black)
                .background(Color.yellow)
                .cornerRadius(10)
                .scaleEffect(isShow ? 1 : 0)
                .rotationEffect(.degrees(isShow ? 360 : 0))
                .opacity(isShow ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.2)) {
                isShow = true
            }
        }
    }
}

struct PresentTestView_Previews: PreviewProvider {
    static var previews: some View {
        PresentTestView()
    }
}
