//
//  ViewController.swift
//  AccelerometerGyro
//
//  Created by Daesub Kim on 2016. 12. 6..
//  Copyright © 2016년 DaesubKim. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var accelerometerExistedLabel: UILabel!
    @IBOutlet weak var accelerometerActiveLabel: UILabel!
    @IBOutlet weak var xValue: UITextField!
    @IBOutlet weak var yValue: UITextField!
    @IBOutlet weak var zValue: UITextField!
    
    @IBOutlet weak var gyroExistedLabel: UILabel!
    @IBOutlet weak var gyroActiveLabel: UILabel!
    @IBOutlet weak var xGyro: UITextField!
    @IBOutlet weak var yGyro: UITextField!
    @IBOutlet weak var zGyro: UITextField!
    
    var motionManager = CMMotionManager() // must be created here so that it exists for the whole app run-time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if motionManager.accelerometerAvailable {
            accelerometerExistedLabel.text = "Accelerometer avaialble"
            if motionManager.accelerometerActive == false {
                motionManager.accelerometerUpdateInterval = 1.0 / 10.0 // 10 updates per second
                let accelQueue = NSOperationQueue()
                motionManager.startAccelerometerUpdatesToQueue(accelQueue) {
                    (data, error) in
                    if error != nil {
                        print("\(error)")
                    }
                    else {
                        self.setAccelData(data!)
                    }
                }
            }
            else {
                accelerometerActiveLabel.text = "Accelerometer is already active"
            }
        }
        else {
            accelerometerExistedLabel.text = "Accelerometer is not avaialble"
        }
        
        if motionManager.gyroAvailable {
            gyroExistedLabel.text = "Gyro avaialble"
            if motionManager.gyroActive == false {
                motionManager.gyroUpdateInterval = 0.2 // 5 updates per sec
                
                let gyroQueue = NSOperationQueue()
                
                // http://stackoverflow.com/questions/24233191/how-do-i-correctly-pass-a-block-handler-into-this-function-in-swift
                motionManager.startGyroUpdatesToQueue(gyroQueue) {
                    (data, error) in
                    if error != nil {
                        print("\(error)")
                    }
                    else {
                        self.setGyroscopeData(data!)
                    }
                }
            }
            else {
                gyroActiveLabel.text = "Gyroscope is already active"
            }
        }
        else {
            gyroExistedLabel.text = "Gyroscope is not avaialble"
        }
    }
    
    func setAccelData(data: CMAccelerometerData) {
        // http://blog.digitalneurosurgeon.com/?p=2697
        // Although retrieving gyroscope data in different thread using newly created NSOpeartionQueue, updating UI should be done in main thread
        
        let x = data.acceleration.x
        let y = data.acceleration.y
        let z = data.acceleration.z
        //                var angle = atan2(y, x)
        dispatch_sync(dispatch_get_main_queue()) {
            self.accelerometerActiveLabel.text = "Accelerometer is active"
            
            self.xValue?.text = String(format: "%0.2f", x)
            self.yValue?.text = String(format: "%0.2f", y)
            self.zValue?.text = String(format: "%0.2f", z)
        }
    }
    
    func setGyroscopeData(data: CMGyroData) {
        // http://blog.digitalneurosurgeon.com/?p=2697
        // Although retrieving gyroscope data in different thread using newly created NSOpeartionQueue, updating UI should be done in main thread
        let x: Double = data.rotationRate.x
        let y: Double = data.rotationRate.y
        let z: Double = data.rotationRate.z
        
        dispatch_sync(dispatch_get_main_queue()) {
            self.gyroActiveLabel.text = "Gyroscope is active"
            
            self.xGyro?.text = String(format: "%0.2f", x)
            self.yGyro?.text = String(format: "%0.2f", y)
            self.zGyro?.text = String(format: "%0.2f", z)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

