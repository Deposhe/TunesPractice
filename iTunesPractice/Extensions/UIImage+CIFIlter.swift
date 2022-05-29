//
//  UIImage+CIFIlter.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import UIKit

extension UIImage {
    
    func grayscale() -> UIImage? {
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        let context = CIContext(options: nil)
        let ciImage = CIImage(image: self)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let output = filter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
