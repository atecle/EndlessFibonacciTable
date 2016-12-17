//
//  LoadingCell.swift
//  EndlessFibonacciTable
//
//  Created by Adam on 12/8/16.
//  Copyright © 2016 Adam Tecle. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    private var activityIndicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Public
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Set up
    
    private func setup() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        
        let top = NSLayoutConstraint(item: activityIndicator, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: activityIndicator, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: activityIndicator, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: activityIndicator, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        
        contentView.addConstraints([top, bottom, leading, trailing])
    }

}
