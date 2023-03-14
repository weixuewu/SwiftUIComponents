//
//  ResizbaleLottieView.swift
//  Refresh
//
//  Created by xuewu wei on 2023/1/17.
//

import SwiftUI
import Lottie

struct ResizbaleLottieView: UIViewRepresentable {
    
    var fileName: String
    @Binding var isPlaying: Bool
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
        addLottieView(view: view)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        uiView.subviews.forEach { view in
            if let lottieView = view as? LottieAnimationView {
                if isPlaying {
                    lottieView.play()
                }else {
                    lottieView.stop()
                }
            }
        }
    }
    
    func addLottieView(view to: UIView) {
        let lottieView = LottieAnimationView(name: fileName)
        lottieView.backgroundColor = .clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.loopMode = .loop
        let constraint = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor)
        ]
        to.addSubview(lottieView)
        // 添加约束
        to.addConstraints(constraint)
    }
}
