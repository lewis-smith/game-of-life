//
//  ControlsView.swift
//  Game of Life
//
//  Created by Lewis Smith on 02/08/2021.
//

import SwiftUI

struct ControlsView: View {
    
    @ObservedObject var board: Board
    @ObservedObject var model: PlaybackModel
    
    var body: some View {
        
        HStack {
            Button(action: {
                board.reset(toRandom: false)
            }, label: {
                Image(systemName: "plus")
                Text("Empty Board")
            })
            
            Button(action: {
                board.reset(toRandom: true)
            }, label: {
                Image(systemName: "shuffle")
                Text("Randomise Board")
            })
            
            Spacer()
            
            Button(action: {
                board.nextGeneration()
            }, label: {
                Image(systemName: "forward.end")
                Text("Next")
            })
            .disabled(model.playbackMode == .unplayable)
            
            Button(action: {
                switch model.playbackMode {
                case .paused:       model.playbackMode = .playing
                case .playing:      model.playbackMode = .paused
                case .unplayable:   break
                }
            }, label: {
                Image(systemName: model.playbackMode.imageName)
                Text(model.playbackMode.buttonText)
            })
                .disabled(model.playbackMode == .unplayable)
            
        }
        .padding(4)
    }
}

extension PlaybackMode {
    var buttonText: String {
        switch self {
        case .paused:
             return "Play"
        case .playing:
            return "Pause"
        case .unplayable:
            return "Unplayable"
        }
    }
    
    var imageName: String {
        switch self {
        case .paused:
            return "play.fill"
        case .playing:
            return "playpause.fill"
        case .unplayable:
            return "play.fill"
        }
    }
        
}

//struct ControlsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlsView(board: Board.random(size: CGSize(width: 5, height: 5)))
//    }
//}
