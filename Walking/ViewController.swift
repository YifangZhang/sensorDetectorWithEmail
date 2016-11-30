//
//  ViewController.swift
//  Walking
//
//  Created by Yifang Zhang on 11/29/16.
//  Copyright © 2016 Yifang Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

