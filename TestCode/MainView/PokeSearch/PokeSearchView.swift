//
//  PokeSearchView.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/9/21.
//

import UIKit
import Combine

class PokeSearchView: UIViewController, UITableViewDelegate {
    
    private var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.backgroundColor = .clear
        sb.placeholder = "Search ..."
        return sb
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.rowHeight = 90
        return tv
    }()
    
    private var sortButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(SortType.None.rawValue, for: .normal)
        return btn
    }()
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    private var viewModel: PokeSearchVM
    private var cancelable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavTitle(.None)
    }
    
    init(viewModel: PokeSearchVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        viewModel.fetchPokomonList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.$navBarStatus.receive(on: DispatchQueue.main).sink { _result in
        } receiveValue: {[weak self] _value in
            self?.setNavTitle(_value)
        }.store(in: &cancelable)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        viewModel.configureDataSource(tableView: tableView)
        tableView.dataSource = viewModel.dataSource
        tableView.delegate = self
        
        sortButton.addTarget(viewModel, action: #selector(viewModel.sortButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(searchBar)
        view.addSubview(sortButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            sortButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            sortButton.heightAnchor.constraint(equalToConstant: 50),
            sortButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        viewModel.addSearchBarObserver(searchBar: searchBar)
        
        viewModel.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        viewModel.refreshControl.addTarget(viewModel, action: #selector(viewModel.refresh), for: .valueChanged)
        tableView.addSubview(viewModel.refreshControl)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !viewModel.isLoading){
            viewModel.fetchPokomonList()
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destView = DetailView(pokomon: viewModel.pokomons[indexPath.row])
        let navView = UINavigationController(rootViewController: destView)
        present(navView, animated: true, completion: nil)
        
        
        
        
//        destView.presentingVC = self
//        present(UIHostingController(rootView: destView), animated: true, completion: nil)
    }
    
    func setNavTitle(_ status: NavBarStatus) {
        
        switch status {
        case .None:
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationItem.title = "Pokomons"
            activityIndicator.stopAnimating()
        case .Loading:
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationItem.title = "Loading"
            let barButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.setRightBarButton(barButton, animated: true)
            activityIndicator.startAnimating()
        case .Error(let message):
            activityIndicator.stopAnimating()
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
            self.navigationItem.title = message
        }
        
        
    }
    
}
