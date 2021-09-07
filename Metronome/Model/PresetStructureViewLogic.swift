//
//  PresetStructureViewLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 24.08.2021.
//

import Foundation
import UIKit

class PresetStructureViewLogic
{
    private var _presetStructureController : PresetStructureController
    var presetPartInfoArray : [PresetPart] = []
    var presetPartCellArray : [PresetStructureCell] = []
    var playingPartInx = -1
    
    init(_ presetStructVC : PresetStructureController) {
        _presetStructureController = presetStructVC
    }
    
    func updateCellArray ()
    {
        presetPartInfoArray = DataContainer.Instance.getElemsOfCurrentPreset()
        presetPartInfoArray.sort(by: {$0.id < $1.id})
    }
    
    func removePresetPart(_ removingPresetId : Int, _ indexPath : IndexPath) {
        if let mc = _presetStructureController.mainController
        {
            
            for (i, _) in presetPartInfoArray.enumerated() {
                if (presetPartInfoArray[i].id == removingPresetId)
                {
                    presetPartInfoArray.remove(at: i)
                    mc.presetEditingLogic.deletePresetPartById(removingPresetId)
                    break
                }
            }

            stopPlaying()
            updateCellArray ()
            _presetStructureController.tableView.reloadData()
        }
    }
    
    func getFreeIdForNewPreset () -> Int
    {
        let idsSet = DataContainer.Instance.getPresetsIdsSet()
        let sortedSet = idsSet.sorted()
        let lastId = sortedSet.last
        
        if let safeLastId = lastId
        {
            for i in 0...safeLastId
            {
                if (!sortedSet.contains(i))
                {
                    return i
                }
            }
            
            return safeLastId + 1
        }
        else
        {
            return 0
        }
    }
    
    func playPart (_ indexPath : IndexPath)
    {
        let ml = _presetStructureController.mainController!.metronomeLogic
        
        if (playingPartInx == indexPath.row)
        {
            stopPlaying()
            return
        }
        
        let presetElem = presetPartInfoArray[indexPath.row]
        let bpm = presetElem.bpm
        let divider = presetElem.noteSizeDivider
        let count = presetElem.count
        let size1 = presetElem.size_1
        let size2 = presetElem.size_2
        
        ml.setMetronomeValues(beepTime: bpm, noteSizeDivider: divider, count: count, size1: size1, size2: size2)
        ml.startMetronome()
        playingPartInx = indexPath.row
        updatePlayPicture()
        
    }
    
    func stopPlaying() {
        let ml = _presetStructureController.mainController!.metronomeLogic
        ml.stopMetronome()
        playingPartInx = -1
        updatePlayPicture()
    }
    
    func updatePlayPicture() {
        for elem in presetPartCellArray {
            elem.playBtnBack.image = UIImage(named: "playBtn")
        }
        
        if (playingPartInx == -1)
        {
            return
        }
        
        presetPartCellArray[playingPartInx].playBtnBack.image = UIImage(named: "pauseBtn")
    }
}
