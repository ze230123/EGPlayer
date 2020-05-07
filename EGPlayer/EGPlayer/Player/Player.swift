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

    private var tipsView: (UIView & TipsControlable)

    /// 显示画面
    private var displayView: DisplayerLayer = DisplayerLayer()

    private weak var contentView: UIView?

    lazy var customWindow: UIWindow = {
        if #available(iOS 13.0, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return UIWindow(windowScene: currentWindowScene)
            } else {
                return UIWindow(frame: .zero)
            }
        } else {
            return UIWindow(frame: .zero)
        }
    }()

    private var timeObserverToken: Any?
    private var timeControlStatusObser: NSKeyValueObservation?

    private var currentItem: PlayerItem?

    private var isFullScreen: Bool = false

    deinit {
        print("Player_deinit")
        removePlayerNotification()
        itemObserver.removeObserver()
    }

    init<V1: UIView, V2: UIView, V3: UIView>(contentView: UIView, portrait: V1, landScape: V2, tipsView: V3) where V1: Controlable, V2: Controlable, V3: TipsControlable {
        self.contentView = contentView
        portrait.player = player
        landScape.player = player
        self.tipsView = tipsView
        self.portraitControlView = portrait
        self.landScapeControlView = landScape
        portraitGesture = GestureController(view: portrait)
        landScapeGesture = GestureController(view: landScape)

        itemObserver = PlayerItemObserver(portrait: portrait, landScape: landScape)

        layoutDisplayerView()
        layoutPortraitControl()
        addPlayerNotification()
        fullScreenAction()

        self.displayView.setPlayer(player)
    }

    func setItem(_ item: PlayerItem?) {
        guard let item = item, item.state != .offline, let url = URL(string: item.url) else {
            tipsView.setState(.offline)
            layoutTipsView()
            return
        }

        tipsView.removeFromSuperview()

        if isFullScreen {
            layoutlandScapeControl()
        } else {
            layoutPortraitControl()
        }

        self.currentItem = item

        itemObserver.removeObserver()
        let avitem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: avitem)
        itemObserver.addObserver(avitem)
    }

    func stop() {
        player.pause()
    }
}

private extension Player {
    func layoutDisplayerView() {
        guard let contentView = contentView else { return }
        displayView.frame = contentView.bounds
        displayView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        contentView.addSubview(displayView)
    }

    func layoutPortraitControl() {
        portraitControlView.removeFromSuperview()
        portraitControlView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(portraitControlView)
        portraitControlView.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        portraitControlView.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        portraitControlView.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        portraitControlView.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
    }

    func layoutlandScapeControl() {
        landScapeControlView.removeFromSuperview()
        landScapeControlView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(landScapeControlView)
        landScapeControlView.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        landScapeControlView.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        landScapeControlView.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        landScapeControlView.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
    }

    func layoutTipsView() {
        portraitControlView.removeFromSuperview()
        landScapeControlView.removeFromSuperview()
        tipsView.isFullScreen = isFullScreen
        tipsView.translatesAutoresizingMaskIntoConstraints = false
        displayView.addSubview(tipsView)
        tipsView.topAnchor.constraint(equalTo: displayView.topAnchor).isActive = true
        tipsView.leftAnchor.constraint(equalTo: displayView.leftAnchor).isActive = true
        tipsView.rightAnchor.constraint(equalTo: displayView.rightAnchor).isActive = true
        tipsView.bottomAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
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
            self.portraitControlView.setPlayTime(currentTime)
            self.landScapeControlView.setPlayTime(currentTime)

            guard let item = self.currentItem else { return }

            if item.state != .normal && item.tryTime != 0 && item.tryTime <= currentTime {
                self.tipsView.setState(item.state)
                self.player.pause()
                self.layoutTipsView()
            }
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

        landScapeControlView.fullScreen = { [weak self] in
            self?.smallScreenAnimate()
        }

        tipsView.fullScreen = { [weak self] isFullScreen in
            if isFullScreen {
                self?.tipsSmallScreenAnimate()
            } else {
                self?.tipsFullScrenAnimate()
            }
        }
    }

    func tipsFullScrenAnimate() {
        let keywindow = UIApplication.shared.keyWindow
        displayView.frame = displayView.convert(displayView.frame, to: keywindow)
        keywindow?.addSubview(displayView)

        let fullVC = CustomFullViewController()
        customWindow.rootViewController = fullVC

        let frame = keywindow?.convert(keywindow?.bounds ?? .zero, to: keywindow) ?? .zero

        UIView.animate(withDuration: 1, animations: {
            self.displayView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.displayView.frame = frame
            self.displayView.layoutIfNeeded()
        }) { (_) in
            self.tipsView.isFullScreen = true
        }
    }

    func tipsSmallScreenAnimate() {
        let keywindow = UIApplication.shared.keyWindow

        let fullVC = SamllViewController()
        customWindow.rootViewController = fullVC

        let frame = contentView?.convert(contentView?.bounds ?? .zero, to: keywindow) ?? .zero

        UIView.animate(withDuration: 1, animations: {
            self.displayView.transform = .identity
            self.displayView.frame = frame
            self.displayView.layoutIfNeeded()
        }) { (_) in
            self.layoutDisplayerView()
            self.tipsView.isFullScreen = false
        }
    }

    // MARK: - 新方案
    func fullScreenAnimate() {
        let keywindow = UIApplication.shared.keyWindow
        displayView.frame = displayView.convert(displayView.frame, to: keywindow)
        portraitControlView.removeFromSuperview()
        keywindow?.addSubview(displayView)

        let fullVC = CustomFullViewController()
        customWindow.rootViewController = fullVC

        let frame = keywindow?.convert(keywindow?.bounds ?? .zero, to: keywindow) ?? .zero

        UIView.animate(withDuration: 1, animations: {
            self.displayView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.displayView.frame = frame
        }) { (_) in
            self.layoutlandScapeControl()
            self.isFullScreen = true
        }
    }

    func smallScreenAnimate() {
        let keywindow = UIApplication.shared.keyWindow

        let fullVC = SamllViewController()
        customWindow.rootViewController = fullVC

        let frame = contentView?.convert(contentView?.bounds ?? .zero, to: keywindow) ?? .zero

        UIView.animate(withDuration: 1, animations: {
            self.displayView.transform = .identity
            self.displayView.frame = frame
        }) { (_) in
            self.layoutDisplayerView()
            self.layoutPortraitControl()
            self.isFullScreen = false
        }
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return timeControlStatus == .playing
    }
}

class CustomFullViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}

class SamllViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
