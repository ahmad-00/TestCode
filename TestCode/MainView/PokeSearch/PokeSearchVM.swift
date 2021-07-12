//
//  PokeSearchVM.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import UIKit
import Combine
import CoreData

typealias PokomonDataSource = UITableViewDiffableDataSource<PokeSearchVM.Section, PokomonEntity>
typealias PokomonSnapshot = NSDiffableDataSourceSnapshot<PokeSearchVM.Section, PokomonEntity>

enum SortType: String {
    case None = "Default Sort"
    case Name = "Sorted by Name"
    case id = "Sorted By Id"
}

class PokeSearchVM: ObservableObject {
    
    @Published var isLoading = false
    @Published var navBarStatus: NavBarStatus = NavBarStatus.None
    
    var pokomons: [PokomonEntity] = []
    var dataSource : PokomonDataSource!
    private var tableCellIdentifier = "tableCellIdentifier"

    private var cancelable = Set<AnyCancellable>()
    
    let refreshControl = UIRefreshControl()
    
    private var sortType = SortType.None {
        didSet {
            currentOffset = 0
            updatePokomonsOnTable()
        }
    }
    
    private let limit = 20
    private var currentOffset = 0
    
    func fetchPokomonList() {
        
        isLoading = true
        navBarStatus = .Loading
        NetworkManager
            .shared
            .getPokomonList(offset: currentOffset, limit: limit)
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .receive(on: DispatchQueue.main)
            .flatMap({ _pokomonResponse -> AnyPublisher<PokomonDetail, ApiError> in
                
                let detailRequests = _pokomonResponse.results!.map{NetworkManager.shared.getPokomonDetail(url: $0.url!)}
                
                return Publishers
                    .MergeMany(detailRequests)
                    .eraseToAnyPublisher()
            })
            .flatMap({[weak self] _detail in
                return self!.saveToDB(_detail)
            })
            .sink {[weak self] _result in
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                switch _result {
                case .finished:
                    self?.currentOffset += self?.limit ?? 0
                    self?.navBarStatus = .None
                    break
                case .failure(let error):
                    self?.navBarStatus = .Error(message: error.localizedDescription)
                    break
                }
                
            } receiveValue: {(_) in
            }
            .store(in: &cancelable)
        

    }

    func configureDataSource(tableView: UITableView) {
        tableView.register(PokemonCell.self, forCellReuseIdentifier: tableCellIdentifier)
        
        dataSource = PokomonDataSource(tableView: tableView, cellProvider: {[weak self] _tableView, _indexPath, _pokomon in
            
            guard let sSelf = self else {return nil}
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sSelf.tableCellIdentifier, for: _indexPath) as? PokemonCell else {
                return nil
            }
            cell.pokomon = _pokomon
            return cell
        })
        updatePokomonsOnTable()
    }
    
    private func saveToDB(_ detail: PokomonDetail) -> Future<Void, Never> {
        
        return Future {[weak self] promise in
            
            let newPokomon = PokomonEntity(context: PersistenceManager.shared.context)
            newPokomon.id = Int32(detail.id ?? 0)
            newPokomon.name = detail.name ?? ""
            newPokomon.image = detail.sprites?.other?.officialArtwork?.frontDefault ?? ""
            newPokomon.ability = (detail.abilities ?? []).map{ $0.ability?.name ?? "" }.joined(separator: ",")
            
            do {
                try PersistenceManager.shared.context.save()
                self?.updatePokomonsOnTable()
                promise(.success(()))
            } catch {
              // Show error
                self?.navBarStatus = .Error(message: "Something went wrong !")
                PersistenceManager.shared.context.rollback()
            }
        }
        
    }
    
    private func updatePokomonsOnTable(searchFilter: String? = nil){
        
        var pokomonsFromDB: [PokomonEntity] = []
        
        var sortDescriptor : NSSortDescriptor?
        switch sortType {
        case .None:
            break
        case .Name:
            sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            break
        case .id:
            sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            break
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"PokomonEntity")
        fetchRequest.fetchLimit = limit + currentOffset
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        
        
        if searchFilter != nil && searchFilter != "" {
            
            let predicate = NSCompoundPredicate(type: .or, subpredicates: [
                NSPredicate(format: "id CONTAINS[c] %@", searchFilter!),
                NSPredicate(format: "name CONTAINS[c] %@", searchFilter!),
                NSPredicate(format: "ability CONTAINS[c] %@", searchFilter!)
            ])
            
            fetchRequest.predicate = predicate
            
            guard let data = try? PersistenceManager.shared.context.fetch(fetchRequest) as? [PokomonEntity] else {
                return
            }
            
            pokomonsFromDB = data
            
        } else {
            
            guard let data = try? PersistenceManager.shared.context.fetch(fetchRequest) as? [PokomonEntity] else {
                return
            }
            
            pokomonsFromDB = data
            
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.pokomons = pokomonsFromDB
            var snapshot = PokomonSnapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(pokomonsFromDB)
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
    
    func addSearchBarObserver(searchBar: UISearchBar) {
        
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
        
        publisher.debounce(for: 0.5, scheduler: DispatchQueue.main).sink {[weak self] _searchText in
            self?.updatePokomonsOnTable(searchFilter: (_searchText.object as? UISearchTextField)?.text)
            
        }.store(in: &cancelable)
    }
    
    
    @objc func refresh() {
        currentOffset = 0
        fetchPokomonList()
    }
    
    @objc func sortButtonAction(_ sender: UIButton) {
        switch sortType {
        case .None:
            sortType = .Name
            break
        case .Name:
            sortType = .id
            break
        case .id:
            sortType = .None
            break
        }
        sender.setTitle(sortType.rawValue, for: .normal)
    }
    
    enum Section {
        case main
    }
    
}

