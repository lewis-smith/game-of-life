//
//  Game_of_LifeApp.swift
//  Shared
//
//  Created by Lewis Smith on 02/08/2021.
//

import SwiftUI

@main
struct Game_of_LifeApp: App {
    
    @StateObject var board = Board(emptySize: CGSize(width: 20, height: 20))
    @StateObject var playback = PlaybackModel()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some Scene {
        WindowGroup {
            ContentView(board: board, playback: playback)
                .onReceive(timer) { input in
                    switch playback.playbackMode {
                    case .playing:
                        let previousBoard = board.debugDescription
                        board.nextGeneration()
                        let newBoard = board.debugDescription
                        if previousBoard == newBoard {
                            playback.playbackMode = .unplayable
                        }
                    case .paused, .unplayable:
                        break
                    }
                }
        }
    }
}
