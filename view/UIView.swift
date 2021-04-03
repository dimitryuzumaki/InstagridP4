//
//  UIView.swift
//  Instagrid
//
//  Created by Dimitry Aumont on 28/03/2021.
//

import Foundation
import UIKit


extension UIView {
    
    func asImage() -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }
}
