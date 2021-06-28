//
//  ViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 23.06.2021.
//

import UIKit
import AVFoundation

class MainController: UIViewController {

    private var timer = Timer()
    private var beepTime = 60
    private let INIT_TEMPO = 60
    private var needToUpdateTimer = false
    
    //private var player: AVAudioPlayer
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet var minusTenTempoBtn: TempoBtns!
    @IBOutlet var minusOneTempoBtn: TempoBtns!
    @IBOutlet var plusOneTempoBtn: TempoBtns!
    @IBOutlet var plusTenTempoBtn: TempoBtns!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.text = String(INIT_TEMPO)
        initTempoBtns ()
    }
    
    private func initTempoBtns ()
    {
        minusTenTempoBtn.tempo = -10
        minusOneTempoBtn.tempo = -1
        plusOneTempoBtn.tempo = 1
        plusTenTempoBtn.tempo = 10
    }

    private func startMetronome ()
    {
        timer.invalidate()
        let soundUrl = Bundle.main.url(forResource: "met1", withExtension: "wav")
        var player : AVAudioPlayer

        do
        {
            player = try AVAudioPlayer(contentsOf: soundUrl!)
            player.prepareToPlay()
        }
        catch
        {
            print("Error - \(error)")
            return
        }

        UpdateTimer(player)
    }
    
    private func StartTimer (_ player : AVAudioPlayer)
    {
        timer.invalidate()
        player.play()
        UpdateTimer(player)
    }
    
    private func UpdateTimer (_ player : AVAudioPlayer)
    {
        let interval = 60.0 / Double(beepTime)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false, block: { Timer in
            player.currentTime = 0
            
            if (!player.isPlaying)
            {
                player.play()
            }
            self.UpdateTimer(player)
        })
    }
    
    private func updateTempoView ()
    {
        tempoLabel.text = String(beepTime)
    }
    
    @IBAction func onStepperChange(_ sender: UIStepper) {
        let val = Int(sender.value)
        tempoLabel.text = String(val)
        beepTime = val
    }
    
    @IBAction func onStartBtnPress(_ sender: UIButton) {
        startMetronome ()
    }
    
    @IBAction func onTempoBtnPress(_ sender: TempoBtns) {
        beepTime += sender.tempo
        updateTempoView ()
    }
}
