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
    @IBOutlet var previousColorView: UIView!
    @IBOutlet var newColorView: UIView!
    
    var colorPicker: ChromaColorPicker!
    var brightnessSlider: ChromaBrightnessSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorPicker()
        
        
    }
    
    func setupColorPicker() {
        
        colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        colorPickerView.addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false;
        colorPicker.heightAnchor.constraint(equalToConstant: CGFloat(300.0)).isActive = true;
        colorPicker.widthAnchor.constraint(equalToConstant: CGFloat(300.0)).isActive = true;
        colorPicker.centerXAnchor.constraint(equalTo: colorPickerView.centerXAnchor).isActive = true;
        colorPicker.centerYAnchor.constraint(equalTo: colorPickerView.centerYAnchor).isActive = true;
        
        colorPicker.addTarget(self, action: #selector(updateColor(_:)), for: .valueChanged)
        
        
        
        brightnessSlider = ChromaBrightnessSlider(frame: CGRect(x: 0, y: 0, width: 280, height: 32))
        
        brightnessSliderView.addSubview(brightnessSlider)
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false;
        brightnessSlider.heightAnchor.constraint(equalToConstant: CGFloat(32.0)).isActive = true;
        brightnessSlider.widthAnchor.constraint(equalToConstant: CGFloat(280.0)).isActive = true;
        brightnessSlider.centerXAnchor.constraint(equalTo: brightnessSliderView.centerXAnchor).isActive = true;
        brightnessSlider.centerYAnchor.constraint(equalTo: brightnessSliderView.centerYAnchor).isActive = true;
        brightnessSlider.addTarget(self, action: #selector(updateBrightness(_:)), for: .valueChanged)
        
        
        colorPicker.connect(brightnessSlider)
        
        colorPicker.addHandle()
    }
    
    @objc func updateColor(_ colorPicker: ChromaColorPicker) {
        newColorView.backgroundColor = colorPicker.currentHandle?.color
    }
    
    @objc func updateBrightness(_ brightnessSlider: ChromaBrightnessSlider) {
        newColorView.backgroundColor = brightnessSlider.currentColor
    }
    
}
