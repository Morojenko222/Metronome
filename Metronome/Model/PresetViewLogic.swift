//
//  PresetViewLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 19.08.2021.
//

import Foundation
import UIKit

class PresetViewLogic : OnHighStrokeProtocol
{
    private var _presetViewController : PresetsViewController
    var presetInfoArray : [Preset] = []
    var presetCellArray : [PresetCell] = []
    var playingPresetInx = -1

    var presetPlayingPartsArray : [PresetPart] = []
    var countIterator = -1
    var partIterator = -1
    var targetPartCount = -1
    
    init(_ presetVC : PresetsViewController) {
        _presetViewController = presetVC
    }
    
    func updateCellArray ()
    {
        var presetsRowInfo = DataContainer.Instance.presetPosInfoArray
        presetsRowInfo.sort(by: {$0.pos < $1.pos})

        presetInfoArray.removeAll()
        
        for elem in presetsRowInfo {
            let presetNameText = String("Preset \(elem.presetId)")
            let cellElem = Preset(presetId: Int(elem.presetId), presetLabelText: presetNameText)
            presetInfoArray.append(cellElem)
        }
    }
    
    func removePreset(_ removingPresetId : Int, _ indexPath : IndexPath) {
        if let mc = _presetViewController.mainController
        {
            
            for (i, _) in presetInfoArray.enumerated() {
                if (presetInfoArray[i].presetId == removingPresetId)
                {
                    presetInfoArray.remove(at: i)
                    mc.presetEditingLogic.deletePresetById(removingPresetId)
                    mc.presetEditingLogic.deletePresetPosByRow(i)

                    break
                }
            }

            updateCellArray ()
            _presetViewController.tableView.reloadData()
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
        let ml = _presetViewController.mainController!.metronomeLogic
        
        if (playingPresetInx == indexPath.row)
        {
            stopPlaying()
            return
        }
        
        let presetId = presetInfoArray[indexPath.row].presetId
        var partsArray = DataContainer.Instance.getElemsByPresetId(presetId)
        
        partsArray.sort(by: {$0.presetPartId < $1.presetPartId})
        presetPlayingPartsArray.removeAll()
        
        for elem in partsArray {
            let id = Int(elem.presetPartId)
            let bpm = Int(elem.bpm)
            let divider = Int(elem.noteSizeDivider)
            let count = Int(elem.count)
            let size1 = Int(elem.size1)
            let size2 = Int(elem.size2)
            
            let presetPart = PresetPart(id: id, bpm: bpm, size_1: size1, size_2: size2, count: count, noteSizeDivider: divider)
            presetPlayingPartsArray.append(presetPart)
        }
        
        ml.onHighStrokeProtocol = self
        countIterator = 0
        partIterator = 0
        updatePresetPartsParams()
        
        ml.startMetronome()
        playingPresetInx = indexPath.row
        updatePlayPicture()
    }
    
    func updatePresetPartsParams() {
        let ml = _presetViewController.mainController!.metronomeLogic
        let part = presetPlayingPartsArray[partIterator]
        targetPartCount = part.count
        ml.setMetronomeValues(beepTime: part.bpm, noteSizeDivider: part.noteSizeDivider, count: part.count, size1: part.size_1, size2: part.size_2)
    }
    
    func playPartIteration() {
        countIterator += 1
        if (countIterator >= targetPartCount)
        {
            countIterator = 0
            partIterator += 1
            
            if (partIterator >= presetPlayingPartsArray.count)
            {
                stopPlaying()
                return
            }
            
            updatePresetPartsParams()
        }
    }
    
    func stopPlaying() {
        let ml = _presetViewController.mainController!.metronomeLogic
        ml.stopMetronome()
        ml.onHighStrokeProtocol = nil
        playingPresetInx = -1
        partIterator = -1
        countIterator = -1
        targetPartCount = -1
        updatePlayPicture()
    }
    
    func updatePlayPicture() {
        for elem in presetCellArray {
            elem.playBtnImg.image = UIImage(named: "playBtn")
        }
        
        if (playingPresetInx == -1)
        {
            return
        }
        
        presetCellArray[playingPresetInx].playBtnImg.image = UIImage(named: "pauseBtn")
    }
    
    func onHighStroke() {
        playPartIteration()
    }
    
}


