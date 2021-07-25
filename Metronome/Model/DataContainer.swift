//
//  DataContainer.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 05.07.2021.
//

import Foundation

struct DataContainer {
    
    static var Instance = DataContainer()
    
    var presets : [Preset] = []
}
