//
//  ValueStepper.swift
//  http://github.com/BalestraPatrick/ValueStepper
//
//  Created by Patrick Balestra on 2/16/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

/// The type of value of number.
///
/// - Integer:    The number without decimal part.
/// - OneDecimal: The number rounded to the first decimal digit.
/// - TwoDecimal: The number rounded to the second decimal digit.
public enum NumberType {
    case Integer
    case OneDecimal
    case TwoDecimal
}

/// Button tags
///
/// - Decrease: Decrease button has tag 0.
/// - Increase: Increase button has tag 1.
private enum Button: Int {
    case Decrease
    case Increase
}

@IBDesignable public class ValueStepper: UIControl {
    
    // MARK - Public variables
    
    /// Current value and sends UIControlEventValueChanged when modified.
    @IBInspectable public var value: Double = 0.0 {
        didSet {
            if value > maximumValue || value < minimumValue {
               // Value is possibly out of range, it means we're setting up the values so discard any update to the UI.
            } else if oldValue != value {
                sendActionsForControlEvents(.ValueChanged)
                setFormattedValue(value)
                setState()
            }
        }
    }
    
    /// Minimum value that must be the less than the maximum value.
    @IBInspectable public var minimumValue: Double = 0.0
    
    /// Maximum value that must be greater than the minimum value.
    @IBInspectable public var maximumValue: Double = 1.0
    
    /// The value added/subtracted when one of the two buttons is pressed.
    @IBInspectable public var stepValue: Double = 0.1
    
    /// When set to true, keeping a button pressed will continuously increase/decrease the value every 0.1s.
    @IBInspectable public var autorepeat: Bool = true
    
    /// The type of value that the value represents.
    public var valueType: NumberType = .OneDecimal {
        didSet {
            setFormattedValue(value)
        }
    }
    
    /// Describes the format of the value.
    private var numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    // Default width of the stepper. Taken from the official UIStepper object.
    public let defaultWidth = 141.0
    
    // Default height of the stepper. Taken from the official UIStepper object.
    public let defaultHeight = 29.0
    
    // MARK - Private variables
    
