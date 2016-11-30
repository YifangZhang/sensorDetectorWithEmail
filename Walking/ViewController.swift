//
//  ViewController.swift
//  Walking
//
//  Created by Yifang Zhang on 11/29/16.
//  Copyright © 2016 Yifang Zhang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    /* init all labels */
    @IBOutlet weak var label_acc_x: UILabel!
    @IBOutlet weak var label_acc_y: UILabel!
    @IBOutlet weak var label_acc_z: UILabel!
    @IBOutlet weak var label_gyro_x: UILabel!
    @IBOutlet weak var label_gyro_y: UILabel!
    @IBOutlet weak var label_gyro_z: UILabel!
    @IBOutlet weak var label_mag_x: UILabel!
    @IBOutlet weak var label_mag_y: UILabel!
    @IBOutlet weak var label_mag_z: UILabel!
    @IBOutlet weak var label_yaw: UILabel!
    @IBOutlet weak var label_pitch: UILabel!
    @IBOutlet weak var label_roll: UILabel!
    @IBOutlet weak var label_compass: UILabel!
    /* end of label init */
    
    /* init all sensors */
    var acc_x : [Double] = []
    var acc_z : [Double] = []
    var acc_y : [Double] = []
    var time_acc : [String] = []
    
    var gyro_x : [Double] = []
    var gyro_z : [Double] = []
    var gyro_y : [Double] = []
    var time_gyro : [String] = []
    
    var mag_x : [Double] = []
    var mag_z : [Double] = []
    var mag_y : [Double] = []
    var time_mag : [String] = []
    
    var yaw_ : [Double] = []
    var pitch_ : [Double] = []
    var roll_ : [Double] = []
    var time_yaw : [String] = []

    var time_compass : [String] = []
    var compass : [Double] = []
    /* end of sensor init */
    
    var isStart : Bool = false
    var motionManager = CMMotionManager()
    var locationManager = CLLocationManager()
    
