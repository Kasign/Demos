//
//  AppDelegate.swift
//  Swift+桌面
//
//  Created by mx-QS on 2019/4/2.
//  Copyright © 2019 Fly. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var  _mainViewController:FlyMainViewController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        _mainViewController = FlyMainViewController.init()
//        _mainViewController.view.frame = window.contentView?.bounds
        window.contentViewController = _mainViewController
//        window.contentView?.addSubview(_mainViewController.view)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

