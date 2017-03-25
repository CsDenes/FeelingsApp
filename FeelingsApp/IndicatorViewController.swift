//
//  IndicatorViewController.swift
//  FeelingsApp
//
//  Created by Denes Csizmadia on 2017. 03. 11..
//  Copyright © 2017. Denes Csizmadia. All rights reserved.
//

import UIKit
import KDCircularProgress
import SwiftSiriWaveformView
import CoreImage

class IndicatorViewController: UIViewController {
    
    @IBOutlet weak var faceImage: UIImageView!
    
    @IBOutlet var progressHa: KDCircularProgress!

    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var waveformView: SwiftSiriWaveformView!
    
    var timer:Timer?
    var change:CGFloat = 0.01

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = "Happy"
        
        self.waveformView.density = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(IndicatorViewController.refreshAudioView(_:)), userInfo: nil, repeats: true)
        
        progressHa.animate(fromAngle: 0, toAngle: 240, duration: 5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        
        
        
        let image = UIImage(named: "testImage.png")
        let imageBlackAndWhite = blackAndWhiteImage(image: image!)
        self.faceImage.layer.cornerRadius = faceImage.frame.size.width/2
        self.faceImage.layer.masksToBounds = true

        
        self.faceImage.image = imageBlackAndWhite
        
        
        WebService.PostImage(image: image!)
        

        // Do any additional setup after loading the view.
    }
    
    
    internal func refreshAudioView(_:Timer) {
        if self.waveformView.amplitude <= self.waveformView.idleAmplitude || self.waveformView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.waveformView.amplitude += self.change
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func blackAndWhiteImage(image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        let ciImage = CoreImage.CIImage(image: image)!
        
        // Set image color to b/w
        let bwFilter = CIFilter(name: "CIColorControls")!
        bwFilter.setValuesForKeys([kCIInputImageKey:ciImage, kCIInputBrightnessKey:NSNumber(value: 0.0), kCIInputContrastKey:NSNumber(value: 1.1), kCIInputSaturationKey:NSNumber(value: 0.0)])
        let bwFilterOutput = (bwFilter.outputImage)!
        
        // Adjust exposure
        let exposureFilter = CIFilter(name: "CIExposureAdjust")!
        exposureFilter.setValuesForKeys([kCIInputImageKey:bwFilterOutput, kCIInputEVKey:NSNumber(value: 0.7)])
        let exposureFilterOutput = (exposureFilter.outputImage)!
        
        // Create UIImage from context
        let bwCGIImage = context.createCGImage(exposureFilterOutput, from: ciImage.extent)
        let resultImage = UIImage(cgImage: bwCGIImage!, scale: 1.0, orientation: image.imageOrientation)
        
        return resultImage
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