// MARK: - Functions starting here

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        clearAll()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func StartMonitering(_ sender: Any) {
        
        if(isStart == false){
            isStart = true
            
            NSLog("yay")
            
            locationManager.startUpdatingHeading()
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
                self.outputAccData_(accelerometerData!.acceleration)
                //self.start.setTitle("Stop", for: UIControlState())
                if(NSError != nil) {
                    print("\(NSError)")
                }
            }
            
            motionManager.startMagnetometerUpdates(to: OperationQueue.current!, withHandler: { (magData: CMMagnetometerData?, NSError) -> Void in
                self.outputMagData(magData!.magneticField)
                if(NSError != nil){
                    print("\(NSError)")
                }
            })
            motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
                self.outputRotData_(gyroData!.rotationRate)
                if (NSError != nil){
                    print("\(NSError)")
                }
                
                
            })
            
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                (deviceMotion, error) -> Void in
                self.outputDirection_(deviceMotion!)
                if(error != nil){
                    print("\(error)")
                }
            })
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let date = Date()
        let calendar = Calendar.current
        
        let day = (calendar as NSCalendar).component(.day, from: date)
        let month = (calendar as NSCalendar).component(.month, from: date)
        let year = (calendar as NSCalendar).component(.year, from: date)
        
        let hour = (calendar as NSCalendar).component(.hour, from: date)
        let minutes = (calendar as NSCalendar).component(.minute, from: date)
        let seconds = (calendar as NSCalendar).component(.second, from: date)
        let milli = (calendar as NSCalendar).component(.nanosecond, from: date)
        
        let input : String = String(format:"%d-%d-%d_%d-%d-%d.%d", day, month, year, hour, minutes, seconds, milli)
        

        NSLog("input: ", input)
        
        self.time_compass.append(input)
        
        var comp_val = 0.0
        
        if(Double(newHeading.magneticHeading) > 180.0){
            comp_val = Double(newHeading.magneticHeading) - 360.0
        }
        else{
            comp_val = Double(newHeading.magneticHeading)
        }
        self.compass.append(comp_val)
        self.label_compass.text = String(Double(newHeading.magneticHeading))
        //ƒself.compass_lb.text = String(Double(newHeading.magneticHeading))
        
    }
    
    //real versions
    func outputDirection_(_ deviceMotion: CMDeviceMotion){
        let attitude = deviceMotion.attitude
        let yaw = (attitude.yaw) / M_PI * 180.0
        let pitch = attitude.pitch / M_PI * 180.0
        let roll = attitude.roll / M_PI * 180.0
        self.label_yaw.text = String(yaw)
        self.label_pitch.text = String(pitch)
        self.label_roll.text = String(roll)
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = (calendar as NSCalendar).component(.day, from: date)
        let month = (calendar as NSCalendar).component(.month, from: date)
        let year = (calendar as NSCalendar).component(.year, from: date)
        
        let hour = (calendar as NSCalendar).component(.hour, from: date)
        let minutes = (calendar as NSCalendar).component(.minute, from: date)
        let seconds = (calendar as NSCalendar).component(.second, from: date)
        let milli = (calendar as NSCalendar).component(.nanosecond, from: date)
        
        let input : String = String(format:"%d-%d-%d_%d-%d-%d.%d", day, month, year, hour, minutes, seconds, milli)
        
        yaw_.append(yaw)
        pitch_.append(pitch)
        roll_.append(roll)
        time_yaw.append(input)
        
    }
    
    func outputAccData_(_ acceleration: CMAcceleration){
        
        acc_x.append(acceleration.x)
        acc_y.append(acceleration.y)
        acc_z.append(acceleration.z)
        
        self.label_acc_x.text = String(acceleration.x)
        self.label_acc_y.text = String(acceleration.y)
        self.label_acc_z.text = String(acceleration.z)
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = (calendar as NSCalendar).component(.day, from: date)
        let month = (calendar as NSCalendar).component(.month, from: date)
        let year = (calendar as NSCalendar).component(.year, from: date)
        
        let hour = (calendar as NSCalendar).component(.hour, from: date)
        let minutes = (calendar as NSCalendar).component(.minute, from: date)
        let seconds = (calendar as NSCalendar).component(.second, from: date)
        let milli = (calendar as NSCalendar).component(.nanosecond, from: date)
        
        let input : String = String(format:"%d-%d-%d_%d-%d-%d.%d", day, month, year, hour, minutes, seconds, milli)
        
        time_acc.append(input)
        
    }
    
    func outputMagData(_ mag: CMMagneticField){
        
        mag_x.append(mag.x)
        mag_y.append(mag.y)
        mag_z.append(mag.z)
        
        self.label_mag_x.text = String(mag.x)
        self.label_mag_y.text = String(mag.y)
        self.label_mag_z.text = String(mag.z)
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = (calendar as NSCalendar).component(.day, from: date)
        let month = (calendar as NSCalendar).component(.month, from: date)
        let year = (calendar as NSCalendar).component(.year, from: date)
        
        let hour = (calendar as NSCalendar).component(.hour, from: date)
        let minutes = (calendar as NSCalendar).component(.minute, from: date)
        let seconds = (calendar as NSCalendar).component(.second, from: date)
        let milli = (calendar as NSCalendar).component(.nanosecond, from: date)
        
        let input : String = String(format:"%d-%d-%d_%d-%d-%d.%d", day, month, year, hour, minutes, seconds, milli)
        time_mag.append(input)
        
        
    }
    
    func outputRotData_(_ rotation: CMRotationRate){
        
        gyro_x.append(rotation.x)
        gyro_y.append(rotation.y)
        gyro_z.append(rotation.z)
        
        self.label_gyro_x.text = String(rotation.x)
        self.label_gyro_y.text = String(rotation.y)
        self.label_gyro_z.text = String(rotation.z)
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = (calendar as NSCalendar).component(.day, from: date)
        let month = (calendar as NSCalendar).component(.month, from: date)
        let year = (calendar as NSCalendar).component(.year, from: date)
        
        let hour = (calendar as NSCalendar).component(.hour, from: date)
        let minutes = (calendar as NSCalendar).component(.minute, from: date)
        let seconds = (calendar as NSCalendar).component(.second, from: date)
        let milli = (calendar as NSCalendar).component(.nanosecond, from: date)
        
        let input : String = String(format:"%d-%d-%d_%d-%d-%d.%d", day, month, year, hour, minutes, seconds, milli)
        
        time_gyro.append(input)
        
    }

    
    
    @IBAction func StopMonitering(_ sender: Any) {
        isStart = false
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopMagnetometerUpdates()
        locationManager.stopUpdatingHeading()
    }
    
    @IBAction func ClearData(_ sender: Any) {
        clearAll()
    }

    @IBAction func SendEmail(_ sender: Any) {
        mailCSV(["yifangzhang2009@gmail.com"])
    }
    
    
    
    func clearAll() {
        
        /* all values are cleared */
        acc_x = []
        acc_z = []
        acc_y = []
        time_acc = []
        
        gyro_x = []
        gyro_z = []
        gyro_y = []
        time_gyro = []
        
        mag_x = []
        mag_z = []
        mag_y = []
        time_mag = []
        
        yaw_ = []
        pitch_ = []
        roll_ = []
        time_yaw = []
        
        time_compass = []
        compass = []
        
        isStart = false
        
        /* all labels are reset */
        label_acc_x.text = "0.0"
        label_acc_y.text = "0.0"
        label_acc_z.text = "0.0"
        label_gyro_x.text = "0.0"
        label_gyro_y.text = "0.0"
        label_gyro_z.text = "0.0"
        label_mag_x.text = "0.0"
        label_mag_y.text = "0.0"
        label_mag_z.text = "0.0"
        label_yaw.text = "0.0"
        label_pitch.text = "0.0"
        label_roll.text = "0.0"
        
    }


