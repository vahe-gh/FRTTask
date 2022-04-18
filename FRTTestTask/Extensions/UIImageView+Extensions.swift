//
//  UIImageView+Extensions.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import UIKit

extension UIImageView {
    
    func load(fromURL url: URL?, placeholder: String?) {
        DispatchQueue.global().async { [weak self] in
            var image: UIImage?
            if let url = url,
                    let data = try? Data(contentsOf: url),
                    let imageFromData = UIImage(data: data) {
                image = imageFromData
            } else if let placeholder = placeholder {
                image = UIImage(named: placeholder)
            }
            
            if let image = image {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
    
}
