//
//  MetronomeLogic.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 06.07.2021.
//

import Foundation
import AVFoundation

class MetronomeLogic
{
    let INIT_TEMPO = 60
    var sizeHighStrokeNum = 4
    var size_2Val = 4
    var highStrokeNum = 4
    
    var timer = Timer()
    var beepTime = 60
    var noteSizeDivider = 1
    
    var needToUpdateTimer = false
    var timerStarted = false
    private var currentStrokeNum = 0
    
    var presetTactsCount = 1
    
    var playerHighSound : AVAudioPlayer!
    var playerLowSound : AVAudioPlayer!
    
    var onHighStrokeProtocol : OnHighStrokeProtocol?
    
    
    private var notFirstHighStroke = false
    
    init() {
        playerHighSound = getAudioPlayer(soundName: "met1", soundExt: "wav")
        playerLowSound = getAudioPlayer(soundName: "met2", soundExt: "wav")
    }
    
    func setMetronomeValues (beepTime bp : Int, noteSizeDivider sd : Int, count cnt : Int, size1 size_1 : Int, size2 size_2 : Int)
    {
        beepTime = bp
        noteSizeDivider = sd
        sizeHighStrokeNum = size_1
        size_2Val = size_2
    }
    
    private func getAudioPlayer (soundName : String, soundExt : String) -> AVAudioPlayer
    {
        let soundUrl = Bundle.main.url(forResource: soundName, withExtension: soundExt)
        
        var player : AVAudioPlayer

        do
        {
            player = try AVAudioPlayer(contentsOf: soundUrl!)
            player.prepareToPlay()
        }
        catch
        {
            fatalError("Error - \(error)")
        }
        
        return player
    }
    
    func startMetronome ()
    {
        timer.invalidate()
        currentStrokeNum = 0
        playSound ()
        timerStarted = true
        updateTimer()
    }
    
    func stopMetronome ()
    {
        timer.invalidate()
        currentStrokeNum = 0
        timerStarted = false
        notFirstHighStroke = false
    }
    
    private func updateTimer ()
    {
        highStrokeNum = sizeHighStrokeNum * noteSizeDivider
        let interval = 60.0 / (Double(beepTime) * Double(noteSizeDivider))
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false, block: { Timer in
            if (!self.timerStarted)
            {
                return
            }
            self.playSound ()
            self.updateTimer()
        })
    }
    
    private func playSound ()
    {
        var currPlayer : AVAudioPlayer
        
        if (currentStrokeNum >= highStrokeNum)
        {
            currentStrokeNum = 0
        }
        
        if (currentStrokeNum == 0)
        {
            currPlayer = playerHighSound
            
            if (notFirstHighStroke)
            {
                onHighStrokeProtocol?.onHighStroke()
            }
            else
            {
                notFirstHighStroke = true
            }
        }
        else
        {
            currPlayer = playerLowSound
        }
        
        currPlayer.currentTime = 0
        if (!currPlayer.isPlaying)
        {
            currPlayer.play()
        }
        
        currentStrokeNum += 1
    }
    
    func startMetronomeHandler ()
    {
        if (!timerStarted)
        {
            startMetronome ()
        }
        else
        {
            stopMetronome()
        }
    }
    
    func changePresetTactsCount(_ change : Int) {
        let summ = presetTactsCount + change
        presetTactsCount = summ > 1 ? summ : 1
    }
}

protocol OnHighStrokeProtocol {
    func onHighStroke()
}
