//
//  CustomImageView.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/9/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageUrl: String?
    
    func loadImage(_ urlString: String) {
        
        imageUrl = urlString
        
        self.image = UIImage(named: "placeholder")
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) {[weak self] _data, _response, _error in
            
            if _error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: _data ?? Data()) {
                    if self?.imageUrl == urlString {
                        self?.image = image
                    }
                    imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            
        }.resume()
        
    }
    
}
