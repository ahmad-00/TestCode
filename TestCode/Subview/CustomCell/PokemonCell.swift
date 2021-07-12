//
//  PokemonCell.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import UIKit

class PokemonCell: UITableViewCell {
    
    var pokomon: PokomonEntity? {
        didSet {
            if let poke = pokomon {
                self.pokoImageView.loadImage(poke.image)
                self.titleLabel.text = poke.name
            }
        }
    }
    
    private var pokoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        return iv
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        
        contentView.addSubview(pokoImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            pokoImageView.widthAnchor.constraint(equalToConstant: 80),
            pokoImageView.heightAnchor.constraint(equalToConstant: 80),
            pokoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: pokoImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
    }
    
}
