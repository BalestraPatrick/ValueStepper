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

    @IBOutlet weak var stepper1: ValueStepper!
    @IBOutlet weak var stepper2: ValueStepper!
    @IBOutlet weak var stepper3: ValueStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up currency number formatter
        let moneyFormatter = NSNumberFormatter()
        moneyFormatter.numberStyle = .CurrencyStyle
        moneyFormatter.maximumFractionDigits = 0
        stepper3.numberFormatter = moneyFormatter
        
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

