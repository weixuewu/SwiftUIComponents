//
//  RefreshScrollView.swift
//  Refresh
//
//  Created by xuewu wei on 2023/1/17.
//

import SwiftUI
import Introspect

struct RefreshScrollView<Content>: View where Content: View {
    
    var content: () -> Content
    var showsIndicators: Bool
    var lottieFileName: String
    var headerHeight: CGFloat
    var onRefresh: () async -> Void
    var onLoadMore: (() async -> Void)?
    @Binding var headerRefreshing: Bool
    @Binding var footerRefreshing: Bool
    @Binding var noMore: Bool
    @StateObject var viewModel = RefreshScrollViewModel()
    
    init(@ViewBuilder content: @escaping () -> Content, showsIndicators: Bool = true, lottieFileName: String = "loading", headerHeight: CGFloat = 100, headerRefreshing: Binding<Bool>, footerRefreshing: Binding<Bool> = .constant(false), noMore: Binding<Bool> = .constant(false), onRefresh: @escaping () -> Void, onLoadMore: ( () -> Void)? = nil) {
        self.content = content
        self.showsIndicators = showsIndicators
        self.lottieFileName = lottieFileName
        self.headerHeight = headerHeight
        self._headerRefreshing = headerRefreshing
        self._footerRefreshing = footerRefreshing
        self._noMore = noMore
        self.onRefresh = onRefresh
        self.onLoadMore = onLoadMore
    }
    
    var body: some View {
        
        GeometryReader { reader in
            
            ScrollView(showsIndicators: showsIndicators) {

                LazyVStack {

                    ResizbaleLottieView(fileName: lottieFileName, isPlaying: $headerRefreshing)
                        .scaleEffect(viewModel.isEligible ? 1 : 0.001)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isEligible)
                        .overlay(
                            // 下拉箭头 文字
                            VStack {
                                Image(systemName: "arrow.down")
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                                    .rotationEffect(.init(degrees: viewModel.progress * 180))
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())

                                Text(viewModel.progress < 1 ? "下拉刷新" : "释放刷新")
                                    .font(.caption.bold())
                                    .foregroundColor(.blue)
                            }
                                .opacity(viewModel.isEligible ? 0 : 1)
                                .animation(.easeInOut(duration: 0.25), value: viewModel.isEligible)
                        )
                        .frame(height: viewModel.progress * headerHeight)
                        .opacity(viewModel.progress)
                        .offset(y: viewModel.isEligible ? -(viewModel.contentOffset < 0 ? 0 : viewModel.contentOffset) : -(viewModel.scrollOffset < 0 ? 0 : viewModel.scrollOffset))
                        .id("header")
                    //#warning("一直执行")
                        .anchorPreference(key: HeaderPreferenceKey.self, value: .bounds) { anchor in
                            [HeaderPreferenceData(bouds: anchor)]
                        }
                        .backgroundPreferenceValue(HeaderPreferenceKey.self) { preferences in
                            GeometryReader { proxy in
                                pullRefresh(proxy, preferences: preferences)
                            }
                        }

                    content()


                    if let _ = self.onLoadMore {
                        FooterRefreshView(footerRefreshing: $footerRefreshing, noMore: $noMore)
                        .id("footer")
                        .anchorPreference(key: FooterPreferenceKey.self, value: .bounds) { [FooterPreferenceData(bounds: $0)]
                        }
                        .backgroundPreferenceValue(FooterPreferenceKey.self) { preferences in
                            GeometryReader { proxy in
                                loadMore(proxy, preferences: preferences)
                            }
                        }
                    }
                }
//                .anchorPreference(key: RefreshableScrollViewKey.PreKey.self, value: .bounds) {
//                    guard !headerRefreshing || !footerRefreshing else { return nil }
//                    let frame = reader[$0]
//                    let top = frame.minY
//                    let bottom = frame.maxY - reader.size.height
//                    return RefreshableScrollViewKey.PreData(top: top, bottom: bottom)
//                }
            }
            .introspectScrollView(customize: { scrollView in
                // scrollview 拖动手势添加触发事件，在事件中判断手势是否结束，结束则触发刷新动画
                scrollView.panGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.scrollViewPanGestureChanged(gesture:)))
            })
            .coordinateSpace(name: "ScrollRefresh")
            // 使用根视图添加拖动手势，在tabView切换时会手势冲突，导致下拉刷新不起作用
            // 故用上面的introspectScrollView方法,加一个手势的方法来处理刷新逻辑
