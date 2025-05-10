# SMFPlayerFramework用サンプルプロジェクト
## SMFPlayerFrameworkについて
SMFPlayerFrameworkでは
- MIDI送信(MIDIFrameworkで実装)
- MIDI受信(MIDIFrameworkで実装)
- MIDI処理に関連した便利機能の提供(MIDIFrameworkで実装)
- Standard MIDI Fileの再生・停止・巻き戻し

ができます。  
これらの機能をソースコードではなく、Frameworkとして提供しています。  
サンプルプロジェクト内のFrameworkをコピーして、ご自身のプロジェクトに組み込むことができます。  
  
Frameworkのアップデートがある場合は、このサンプルプロジェクトを更新します。  
サンプルプロジェクトからFrameworkを再度コピーしてお使いください。  

## MIDIデバイス関連機能
MIDIFramework用のサンプルでご確認いただけます。
SMFPlayerFrameworkで定義されているLSMFPlayerのMIDIDeviceプロパティにLMIDIクラスのインスタンスをセットします。
LMIDIクラスの機能を使ってMIDIデバイスのsourceとdestinationを決めます。
このサンプルプロジェクトでは一番最初に見つかったデバイス名でインスタンスを生成します。

```
var midiDevice = LMIDI(sourceName: *****, destinationName: *****)
```

LSMFPlayerクラスはファイル名を与えて初期化します。   
サンプルプロジェクトでは、リソース内にある"Moonlight-2.mid"というファイルで初期化しています。
```
var smfPlayer = LSMFPlayer(filePath: Bundle.main.resourcePath! + "/Moonlight-2.mid")

smfPlayer?.MIDIDevice = midiDevice
```

## Standard MIDI Fileの操作
```
smfPlayer?.play()    //再生
smfPlayer?.pause()  //停止
smfPlayer?.rewind()  //巻き戻し
```

pause()の後にplay()を実行すると、停止したところから再生します。  
rewind()で最初に戻ります。

## Notificationで多くの情報を受け取れます

LSMFPlayerクラスは多くのNotificatinoを提供しています。

例えば、
```
///すべてのメッセージを通知する
public static let messageDidSendNotification: Notification.Name
```
この通知を受け取れば、MIDI送信データ全てをリアルタイムに受け取ることができます。  
例えば、この通知を使って演奏されているデータを鍵盤として表現するなどが可能です。  

このほか、特定のメッセージに特化したNotificationもあります。
```
///システムエクスクルーシブメッセージのみ通知する
public static let systemExclusiveDidSendNotification: Notification.Name
```
これを利用すれば、システムエクスクルーシブを記録するアプリなどに利用できます。

これ以外にもNotificationを用意してありますので、利用してみてください。
