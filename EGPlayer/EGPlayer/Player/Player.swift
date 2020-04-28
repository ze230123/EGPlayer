//
//  Player.swift
//  EGPlayer
//
//  Created by youzy01 on 2020/4/27.
//  Copyright © 2020 youzy. All rights reserved.
//

import UIKit
import AVFoundation

class Player {
    /// 播放器
    private let player = AVPlayer()

    lazy var fullScreen = FullViewController(controlView: landScapeControlView, player: player, source: displayView)
    /// 竖屏手势控制器
    private let portraitGesture: GestureController
    /// 横屏手势控制器
    private let landScapeGesture: GestureController

    private let itemObserver: PlayerItemObserver

    /// 手机竖屏时的 控制view
    private var portraitControlView: (UIView & Controlable)
    /// 手机横屏时的 控制view
    private var landScapeControlView: (UIView & Controlable)

    /// 显示画面
    weak var displayView: DisplayerLayer?

    private var currentItem: AVPlayerItem?

    private var timeObserverToken: Any?
    private var timeControlStatusObser: NSKeyValueObservation?

    deinit {
        removePlayerNotification()
    }

    init<V: UIView>(displayView: DisplayerLayer, portrait: V, landScape: V) where V: Controlable {
        self.displayView = displayView
        self.portraitControlView = portrait
        self.landScapeControlView = landScape
        portraitGesture = GestureController(view: portrait)
        landScapeGesture = GestureController(view: landScape)

        itemObserver = PlayerItemObserver(portrait: portrait, landScape: landScape)

        addPlayerNotification()
    }

    func layoutPortraitControl() {
        guard let displayView = displayView else {
            fatalError("displayView is nil")
        }
        portraitControlView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(portraitControlView)
        portraitControlView.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        portraitControlView.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        portraitControlView.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        portraitControlView.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
    }
}

private extension Player {
    func addPlayerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playDidError), name: Notification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)

        timeControlStatusObser = player.observe(\.timeControlStatus) { [unowned self] (item, _) in
            switch item.timeControlStatus {
            case .paused:
                self.portraitControlView.playerDidChangedState(.paused)
                self.landScapeControlView.playerDidChangedState(.paused)
            case .playing:
                self.portraitControlView.playerDidChangedState(.playing)
                self.landScapeControlView.playerDidChangedState(.playing)
            case .waitingToPlayAtSpecifiedRate:
                self.portraitControlView.playerDidChangedState(.cacheing)
                self.landScapeControlView.playerDidChangedState(.cacheing)
            @unknown default:
                fatalError()
            }
        }

        /// 播放时间
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [unowned self] (time) in
            let currentTime = time.seconds
            let totalTime = self.player.currentItem?.duration.seconds ?? 0
            self.portraitControlView.setPlayTime(currentTime, total: totalTime)
            self.landScapeControlView.setPlayTime(currentTime, total: totalTime)
        }
    }

    func removePlayerNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
        timeControlStatusObser = nil
        timeObserverToken = nil
    }

    @objc func playerDidFinish() {
        print("播放完成")
        portraitControlView.playerDidChangedState(.playEnd)
        landScapeControlView.playerDidChangedState(.playEnd)
    }

    @objc func playDidError() {
        guard let error = player.error else { return }
        portraitControlView.playerDidChangedState(.failed(error))
        landScapeControlView.playerDidChangedState(.failed(error))
        print("播放失败", error.localizedDescription)
    }

    // FIXME: 全屏操作、需要测试
    func fullScreenAction() {
        portraitControlView.fullScreen = { [unowned self] in
            self.getCurrentController()?.present(self.fullScreen, animated: true, completion: nil)
        }

        landScapeControlView.fullScreen = { [unowned self] in
            self.fullScreen.dismiss(animated: true, completion: nil)
        }
    }

    func getCurrentController() -> UIViewController? {
         guard let window = UIApplication.shared.windows.first else {
             return nil
         }
         var tempView: UIView?
         for subview in window.subviews.reversed() {
             if subview.classForCoder.description() == "UILayoutContainerView" {
                 tempView = subview
                 break
             }
         }

         if tempView == nil {
             tempView = window.subviews.last
         }

         var nextResponder = tempView?.next
         var next: Bool {
             return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
         }

         while next{
             tempView = tempView?.subviews.first
             if tempView == nil {
                 return nil
             }
             nextResponder = tempView!.next
         }
         return nextResponder as? UIViewController
     }
}
