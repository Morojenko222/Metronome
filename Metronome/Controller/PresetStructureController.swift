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
        let presetStructs = DataContainer.Instance.getElemsOfCurrentPreset()
        DataContainer.Instance.pickedPresetStructId = presetStructs.count
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
                mainVCSafe.modalPresentationStyle = .fullScreen
            }
        }
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        mainController?.coreDataLogic.loadData()
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataContainer.Instance.getElemsOfCurrentPreset().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetStructureCell", for: indexPath) as! PresetStructureCell
        var presetStructsElems = DataContainer.Instance.getElemsOfCurrentPreset()
        presetStructsElems.sort(by: { $0.presetPartId < $1.presetPartId })
        
        let bpm = presetStructsElems[indexPath.row].bpm
        let count = presetStructsElems[indexPath.row].count
        let size = presetStructsElems[indexPath.row].size1
        
        cell.bpmLabel.text = "BMM: \(bpm)"
        cell.countLabel.text = "Count: \(count)"
        cell.sizeLabel.text = "Size: \(size)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DataContainer.Instance.pickedPresetStructId = indexPath.row
        goToSetPresetPartScreen()
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
