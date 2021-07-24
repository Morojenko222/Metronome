//
//  PresetCell.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 15.07.2021.
//

import UIKit

class PresetCell: UITableViewCell {

    @IBOutlet var presetNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("Checks")
        // Configure the view for the selected state
    }
 */
    
    @IBAction func deleteBtnOnPress(_ sender: UIButton) {
        print("Delete btn")
    }
}
