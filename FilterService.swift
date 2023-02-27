//
//  FilterService.swift
//  CameraFilter
//
//  Created by Erbay, Yagiz on 27.02.2023.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FiltersService {
    typealias FilterCallback = ((UIImage) -> ())
    private let context = CIContext()
    static let shared = FiltersService()
    
    func sendFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
}

extension FiltersService {
    private func applyFilter(to inputImage: UIImage, completion: @escaping FilterCallback) {
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter?.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgImg = self.context.createCGImage(filter?.outputImage ?? CIImage(),
                                                      from: filter?.outputImage?.extent ?? CGRect()) {
                
                let processedImage = UIImage(cgImage: cgImg,
                                             scale: inputImage.scale,
                                             orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
