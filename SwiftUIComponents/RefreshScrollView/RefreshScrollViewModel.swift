//
//  RefreshScrollViewModel.swift
//  Refresh
//
//  Created by xuewu wei on 2023/1/17.
//

import SwiftUI

class RefreshScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    
    var headerHeight: CGFloat = 100
    @Published var headerRefreshing: Bool = false
    @Published var isEligible: Bool = false // 属性是标记是否触发下拉刷新：拖动手势松开则触发
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    
    // isEligible 值变化在于拖动手指是否松开
    // 有两种方法，第一种如下面注释方法，是在根视图上添加拖动Pan手势来判断手势状态变化来设置isEligible值,弊端：无法使用于tabView，切换存在手势冲突
    // 第二种：利用Introspect库，.introspectScrollView修饰方法里为scrollview的panGestureRecognizer手势添加如下方法
    @objc
    func scrollViewPanGestureChanged(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .ended {
            // 手势结束
            self.isEligible = true
        }
        
        //MARK: B 方法：不会一直监听头部计算
//        if gesture.state == .cancelled || gesture.state == .ended {
//            print("手势结束")
//            // 最大间距
//            if !headerRefreshing {
//                if scrollOffset > headerHeight {
//                    isEligible = true
//                }else {
//                    isEligible = false
//                }
//            }
//        }
    }
    
//    // 返回YES时,意味着所有相同类型的手势都会得到处理
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//    // 添加手势
//    func addGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
//        panGesture.delegate = self
//
//        rootController().view.addGestureRecognizer(panGesture)
//    }
//
//    // MARK: 离开时删除手势
//    func removeGesture() {
//        rootController().view.gestureRecognizers?.removeAll()
//    }
//
//    // MARK: 找到根控制器
//    func rootController() -> UIViewController {
//        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
//        guard let root = screen.windows.first?.rootViewController else { return .init() }
//        return root
//    }
//
//    @objc
//    func onGestureChange(gesture: UIPanGestureRecognizer) {
//        if gesture.state == .cancelled || gesture.state == .ended {
//            print("手势结束")
//            // 最大间距
//            if !headerRefreshing {
//                if scrollOffset > headerHeight {
//                    isEligible = true
//                }else {
//                    isEligible = false
//                }
//            }
//        }
//    }
}
