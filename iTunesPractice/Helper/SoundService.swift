//
//  SoundService.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 28.05.22.
//

import Foundation
import AVFoundation

final class SoundService {
    
    enum Sound {
        case removeFavourite
    }
    
    func play(_ sound: Sound) {
        switch sound {
        case .removeFavourite:
            AudioServicesPlaySystemSound(1050)
        }
    }
}
