//
//  ViewController.swift
//  EndlessFibonacciTable
//
//  Created by Adam on 12/8/16.
//  Copyright © 2016 Adam Tecle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var data: [Int] = [0, 1]
    fileprivate var isRetrievingNumbers = false
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Set up
    
    private func setup() {
        configureTableView()
        loadData()
    }

    private func configureTableView() {
        tableView.register(LoadingCell.self, forCellReuseIdentifier: Constants.LoadingCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.LoadingCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Data
    
    fileprivate func loadData() {
        
        retrieveNextFibonacciNumbers { [unowned self] (sequence) in
            self.data.append(contentsOf: sequence)
            self.tableView.reloadData()
            self.isRetrievingNumbers = false
        }
        
        isRetrievingNumbers = true
    }
    
    private func retrieveNextFibonacciNumbers(_ completion: ((_ seq: [Int]) -> ())?) {
        
        // Gets 12 digits at a time
        
        let first = data[data.count - 1] + data[data.count - 2]
        let second = first + data[data.count - 1]
        var seq = [first, second]
        
        var i = 0
        while i < 10 {
            let next = seq[seq.count - 1] + seq[seq.count - 2]
            seq.append(next)
            i += 1
        }
        
        DispatchQueue.main.async {
            completion?(seq)
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            return
        }
        
        guard let loadingCell = cell as? LoadingCell else {
            return
        }
        
        loadingCell.startAnimating()
        
        if isRetrievingNumbers == false {
            loadData()
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? data.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCellIdentifier) else {
                let cell = UITableViewCell()
                cell.textLabel?.text = "\(data[indexPath.row])"
                return cell
            }
            
            cell.textLabel?.text = "\(data[indexPath.row])"

            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.LoadingCellIdentifier) as? LoadingCell
            
            guard let loadingCell = cell else {
                return LoadingCell()
            }
            
            return loadingCell
        }
        
    }
}

