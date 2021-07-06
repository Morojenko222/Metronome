//
//  ViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 23.06.2021.
//

import UIKit
import AVFoundation

class MainController: UIViewController {
    
    //private var player: AVAudioPlayer
    private let metronomeLogic = MetronomeLogic()
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet var minusTenTempoBtn: TempoBtns!
    @IBOutlet var minusOneTempoBtn: TempoBtns!
    @IBOutlet var plusOneTempoBtn: TempoBtns!
    @IBOutlet var plusTenTempoBtn: TempoBtns!
    @IBOutlet var sizeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.text = String(metronomeLogic.INIT_TEMPO)
        initController ()
        setupGestures()
    }
    
    private func initController ()
    {
        minusTenTempoBtn.tempo = -10
        minusOneTempoBtn.tempo = -1
        plusOneTempoBtn.tempo = 1
        plusTenTempoBtn.tempo = 10
    }
    
    private func setupGestures ()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeFirstSize))
        tap.numberOfTapsRequired = 1
        sizeBtn.addGestureRecognizer(tap)
    }
    
    @objc
    private func changeFirstSize()
    {
        guard let sizeVC = storyboard?.instantiateViewController(identifier: "sizeVC") else {
            print("Error, can't create sizeVC")
            return
        }
        
        let sazeVC_Casted = (sizeVC as! SizeViewController)
        sazeVC_Casted.modalPresentationStyle = .custom
        sazeVC_Casted.modalTransitionStyle = .crossDissolve
        sazeVC_Casted.preferredContentSize = CGSize(width: 250, height: 250)
        sazeVC_Casted.metronomeLogic = metronomeLogic
        
        self.present(sizeVC, animated: true)
    }
    
    private func updateTempoView ()
    {
        tempoLabel.text = String(metronomeLogic.beepTime)
    }
    
    @IBAction func onStartBtnPress(_ sender: UIButton)
    {
        metronomeLogic.startMetronomeHandler()
    }
    
    @IBAction func onTempoBtnPress(_ sender: TempoBtns) {
        metronomeLogic.beepTime += sender.tempo
        updateTempoView ()
    }
}