    /// Decrease button positioned on the left of the stepper.
    private let decreaseButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.backgroundColor = UIColor.clearColor()
        button.tag = Button.Decrease.rawValue
        return button
    }()
    
    /// Increase button positioned on the right of the stepper.
    private let increaseButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.backgroundColor = UIColor.clearColor()
        button.tag = Button.Increase.rawValue
        return button
    }()
    
    /// Value label that displays the current value displayed at the center of the stepper.
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // Decrease (-) button layer. Declared here because we can change its color when not enabled.
    private var decreaseLayer = CAShapeLayer()
    
    // Increase (+) button layer. Declared here because we can change its color when not enabled.
    private var increaseLayer = CAShapeLayer()
    
    // Left separator.
    private var leftSeparator = CAShapeLayer()
    
    // Right separator.
    private var rightSeparator = CAShapeLayer()
    
    // Timer used in case that autorepeat is true to change the value continuously.
    private var continuousTimer: NSTimer?
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        // Override frame with default width and height
        let frameWithDefaultSize = CGRect(x: Double(frame.origin.x), y: Double(frame.origin.y), width: defaultWidth, height: defaultHeight)
        super.init(frame: frameWithDefaultSize)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
        setUp()
    }
    
    private func setUp() {
        addSubview(decreaseButton)
        addSubview(valueLabel)
        addSubview(increaseButton)
        
        // Control events
        decreaseButton.addTarget(self, action: "decrease:", forControlEvents: .TouchUpInside)
        increaseButton.addTarget(self, action: "increase:", forControlEvents: .TouchUpInside)
        increaseButton.addTarget(self, action: "stopContinuous:", forControlEvents: .TouchUpOutside)
        decreaseButton.addTarget(self, action: "stopContinuous:", forControlEvents: .TouchUpOutside)
        decreaseButton.addTarget(self, action: "selected:", forControlEvents: .TouchDown)
        increaseButton.addTarget(self, action: "selected:", forControlEvents: .TouchDown)
    }
    
    // MARK: Storyboard preview setup
    
    override public func prepareForInterfaceBuilder() {
        setUp()
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: defaultWidth, height: defaultHeight)
    }
    
    override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    // MARK: Lifecycle
    
    public override func layoutSubviews() {
        // Size constants
        let sliceWidth = bounds.width / 3
        let sliceHeight = bounds.height
        
        // Set frames
        decreaseButton.frame = CGRect(x: 0, y: 0, width: sliceWidth, height: sliceHeight)
        valueLabel.frame = CGRect(x: sliceWidth, y: 0, width: sliceWidth, height: sliceHeight)
        increaseButton.frame = CGRect(x: sliceWidth * 2, y: 0, width: sliceWidth, height: sliceHeight)
        
        // Set text color to tintColor
        valueLabel.textColor = tintColor
        
        // Set initial formatted value
        setFormattedValue(value)
    }
    
    public override func drawRect(rect: CGRect) {
        // Size constants
        let sliceWidth = bounds.width / 3
        let sliceHeight = bounds.height
        let thickness = 1.0 as CGFloat
        let iconSize: CGFloat = sliceHeight * 0.6
        
        // Layer customizations
        layer.borderColor = tintColor.CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        backgroundColor = UIColor.clearColor()
        clipsToBounds = true
        
        let leftPath = UIBezierPath()
        // Left separator line
        leftPath.moveToPoint(CGPoint(x: sliceWidth, y: 0.0))
        leftPath.addLineToPoint(CGPoint(x: sliceWidth, y: sliceHeight))
        tintColor.setStroke()
        leftPath.stroke()
        
        // Set left separator layer
        leftSeparator.path = leftPath.CGPath
        leftSeparator.strokeColor = tintColor.CGColor
        layer.addSublayer(leftSeparator)
        
        // Right separator line
        let rightPath = UIBezierPath()
        rightPath.moveToPoint(CGPoint(x: sliceWidth * 2, y: 0.0))
        rightPath.addLineToPoint(CGPoint(x: sliceWidth * 2, y: sliceHeight))
        tintColor.setStroke()
        rightPath.stroke()
        
        // Set right separator layer
        rightSeparator.path = rightPath.CGPath
        rightSeparator.strokeColor = tintColor.CGColor
        layer.addSublayer(rightSeparator)
        
        // - path
        let decreasePath = UIBezierPath()
        decreasePath.lineWidth = thickness
        // Horizontal + line
        decreasePath.moveToPoint(CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5, y: sliceHeight / 2 + 0.5))
        decreasePath.addLineToPoint(CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5 + iconSize, y: sliceHeight / 2 + 0.5))
        tintColor.setStroke()
        decreasePath.stroke()
        
        // Create layer so that we can dynamically change its color when not enabled
        decreaseLayer.path = decreasePath.CGPath
        decreaseLayer.strokeColor = tintColor.CGColor
        layer.addSublayer(decreaseLayer)
        
        // + path
        let increasePath = UIBezierPath()
        increasePath.lineWidth = thickness
        // Horizontal + line
        increasePath.moveToPoint(CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5 + sliceWidth * 2, y: sliceHeight / 2 + 0.5))
        increasePath.addLineToPoint(CGPoint(x: (sliceWidth - iconSize) / 2 + 0.5 + iconSize + sliceWidth * 2, y: sliceHeight / 2 + 0.5))
        // Vertical + line
        increasePath.moveToPoint(CGPoint(x: sliceWidth / 2 + 0.5 + sliceWidth * 2, y: (sliceHeight / 2) - (iconSize / 2) + 0.5))
        increasePath.addLineToPoint(CGPoint(x: sliceWidth / 2 + 0.5 + sliceWidth * 2, y: (sliceHeight / 2) + (iconSize / 2) + 0.5))
        tintColor.setStroke()
        increasePath.stroke()
        
        // Create layer so that we can dynamically change its color when not enabled
        increaseLayer.path = increasePath.CGPath
        increaseLayer.strokeColor = tintColor.CGColor
        layer.addSublayer(increaseLayer)
        
        // Set initial buttons state
        setState()
    }
    
    // MARK: Control Events
    
    func decrease(sender: UIButton) {
        sender.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        // If there is a timer, stop it before it overflows the minimum value.
        if let timer = continuousTimer {
            timer.invalidate()
            return
        }
        value -= stepValue
    }
    
    func increase(sender: UIButton) {
        sender.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        // If there is a timer, stop it before it overflows the maximum value.
        if let timer = continuousTimer {
            timer.invalidate()
            return
        }
        value += stepValue
    }
    
    func continuousIncrement(timer: NSTimer) {
        // Check which one of the two buttons was continuously pressed
        let sender = timer.userInfo!["sender"] as! UIButton
        if sender.tag == Button.Decrease.rawValue {
            value -= stepValue
        } else {
            value += stepValue
        }
    }
    
    func selected(sender: UIButton) {
        // Start a timer to handle the continuous pressed case
        if autorepeat {
            continuousTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "continuousIncrement:", userInfo: ["sender" : sender], repeats: true)
        }
        sender.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
    }
    
    func stopContinuous(sender: UIButton) {
        // When dragged outside, stop the timer.
        continuousTimer?.invalidate()
    }
    
    // MARK: Actions
    
    private func setState() {
        if value.rounded(numberFormatter.maximumFractionDigits) >= maximumValue {
            increaseButton.enabled = false
            increaseLayer.strokeColor = UIColor.grayColor().CGColor
            continuousTimer?.invalidate()
        } else if value.rounded(numberFormatter.maximumFractionDigits) <= minimumValue {
            decreaseButton.enabled = false
            decreaseLayer.strokeColor = UIColor.grayColor().CGColor
            continuousTimer?.invalidate()
        } else {
            increaseButton.enabled = true
            decreaseButton.enabled = true
            increaseLayer.strokeColor = tintColor.CGColor
            decreaseLayer.strokeColor = tintColor.CGColor
        }
    }
    
    // Display the value with the
    private func setFormattedValue(value: Double) {
        valueLabel.text = numberFormatter.stringFromNumber(value)
    }
    
    // Update all the subviews tintColor properties.
    public override func tintColorDidChange() {
        layer.borderColor = tintColor.CGColor
        valueLabel.textColor = tintColor
        leftSeparator.strokeColor = tintColor.CGColor
        rightSeparator.strokeColor = tintColor.CGColor
    }
    
}

// MARK: Double rounding - Extension

extension Double {
    func rounded(digits: Int) -> Double {
        let decimalValue = pow(10.0, Double(digits))
        return round(self * decimalValue) / decimalValue
    }
}
