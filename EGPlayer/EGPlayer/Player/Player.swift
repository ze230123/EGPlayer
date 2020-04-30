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

    lazy var fullDisplayView: DisplayerLayer = {
        let view = DisplayerLayer()
        return view
    }()

    private var window: UIWindow?

    private var currentItem: AVPlayerItem?

    private var timeObserverToken: Any?
    private var timeControlStatusObser: NSKeyValueObservation?

    deinit {
        print("Player_deinit")
        removePlayerNotification()
        itemObserver.removeObserver()
    }

    init<V1: UIView, V2: UIView>(displayView: DisplayerLayer, portrait: V1, landScape: V2) where V1: Controlable, V2: Controlable {
        displayView.setPlayer(player)
        self.displayView = displayView
        portrait.player = player
        landScape.player = player
        self.portraitControlView = portrait
        self.landScapeControlView = landScape
        portraitGesture = GestureController(view: portrait)
        landScapeGesture = GestureController(view: landScape)

        itemObserver = PlayerItemObserver(portrait: portrait, landScape: landScape)

        layoutPortraitControl()
        addPlayerNotification()
        fullScreenAction()
    }

    func setUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        itemObserver.removeObserver()
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        itemObserver.addObserver(item)
    }

    func stop() {
        player.pause()
    }
}

private extension Player {
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
//            let totalTime = self.player.currentItem?.duration.seconds ?? 0
            self.portraitControlView.setPlayTime(currentTime)
            self.landScapeControlView.setPlayTime(currentTime)
        }
    }

    func removePlayerNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
        }
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
        portraitControlView.fullScreen = { [weak self] in
            self?.fullScreenAnimate()
        }

        landScapeControlView.fullScreen = {
            self.smallScreenAnimate()
        }
    }

    func fullScreenAnimate() {
        let fullScreen = FullViewController(controlView: landScapeControlView, player: player, source: displayView)
        // TODO: 旋转动画
        let keywindow = UIApplication.shared.windows.first

        guard let frame = keywindow?.convert(displayView?.frame ?? .zero, from: displayView?.superview) else { return }

        displayView?.setPlayer(nil)
        fullDisplayView.frame = frame
        fullDisplayView.setPlayer(player)
        keywindow?.addSubview(fullDisplayView)

        UIView.animate(withDuration: 5, animations: {
            self.fullDisplayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
            self.fullDisplayView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.fullDisplayView.center = keywindow?.center ?? .zero
        }) { (_) in
            self.fullDisplayView.isHidden = true
            self.fullDisplayView.setPlayer(nil)
            self.getCurrentController()?.present(fullScreen, animated: true, completion: nil)
        }
    }

    func smallScreenAnimate() {
        let keywindow = UIApplication.shared.windows.first
        guard let frame = keywindow?.convert(displayView?.frame ?? .zero, from: displayView?.superview) else { return }

        let tempView = DisplayerLayer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        tempView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        tempView.center = keywindow?.center ?? .zero
        tempView.setPlayer(player)
        keywindow?.addSubview(tempView)

        window = nil
        keywindow?.makeKeyAndVisible()

        UIView.animate(withDuration: 5, animations: {
            tempView.frame = frame
            tempView.transform = .identity
        }) { (_) in
            tempView.setPlayer(nil)
            tempView.removeFromSuperview()
            self.displayView?.setPlayer(self.player)
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

extension AVPlayer {
    var isPlaying: Bool {
        return timeControlStatus == .playing
    }
}
