//
//  RefreshScrollViewKeys.swift
//  Refresh
//
//  Created by xuewu wei on 2023/1/17.
//

import SwiftUI

struct FooterPreferenceData: Equatable {
    var bounds: Anchor<CGRect>
}
struct FooterPreferenceKey: PreferenceKey {
    
    typealias Value = [FooterPreferenceData]

    static var defaultValue: Value = []
    
    static func reduce(value: inout [FooterPreferenceData], nextValue: () -> [FooterPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}




struct HeaderPreferenceData {
    let bouds: Anchor<CGRect>
}
struct HeaderPreferenceKey: PreferenceKey {
    
    typealias Value = [HeaderPreferenceData]
    
    static var defaultValue: Value = []
    
    static func reduce(value: inout [HeaderPreferenceData], nextValue: () -> [HeaderPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}


struct RefreshableScrollViewKey {
    
    enum Direction {
        case top, bottom
    }
    
    struct PreData: Equatable {
        
        static var fraction = CGFloat(0.001)
        
        let top: CGFloat
        let bottom: CGFloat
        
        private var absTop: CGFloat { abs(min(0, top)) }
        private var absBottom: CGFloat { abs(max(0, bottom)) }
        
        var position: Direction {
            return absTop > absBottom ? .bottom : .top
        }
        
        var isAtTop: Bool {
            return top > PreData.fraction
        }
        
        var isAtBottom: Bool {
            let percentage = bottom / abs(top - bottom)
            return percentage < PreData.fraction
        }
    }
    
    struct PreKey: PreferenceKey {
        static var defaultValue: PreData? = nil
        static func reduce(value: inout PreData?, nextValue: () -> PreData?) {}
    }
}
