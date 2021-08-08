//
//  PresetEditingLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 01.08.2021.
//

import Foundation

class PresetEditingLogic {

    func updatePickedPresetPart (metronomeLogic : MetronomeLogic)
    {
        let newPresetPart = PresetPart(bpm: metronomeLogic.beepTime, size_1: metronomeLogic.sizeHighStrokeNum, size_2: 4, count: metronomeLogic.presetTactsCount, noteSizeDivider: metronomeLogic.noteSizeDivider)
        let data = DataContainer.Instance
        
        if (data.pickedPresetStructNum >= data.currentPreset.presetParts.count)
        {
            data.currentPreset.presetParts.append(newPresetPart)
        }
        else
        {
            data.currentPresetStruct = newPresetPart
        }
    }
}
