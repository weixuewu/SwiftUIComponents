//
//  ContentView.swift
//  SwiftUIComponents
//
//  Created by xuewu wei on 2023/2/2.
//

import SwiftUI

struct ContentView: View {
    
    @State var playing: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                                
                NavigationLink {
                    SwiftUIWebView(url: "https://www.baidu.com", title: "导航标题")
                } label: {
                    Text("网页浏览")
                }

                NavigationLink {
                    ListView()
                } label: {
                    Text("刷新")
                }
                
                EasyMenu {
                    Group {
                        HStack {
                            Image(systemName: "sun.min.fill")
                                .foregroundColor(Color(.secondaryLabel))
                            Slider(value: .constant(0.5))
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        .padding(.horizontal)
                        .frame(height: 50)
                    }
                                
                    Divider()
                                    
                    Toggle("Show Translate", isOn: .constant(true))
                        .padding(.horizontal)
                        .frame(height: 54.0)
                } label: {
                    Image(systemName: "textformat.size")
                }
                .padding(15)
                

                HStack {
                    
                    Spacer()

                    Button {
                        playing.toggle()
                        // 支持 aac 格式
                        let path = "https://www.fesliyanstudios.com/musicfiles/2019-04-23_-_Trusted_Advertising_-_www.fesliyanstudios.com/15SecVersion2019-04-23_-_Trusted_Advertising_-_www.fesliyanstudios.com.mp3"
                        AudioPlayerManager.shared.play(path: path) {
                            self.playing = false
                        }
                        
                    } label: {
                        Text("播放音频")
                            .foregroundColor(.white)
                            .padding(12)
                    }
                    
                    Spacer()

                    ResizbaleLottieView(fileName: "voice", isPlaying: $playing)
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(180))
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .background(Color.blue)
                
                Button("根控制器弹窗") {
                    RootViewController.shared.present {
                        PresentTestView()
                    }
                }
                
                Spacer()
            }
            .navigationTitle(Text("组件"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
