//
//  UserView.swift
//  Assignment Allianz
//
//  Created by Firman Aminuddin on 3/18/22.
//

import UIKit

protocol ProtView {
    var presenter : ProtPresenter? {get set}
    
    func updateData(with users: User)
    func updateError(error: String)
    func loadMoreData()
}

class UserView : UIViewController, ProtView, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate{
    
    // MARK: - Properties
    
    var presenter : ProtPresenter?
    private let searchBar = UISearchBar()
    private var userList : [UserItems] = []
    private var countPage = 1
    private let maxPage = 30
    private var currentSearchText = ""
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        table.isHidden = true
        return table
    }()
    
    private let label : UILabel = {
        let labelSet = UILabel()
        labelSet.textAlignment = .center
        labelSet.isHidden = true
        return labelSet
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Press Enter to search github user"
        searchBar.autocapitalizationType = .none
        searchBar.showsScopeBar = true
        navigationItem.titleView = searchBar
        setupTableview()
    }
    
    func setupTableview(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    // MARK: - Data Setup
    
    func updateData(with users: User) {
        DispatchQueue.main.async {
            print("response list user: \(users)")
            
            self.userList = self.userList + users.items
            print("count list = \(self.userList.count)")
            self.tableView.reloadData()
            self.tableView.isHidden = false
            spinnerTable.stopAnimating()
            if(self.userList.count == 0){
                Show.SimpleAlert(root: self, title: "", message: "Search not found", buttonText: "Close")
            }
        }
    }
    
    func updateError(error: String) {
        DispatchQueue.main.async {
            self.userList = []
            Show.SimpleAlert(root: self, title: "", message: error, buttonText: "Close")
        }
    }
    
    // MARK: - Action

    func loadMoreData(){
        checkLastPage()
    }
    
    func checkLastPage(){
        print("countpage : \(countPage)")
        countPage += 1
        let searchURL = "q=\(currentSearchText)&per_page=\(maxPage)&page=\(countPage)"
        presenter?.getUserWithQuery(query: searchURL)
    }
    
    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userList[indexPath.row].login

        UserPresenter.downloadImage(userList[indexPath.row].avatar_url) { image in
            if let image = image {
                DispatchQueue.main.async {
                    cell.imageView!.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == userList.count{
            print("bottom of the page")
            spinnerTable.startAnimating()
            spinnerTable.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinnerTable
            tableView.tableFooterView?.isHidden = false
            
            if(userList.count >= 30){
                presenter?.alertWithAction(vc: self, errorMsg: "Load more data?", title: "")
            }else{
                spinnerTable.stopAnimating()
            }
        }
    }
}

// MARK: - Search Bar
extension UserView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
        currentSearchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Enter button pressed, search starting")
        userList = []
        countPage = 0
        checkLastPage()
    }
}
