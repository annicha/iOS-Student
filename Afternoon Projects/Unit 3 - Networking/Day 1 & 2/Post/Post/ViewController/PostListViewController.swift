//
//  PostListViewController.swift
//  Post
//
//  Created by Annicha on 13/5/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // because we manually added the tableview, we have to set the tableview's delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts{self.reloadTableView()}
        
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.timestamp)"
        return cell
    }
    
    
    // MARK: - Functions
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            self.reloadTableView()
        }
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            //we are now in the background thread
            //put this back to the main thread
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            //when fetched, update table view
            self.tableView.reloadData()

        }
    }
    
}


