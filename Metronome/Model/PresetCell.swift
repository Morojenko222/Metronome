//
//  PresetCell.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 15.07.2021.
//

import UIKit

class PresetCell: UITableViewCell {

    @IBOutlet var presetNameLabel: UILabel!
    @IBOutlet var playBtnImg: UIImageView!
    
    var indexPath : IndexPath?
    var presetId = -1
    var presetViewController : PresetsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteBtnOnPress(_ sender: UIButton) {
        if let presController = presetViewController, let safeIndexPath = indexPath
        {
            presController.presetViewLogic!.removePreset(presetId, safeIndexPath)
        }
    }
    
    @IBAction func playBtnOnPress(_ sender: UIButton) {
        if let presController = presetViewController, let ip = indexPath
        {
            presController.playBtnHandler(ip)
        }
    }
}
