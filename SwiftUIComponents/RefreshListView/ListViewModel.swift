//
//  ListViewModel.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/2/2.
//

import SwiftUI


class ListViewModel: ObservableObject {
    
    @Published var currentTab: Int = 0

    @Published var lists: [String] = []
    @Published var footerRefreshing: Bool = false
    @Published var headerRefreshing: Bool = false
    @Published var noMore: Bool = false
    
    @Published var lists2: [String] = []
    @Published var headerRefreshing2: Bool = false
    
    private var originalStr = "东风夜放花千树。更吹落、星如雨。宝马雕车香满路。凤箫声动，玉壶光转，一夜鱼龙舞。蛾儿雪柳黄金缕。笑语盈盈暗香去。众里寻他千百度。蓦然回首，那人却在，灯火阑珊处。"
}

extension ListViewModel {
    
    func getDatas() {
        
        var arr: [String] = []
        for _ in 0..<20 {
            
            let len = arc4random() % 20
            let num = Int(len)
            var str: String = ""
            for _ in 0..<num {
                let rand = originalStr.randomElement()!
                str = str.appending(String(rand).trimmingCharacters(in: .whitespacesAndNewlines))
            }
            if !str.isEmpty {
                arr.append(str)
            }
        }
        self.lists = arr
        self.noMore = false
    }
    
    func loadMore() {
        print("加载更多")
        var arr: [String] = []
        for _ in 0..<10 {
            
            let len = arc4random() % 20
            let num = Int(len)
            var str: String = ""
            for _ in 0..<num {
                let rand = originalStr.randomElement()!
                str = str.appending(String(rand).trimmingCharacters(in: .whitespacesAndNewlines))
            }
            if !str.isEmpty {
                arr.append(str)
            }
        }
        self.lists += arr
        if self.lists.count > 60 {
            self.noMore = true
        }
    }
    
    
    func getDatas2() {
        
        var arr: [String] = []
        for _ in 0..<20 {
            
            let len = arc4random() % 20
            let num = Int(len)
            var str: String = ""
            for _ in 0..<num {
                let rand = originalStr.randomElement()!
                str = str.appending(String(rand).trimmingCharacters(in: .whitespacesAndNewlines))
            }
            if !str.isEmpty {
                arr.append(str)
            }
        }
        self.lists2 = arr
    }
}
