//
//  ViewController.swift
//  ValueStepper
//
//  Created by Patrick Balestra on 02/18/2016.
//  Copyright (c) 2016 Patrick Balestra. All rights reserved.
//

import UIKit
import ValueStepper

class ViewController: UIViewController {
    
    let integerValueStepper: ValueStepper = {
        let stepper = ValueStepper()
        stepper.tintColor = .whiteColor()
        stepper.minimumValue = 0
        stepper.maximumValue = 1000
        stepper.stepValue = 100
        stepper.valueType = .Integer
        return stepper
    }()

    @IBOutlet weak var stepper1: ValueStepper!
    @IBOutlet weak var stepper2: ValueStepper!
    @IBOutlet weak var stepper3: ValueStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper3.valueType = .Integer
        stepper3.addTarget(self, action: "valueChanged3:", forControlEvents: .ValueChanged)
    }
    
    @IBAction func valueChanged1(sender: ValueStepper) {
        print("Stepper 1: \(sender.value)")
    }
    
    @IBAction func valueChanged2(sender: ValueStepper) {
        print("Stepper 2: \(sender.value)")
    }
    
    func valueChanged3(sender: ValueStepper) {
        print("Stepper 3: \(sender.value)")
    }
}