// MARK: - mail supporting functions
    
    func mailCSV (_ target:[String]){
        
        let mailStringAcc = NSMutableString()
        NSLog("before acc")
        NSLog("%d, %d", self.time_acc.count, self.acc_x.count)
        mailStringAcc.append("timestamp,acc_x,acc_y,acc_z\n")
        if(self.acc_x.count != 0){
            for i in 0...(self.acc_x.count-1){
                mailStringAcc.append("\(self.time_acc[i]), \(String(self.acc_x[i])), \(String(self.acc_y[i])), \(String(self.acc_z[i]))\n")
            }
        }
        let mailStringGyro = NSMutableString()
        NSLog("before gyro")
        mailStringGyro.append("timestamp,gyro_x,gyro_y,gyro_z\n")
        if(self.gyro_x.count != 0){
            for i in 0...(self.gyro_x.count-1){
                mailStringGyro.append("\(self.time_gyro[i]),\(String(self.gyro_x[i])),\(String(self.gyro_y[i])),\(String(self.gyro_z[i]))\n")
            }
        }
        let mailStringMag = NSMutableString()
        NSLog("before mag")
        mailStringMag.append("timestamp, mag_x, mag_y, mag_z\n")
        if(self.mag_x.count != 0){
            for i in 0...(self.mag_x.count-1){
                mailStringMag.append("\(self.time_mag[i]),\(String(self.mag_x[i])),\(String(self.mag_y[i])),\(String(self.mag_z[i]))\n")
            }
        }
        let mailStringYaw = NSMutableString()
        NSLog("before yaw")
        mailStringYaw.append("timestamp, yaw, pitch, roll\n")
        if(self.yaw_.count != 0){
            for i in 0...(self.yaw_.count-1){
                mailStringYaw.append("\(self.time_yaw[i]),\(String(self.yaw_[i])),\(String(self.pitch_[i])),\(String(self.roll_[i]))\n")
            }
        }
        let mailStringComp = NSMutableString()
        NSLog("before compass")
        mailStringComp.append("timestamp, compass\n")
        if(self.compass.count != 0){
            for i in 0...(self.compass.count-1){
                mailStringComp.append("\(self.time_compass[i]),\(self.compass[i])\n")
            }
        }
        
        // Converting it to NSData.
        let dataAcc = mailStringAcc.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        let dataGyro = mailStringGyro.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        let dataMag = mailStringMag.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        let dataYaw = mailStringYaw.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        let dataComp = mailStringComp.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        
        // Unwrapping the optional.
        /*if let content = data {
            print("NSData: \(content)")
        }*/
        
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setSubject("CSV File")
        emailController.setToRecipients(target)
        emailController.setMessageBody("", isHTML: false)
        
        // Attaching the .CSV file to the email.
        emailController.addAttachmentData(dataAcc!, mimeType: "text/csv", fileName: "Acc.csv")
        emailController.addAttachmentData(dataGyro!, mimeType: "text/csv", fileName: "Gyro.csv")
        emailController.addAttachmentData(dataMag!, mimeType: "text/csv", fileName: "Mag.csv")
        emailController.addAttachmentData(dataYaw!, mimeType: "text/csv", fileName: "Yaw.csv")
        emailController.addAttachmentData(dataComp!, mimeType: "text/csv", fileName: "Comp.csv")
        
        
        if MFMailComposeViewController.canSendMail() {
            self.present(emailController, animated: true, completion: nil)
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}