//            .onAppear {
//                viewModel.addGesture()
//            }
//            .onDisappear {
//                viewModel.removeGesture()
//            }
            .onChange(of: headerRefreshing) { newValue in
                
                if !newValue {
                    // 下拉刷新结束
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.progress = 0
                        viewModel.isEligible = false
                        viewModel.contentOffset = 0
                    }
                }else {
                    // 用于非手动下拉刷新，代码设置 headerRefreshing = true 自动执行刷新
                    Task {
                        await onRefresh()
                    }
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.progress = 1
                        viewModel.isEligible = true
                        viewModel.scrollOffset = headerHeight
                    }
                }
            }
//            .onPreferenceChange(RefreshableScrollViewKey.PreKey.self) { value in
//                guard let data = value, !headerRefreshing || !footerRefreshing else { return }
//                if data.position == .top {
//                    refresh(data: data)
//                }else {
//                    loadMore(data: data)
//                }
//            }
        }
        
    }
    
//    private func refresh(data: RefreshableScrollViewKey.PreData) {
//        guard data.isAtTop else { return }
//
//        let offset: CGFloat = data.top
//        // 存储offset
//        viewModel.contentOffset = offset
//
//        // 手势下拉时各个参数值
//        if !viewModel.isEligible{
//            var progress = offset / headerHeight
//            progress = progress < 0 ? 0 : progress
//            progress = progress > 1 ? 1 : progress
//            viewModel.progress = progress
//            viewModel.scrollOffset = offset
//        }
//
//        let y = viewModel.isEligible ? -(viewModel.contentOffset < 0 ? 0 : viewModel.contentOffset) : -(viewModel.scrollOffset < 0 ? 0 : viewModel.scrollOffset)
//        print("下拉刷新", offset, y, viewModel.progress, viewModel.isEligible)
//
//        // 触发刷新：isEligible此值在手势放开时赋值新的值，详见ViewModel里
//        if viewModel.isEligible && !headerRefreshing && offset >= headerHeight {
//            headerRefreshing = true
//            Task {
//                await onRefresh()
//            }
//        }
//    }
//
//    private func loadMore(data: RefreshableScrollViewKey.PreData) {
//        print("加载更多")
//
//        guard data.isAtBottom, !noMore, !footerRefreshing, let onLoadMore = onLoadMore else { return }
//        footerRefreshing = true
//        Task {
//            await onLoadMore()
//        }
//    }
    
    func loadMore(_ proxy: GeometryProxy, preferences: [FooterPreferenceData]) -> some View  {
        print("加载更多")
        DispatchQueue.main.async {
            if let rect = preferences.last {
                let bounds = proxy[rect.bounds]
                let frame = proxy.frame(in: .named("ScrollRefresh"))
                if !noMore, !footerRefreshing, frame.height - bounds.maxY < bounds.height, frame.height != 0 {
                    footerRefreshing = true
                    if let loadMore = onLoadMore {
                        Task {
                            await loadMore()
                        }
                    }
                }
            }
        }
        
        return Color.clear
    }
    
    func pullRefresh(_ proxy: GeometryProxy, preferences: [HeaderPreferenceData]) -> some View  {
        print("下拉刷新")
        DispatchQueue.main.async {
            
            if let item = preferences.last {

                let frame = proxy.frame(in: .named("ScrollRefresh"))
                let offset: CGFloat = frame.minY
                // 存储offset
                viewModel.contentOffset = offset

                // 手势下拉时各个参数值
                if !viewModel.isEligible {
                    var progress = offset / headerHeight
                    progress = progress < 0 ? 0 : progress
                    progress = progress > 1 ? 1 : progress
                    viewModel.progress = progress
                    viewModel.scrollOffset = offset
                }

                // 触发刷新：isEligible此值在手势放开时赋值新的值，详见ViewModel里
                if viewModel.isEligible && !headerRefreshing && offset >= headerHeight {
                    Task {
                        headerRefreshing = true
                        await onRefresh()
                    }
                    // haptic feedback 震动反馈
                    // UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        // 返回一个透明背景，无效果，仅用于在视图更新时触发上面的逻辑
        return Color.clear
    }
}

struct RefreshScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshScrollView(content: {
            
        }, headerRefreshing: .constant(false)) {
            
        }
    }
}
