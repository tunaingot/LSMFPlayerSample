//
//  ViewController.swift
//  LSMFPlayerSample
//
//  Created by 大川 博 on 2025/04/29.
//

import Cocoa
import SMFPlayerFramework

class ViewController: NSViewController {
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var rewindButton: NSButton!
    @IBOutlet weak var playTimeLabel: NSTextField!
    @IBOutlet weak var remainTimeLabel: NSTextField!
    
    private var midiDevice: LMIDI?
    private var smfPlayer: LSMFPlayer?
    
    /*==========================================================================
     
     =========================================================================*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(LMIDI.sourceNames)
        print(LMIDI.destinationNames)
        
        midiDevice = LMIDI(sourceName: nil, destinationName: LMIDI.destinationNames.first!)
        smfPlayer = LSMFPlayer(filePath: Bundle.main.resourcePath! + "/Moonlight-2.mid")
        smfPlayer?.MIDIDevice = midiDevice
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendEvent(_:)), name: LSMFPlayer.messageDidSendNotification, object: smfPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playbacktimeUpdate(_:)), name: LSMFPlayer.playbackTimeUpdatedNotification, object: smfPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(fileAnalyzeFinish(_:)), name: LSMFPlayer.fileAnalyzeFinishNotification, object: smfPlayer)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

//MARK: - action
/*==============================================================================
 
 =============================================================================*/
extension ViewController {
    @IBAction func playButton(_ sender: Any) {
        smfPlayer?.play()
    }
    
    @IBAction func pauseButton(_ sender: Any) {
        smfPlayer?.pause()
    }
    @IBAction func rewindButton(_ sender: Any) {
        smfPlayer?.rewind()
        playTimeLabel.integerValue = 0
        remainTimeLabel.integerValue = Int(smfPlayer!.playbackTimeSeconds)
    }
}

//MARK: - notification
/*==============================================================================
 
 =============================================================================*/
extension ViewController {
    @objc func playbacktimeUpdate(_ notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        let playTime = userInfo[LSMFPlayer.playTimeSecondsKey] as! Int
        let remainTime = userInfo[LSMFPlayer.remainTimeSecondsKey] as! Int
        
        playTimeLabel.integerValue = playTime
        remainTimeLabel.integerValue = remainTime

    }
    
    @objc func fileAnalyzeFinish(_ notification: Notification) {
        playTimeLabel.integerValue = 0
        remainTimeLabel.integerValue = Int(smfPlayer!.playbackTimeSeconds)
    }
    
    @objc func sendEvent(_ notification: Notification) {
        let userInfo = notification.userInfo! as Dictionary
        
        print(String(userInfo[LSMFPlayer.sendPacketKey] as! Data))
    }
}

//MARK: -
/*==============================================================================
 
 =============================================================================*/
extension String {
    init(_ data: Data) {
        self.init()
        
        for d in data {
            append(String(format: "%02X ", d))
        }
        if data.count > 0 {
            removeLast()    //最後のスペースを削除する
        }
    }
}
