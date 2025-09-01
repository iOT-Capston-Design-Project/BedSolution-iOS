//
//  ImageCompression.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import Foundation

import UIKit

extension UIImage {
    func downscaled(maxDimension: CGFloat) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }
        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func jpegDataUnder(maxByte: Int, minQuality: CGFloat = 0.4) -> (Data, CGFloat)? {
        var low: CGFloat = minQuality
        var high: CGFloat = 1.0
        var bestData: Data?
        var bestQ: CGFloat = 1.0
        for _ in 0..<8 {
            let q = (low+high) / 2
            guard let data = jpegData(compressionQuality: q) else { break }
            if data.count > maxByte {
                high = q
            } else {
                bestData = data
                bestQ = q
                low = q
            }
        }
        return bestData.map { ($0, bestQ) }
    }
}
