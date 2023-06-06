//
//  MainView.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import SwiftUI


struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                ForEach(viewModel.items) { item in
                    GameCellView(viewModel: item)
                        .onAppear {
                            viewModel.loadMoreContent(currentGame: item)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init(model: .emptyMock))
    }
}
