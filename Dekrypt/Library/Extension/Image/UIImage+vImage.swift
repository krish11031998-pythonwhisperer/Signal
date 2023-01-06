//
//  UIImage+vImage.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import Accelerate.vImage
import UIKit

extension UIImage {
    func resizeVI(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
//
//            var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
//                                              bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.First.rawValue),
//                                              version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
//            var sourceBuffer = vImage_Buffer()
//            defer {
//                sourceBuffer.data.deallocate()
//            }
//
//            var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
//            guard error == kvImageNoError else { return nil }
//
//            // create a destination buffer
//            let scale = self.scale
//            let destWidth = Int(size.width)
//            let destHeight = Int(size.height)
//            let bytesPerPixel = CGImageGetBitsPerPixel(self.CGImage) / 8
//            let destBytesPerRow = destWidth * bytesPerPixel
//            let destData = UnsafeMutablePointer<UInt8>.alloc(destHeight * destBytesPerRow)
//            defer {
//                destData.dealloc(destHeight * destBytesPerRow)
//            }
//            var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
//
//            // scale the image
//            error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
//            guard error == kvImageNoError else { return nil }
//
//            // create a CGImage from vImage_Buffer
//            let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
//            guard error == kvImageNoError else { return nil }
//
//            // create a UIImage
//            let resizedImage = destCGImage.flatMap { UIImage(CGImage: $0, scale: 0.0, orientation: self.imageOrientation) }
//            return resizedImage
        var error: vImage_Error

        // Create and initialize the source buffer
        guard let image = self.cgImage else { return self}
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             image,
                                             vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create and initialize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(size.height),
                                  vImagePixelCount(size.width),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        // Create a CGImage from the destination buffer
        guard let resizedImage =
                vImageCreateCGImageFromBuffer(&destinationBuffer,
                                              &format,
                                              nil,
                                              nil,
                                              vImage_Flags(kvImageNoAllocate),
                                              &error)?.takeRetainedValue(),
              error == kvImageNoError
        else {
            return nil
        }
        
        return UIImage(cgImage: resizedImage)
    }
    
    func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        // Decode the source image
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? vImagePixelCount,
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
        else {
            return nil
        }

        // Define the image format
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)

        var error: vImage_Error

        // Create and initialize the source buffer
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             image,
                                             vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        // Create and initialize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(size.height),
                                  vImagePixelCount(size.width),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }

        // Create a CGImage from the destination buffer
        guard let resizedImage =
            vImageCreateCGImageFromBuffer(&destinationBuffer,
                                          &format,
                                          nil,
                                          nil,
                                          vImage_Flags(kvImageNoAllocate),
                                          &error)?.takeRetainedValue(),
            error == kvImageNoError
        else {
            return nil
        }

        return UIImage(cgImage: resizedImage)
    }
}
