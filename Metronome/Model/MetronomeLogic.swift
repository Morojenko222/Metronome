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
    var highStrokeNum = 4
    
    var timer = Timer()
    var beepTime = 60
    let INIT_TEMPO = 60
    var needToUpdateTimer = false
    var timerStarted = false
    var currentStrokeNum = 0
    
    var playerHighSound : AVAudioPlayer!
    var playerLowSound : AVAudioPlayer!
    
    init() {
        playerHighSound = getAudioPlayer(soundName: "met1", soundExt: "wav")
        playerLowSound = getAudioPlayer(soundName: "met2", soundExt: "wav")
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
    
    private func startMetronome ()
    {
        timer.invalidate()
        playSound ()
        updateTimer()
        timerStarted = true
    }
    
    private func stopMetronome ()
    {
        timer.invalidate()
        currentStrokeNum = 0
        timerStarted = false
    }
    
    private func updateTimer ()
    {
        let interval = 60.0 / Double(beepTime)
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false, block: { Timer in
            self.playSound ()
            self.updateTimer()
        })
    }
    
    private func playSound ()
    {
        var currPlayer : AVAudioPlayer
        
        if (currentStrokeNum == highStrokeNum)
        {
            currentStrokeNum = 0
        }
        
        if (currentStrokeNum == 0)
        {
            currPlayer = playerHighSound
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
}
