//
//  ToDoTableViewCell.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import Foundation
import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(white: 0.8, alpha: 1)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        return label
    }()
    
    private let statusIndicator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 12 // Circle
        view.clipsToBounds = true
        return view
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true // Hidden by default
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black // Matches dark theme
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupViews() {
        contentView.addSubview(statusIndicator)
        contentView.addSubview(checkmarkView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Status indicator (circle)
            statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            statusIndicator.widthAnchor.constraint(equalToConstant: 24),
            statusIndicator.heightAnchor.constraint(equalToConstant: 24),
            
            // Checkmark inside the status indicator
            checkmarkView.centerXAnchor.constraint(equalTo: statusIndicator.centerXAnchor),
            checkmarkView.centerYAnchor.constraint(equalTo: statusIndicator.centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 16),
            checkmarkView.heightAnchor.constraint(equalToConstant: 16),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Date label
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(with todo: ToDo) {
        titleLabel.text = todo.todo

        
        titleLabel.attributedText = nil
        
        if todo.toDoDescription.isEmpty {
            descriptionLabel.text = "-"
        } else {
            descriptionLabel.text = todo.toDoDescription
        }
        
        dateLabel.text = formatDate(Date())
        
        if todo.completed {
            
            statusIndicator.layer.borderColor = UIColor.systemYellow.cgColor
            checkmarkView.isHidden = false
            titleLabel.textColor = UIColor(white: 0.8, alpha: 1)
            titleLabel.attributedText = NSAttributedString(
                string: todo.todo,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            statusIndicator.layer.borderColor = UIColor.gray.cgColor
            checkmarkView.isHidden = true
            titleLabel.textColor = .white
            titleLabel.text = todo.todo
        }
    }

    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    
    //to fix issues with updating tablewview and scrolling
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        checkmarkView.isHidden = true
        statusIndicator.layer.borderColor = UIColor.gray.cgColor
        titleLabel.textColor = .white
    }

}
