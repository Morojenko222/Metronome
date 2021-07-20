//
//  PresetStructureCell.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 19.07.2021.
//

import UIKit

class PresetStructureCell: UITableViewCell {

    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
