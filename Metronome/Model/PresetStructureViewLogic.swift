//
//  PresetStructureViewLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 24.08.2021.
//

import Foundation

class PresetStructureViewLogic
{
    private var _presetStructureController : PresetStructureController
    var presetPartInfoArray : [PresetPart] = []
    
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
}
