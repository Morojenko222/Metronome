//
//  PresetStructureController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 21.07.2021.
//

import UIKit

class PresetStructureController: UITableViewController {

    var mainController : MainController?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PresetStructureCell", bundle: nil), forCellReuseIdentifier: "presetStructureCell")
        tableView.rowHeight = 60.0
        popoverPresentationController?.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddPresetPartBtnPress))
    }
    
    @objc func onAddPresetPartBtnPress()
    {
        if let mc = mainController
        {
            mc.presetEditingLogic.pickedPresetStructNum = mc.presetEditingLogic.currentPreset.presetParts.count
            goToSetPresetPartScreen()
        }
        
        goToSetPresetPartScreen()
    }
    
    func goToSetPresetPartScreen ()
    {
        performSegue(withIdentifier: "toEditPresetStruct", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditPresetStruct" {
            if let mainVCSafe = segue.destination as? MainController {
                mainVCSafe.inPresetMode = true
                mainVCSafe.modalPresentationStyle = .popover
            }
        }
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let MC = mainController else {
            print("ERROR - Main controller hasn't been initialized")
            return 0
        }
        
        return MC.presetEditingLogic.currentPreset.presetParts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetStructureCell", for: indexPath)
        //cell.textLabel?.text = String(activeData[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let mc = mainController
        {
            mc.presetEditingLogic.pickedPresetStructNum = indexPath.row
            goToSetPresetPartScreen()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PresetStructureController : UIPopoverPresentationControllerDelegate
{
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController)
    {
        print("CHECK!!!")
    }
}
