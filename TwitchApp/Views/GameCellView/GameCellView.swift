//
//  GameCellView.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import SwiftUI
import Kingfisher

struct GameCellView: View {
    
    @ObservedObject var viewModel: GameCellViewModel
    
    var body: some View {
        
        HStack {
            
            if let imageURL = viewModel.imageURL {
                
                KFImage.url(URL(string: imageURL))
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(width: 100, height: 130)
            }
            
            Text(viewModel.name)
                .font(.headline)
            
            Spacer(minLength: 0)
        }
        .background {
            Color.white.opacity(0.001)
        }
        .onTapGesture {
            viewModel.action(viewModel.id)
        }
    }
}

struct GameCellView_Previews: PreviewProvider {
    static var previews: some View {
        GameCellView(viewModel: .init(id: UUID().uuidString, name: "Grand Theft Auto V", imageURL: "ExampleGTA5", action: { _ in }))
    }
}
