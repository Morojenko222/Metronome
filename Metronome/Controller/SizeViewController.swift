//
//  sizeViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 30.06.2021.
//

import UIKit

class SizeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var sizeTableView: UITableView!
    
    var activeData = [Int]()
    var metronomeLogic : MetronomeLogic?
    private let dataContainer = DataContainer.Instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setupGestures ()
    }
    
    private func setupGestures ()
    {
        // Dismiss on background press
        let tap = UITapGestureRecognizer(target: self, action: #selector(goBack))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false;
        tap.delegate = self
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc private func goBack ()
    {
        dismiss(animated: true)
    }
}

extension SizeViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        metronomeLogic?.highStrokeNum = activeData[indexPath.row]
        dismiss(animated: true)
    }
}

extension SizeViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SizeCell", for: indexPath)
        cell.textLabel?.text = String(activeData[indexPath.row])
        return cell
    }
}

extension SizeViewController : UIGestureRecognizerDelegate
{
    //For blocking goBack() when tapping on size table
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == backgroundView
    }
}
