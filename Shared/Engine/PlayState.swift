//
//  PlayState.swift
//  PlayState
//
//  Created by Lewis Smith on 02/08/2021.
//

import Combine
import CoreGraphics

enum PlaybackMode {
    case paused
    case playing
    case unplayable
}

class PlaybackModel: ObservableObject {
    
    @Published var playbackMode = PlaybackMode.paused
    
}
