//
//  ColorPickerViewController.swift
//  ColorEachDay
//
//  Created by Kent Mei on 6/23/20.
//  Copyright © 2020 Kent Mei. All rights reserved.
//

import UIKit
import JTAppleCalendar
import ChromaColorPicker

class ColorPickerViewController: UIViewController {
    
    @IBOutlet var colorPickerView: UIView!
    @IBOutlet var brightnessSliderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorPicker()
        
    }
    
    func setupColorPicker() {
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPickerView.addSubview(colorPicker)
        
        let brightnessSlider = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 280, height: 32))
        brightnessSliderView.addSubview(brightnessSlider)
        
        colorPicker.connect(brightnessSlider)
        
        colorPicker.addHandle()
    }
}
