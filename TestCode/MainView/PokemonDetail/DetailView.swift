//
//  DetailView.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/9/21.
//



import UIKit


class DetailView: UIViewController {
    
    var pokomon: PokomonEntity
    
    private let pokomonIV: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 100
        iv.clipsToBounds = true
        return iv
    }()
    
    private var detailHolderView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private var abilityTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .gray
        return lbl
    }()
    
    private var abilityLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textColor = .black
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(pokomon: PokomonEntity) {
        self.pokomon = pokomon
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        pokomonIV.loadImage(pokomon.image)
        nameLbl.text = pokomon.name
        abilityTitleLbl.text = "Abilities: "
        abilityLbl.text = pokomon.ability
        
        view.addSubview(pokomonIV)
        view.addSubview(detailHolderView)
        detailHolderView.addSubview(nameLbl)
        detailHolderView.addSubview(abilityTitleLbl)
        detailHolderView.addSubview(abilityLbl)
        
        NSLayoutConstraint.activate([
            pokomonIV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            pokomonIV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokomonIV.widthAnchor.constraint(equalToConstant: 200),
            pokomonIV.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            detailHolderView.topAnchor.constraint(equalTo: pokomonIV.bottomAnchor, constant: 25),
            detailHolderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailHolderView.widthAnchor.constraint(equalToConstant: 280),
            detailHolderView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            nameLbl.widthAnchor.constraint(lessThanOrEqualTo: detailHolderView.widthAnchor),
            nameLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            nameLbl.centerXAnchor.constraint(equalTo: detailHolderView.centerXAnchor),
            nameLbl.topAnchor.constraint(equalTo: detailHolderView.topAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            abilityTitleLbl.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            abilityTitleLbl.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            abilityTitleLbl.leadingAnchor.constraint(equalTo: detailHolderView.leadingAnchor, constant: 12),
            abilityTitleLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            abilityLbl.leadingAnchor.constraint(equalTo: abilityTitleLbl.trailingAnchor, constant: 8),
            abilityLbl.trailingAnchor.constraint(equalTo: detailHolderView.trailingAnchor, constant: -12),
            abilityLbl.heightAnchor.constraint(equalTo: abilityTitleLbl.heightAnchor),
            abilityLbl.topAnchor.constraint(equalTo: abilityTitleLbl.topAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(backButtonAction))
        
        title = "Details"
        
    }
    
    @objc private func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
