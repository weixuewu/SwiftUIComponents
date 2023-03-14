//
//  ListView.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/2/2.
//

import SwiftUI

struct ListView: View {
    
    @StateObject var viewModel = ListViewModel()
    
    var body: some View {
        
        VStack {
            
            Button {
                viewModel.headerRefreshing.toggle()
            } label: {
                Text("show")
            }

            TabView(selection: $viewModel.currentTab) {
                
                RefreshScrollView(content: {
                    ForEach(viewModel.lists, id: \.self) { item in

                        Text(item)
                            .padding(12)

                        Divider()
                    }
                }, headerRefreshing: $viewModel.headerRefreshing, footerRefreshing: $viewModel.footerRefreshing, noMore: $viewModel.noMore, onRefresh: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        viewModel.getDatas()
                        viewModel.headerRefreshing = false
                    }
                }, onLoadMore: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        viewModel.loadMore()
                        viewModel.footerRefreshing = false
                    }
                })
                .tag(0)
                
                RefreshScrollView(content: {
                    ForEach(viewModel.lists2, id: \.self) { item in

                        Text(item)
                            .padding(12)

                        Divider()
                    }
                }, headerRefreshing: $viewModel.headerRefreshing2, onRefresh: {
                    viewModel.getDatas2()
                    viewModel.headerRefreshing2 = false
                })
                .tag(1)
  
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
        }
        .onAppear {
            viewModel.getDatas()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
