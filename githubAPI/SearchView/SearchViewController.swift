//
//  SearchViewController.swift
//  githubAPI
//
//  Created by 정진균 on 2021/12/03.
//

import UIKit
import SnapKit
import RxSwift

class SearchViewController: UIViewController {
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        setUpStream()
    }
    
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .blue
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SearchViewCell.self, forCellReuseIdentifier: "SearchViewCell")
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = UITableView.automaticDimension
        return tv
    }()
    
    private var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.leading.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    func setUpStream() {
        searchBar.rx.text
            .orEmpty
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.searchBarRelay.accept(text)
                self?.viewModel.SearchGitHub()
            })
            .disposed(by: disposeBag)
        
        viewModel.searchResult
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                print("data = \(data)")
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult.value.login == "" ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("call")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as? SearchViewCell else {
            print("error")
            return UITableViewCell()
        }
        let url = URL(string: viewModel.searchResult.value.avatarUrl)!
        let data = try? Data(contentsOf: url)
        let image = UIImage(data: data!)
        cell.cellLabel.text = viewModel.searchResult.value.login
        cell.cellImage.image = image
        
        
                
        
        return cell
    }
    
    
}
