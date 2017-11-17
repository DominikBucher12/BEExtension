//
//  ViewController.swift
//  emptyMacApp
//
//  Created by Dominik Bucher on 26/05/2017.
//  Copyright © 2017 Dominik Bucher. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    enum SuperEnum {
        case awesome
        case cool, veryCool, extraCool
    }

    func doSwitch(with smth: SuperEnum) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController {


    func doSmthAwesome() {

    }

    func doSmthCool() {

    }
}

