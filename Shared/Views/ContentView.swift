//
//  ContentView.swift
//  Shared
//
//  Created by Lewis Smith on 02/08/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var board: Board
    @ObservedObject var playback: PlaybackModel
    
    var body: some View {
        VStack {
            BoardView(board: board)
            ControlsView(board: board, model: playback)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
