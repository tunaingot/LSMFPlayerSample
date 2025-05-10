//
//  ViewController.swift
//  LSMFPlayerSample iOS
//
//  Created by 大川 博 on 2025/05/10.
//

import UIKit
import SMFPlayerFramework

class ViewController: UIViewController {
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    private var midiDevice: LMIDI?
    private var smfPlayer: LSMFPlayer?

    /*==========================================================================
     
     =========================================================================*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(LMIDI.sourceNames)                                            //接続されている送信MIDIデバイス全てを表示する
        print(LMIDI.destinationNames)                                       //接続されている受信MIDIデバイス全てを表示する

        midiDevice = LMIDI(sourceName: LMIDI.sourceNames.last!,             //MIDIデバイスのインスタンスを生成する
                           destinationName: LMIDI.destinationNames.last!)
        smfPlayer = LSMFPlayer(filePath: Bundle.main.resourcePath! + "/Moonlight-2.mid")
        smfPlayer?.MIDIDevice = midiDevice
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendEvent(_:)), name: LSMFPlayer.messageDidSendNotification, object: smfPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playbacktimeUpdate(_:)), name: LSMFPlayer.playbackTimeUpdatedNotification, object: smfPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(fileAnalyzeFinish(_:)), name: LSMFPlayer.fileAnalyzeFinishNotification, object: smfPlayer)
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
        playTimeLabel.text = "0"
        remainTimeLabel.text = String(Int(smfPlayer!.playbackTimeSeconds))
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
        
        playTimeLabel.text = String(playTime)
        remainTimeLabel.text = String(remainTime)

    }
    
    @objc func fileAnalyzeFinish(_ notification: Notification) {
        playTimeLabel.text = "0"
        remainTimeLabel.text = String(Int(smfPlayer!.playbackTimeSeconds))
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
