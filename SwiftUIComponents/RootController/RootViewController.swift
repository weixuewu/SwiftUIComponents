//
//  RootViewController.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/3/14.
//

import SwiftUI

class RootViewController: UIViewController {
    
    static let shared = RootViewController()
    
    var rootController: UIViewController? {
        get {
            let scences = UIApplication.shared.connectedScenes
            let windowScence = scences.first as? UIWindowScene
            let window = windowScence?.windows.first
            let viewController = window?.rootViewController
            return viewController
        }
    }
}

extension RootViewController {
    
    func present<Content: View>(@ViewBuilder content: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = .overCurrentContext
        toPresent.modalTransitionStyle = .crossDissolve
        toPresent.view.backgroundColor = .clear
        toPresent.rootView = AnyView(content())
        
        rootController?.present(toPresent, animated: false)
    }
    
    func dismiss(animated: Bool = true) {
        rootController?.dismiss(animated: animated)
    }
}

