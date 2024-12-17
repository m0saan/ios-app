//
//  CardscollectionView.swift
//  PHOTOAI
//
//  Created by zakar on 17/12/2024.
//
import UIKit
// MARK: - Header Collection View Cell
class HeaderCollectionViewCell: UITableViewCell {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let allButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See All", for: .normal)
        button.setTitleColor(UIColor(named: "main"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(ComparisonCollectionViewCell.self, forCellWithReuseIdentifier: "ComparisonCell")
        return cv
    }()

    private var navigationCallback: (() -> Void)?
    private var items: [(beforeImage: String, afterImage: String)] = []

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(allButton)
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            allButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            allButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: 300) // Adjust based on your needs
        ])

        allButton.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
    }

    // MARK: - Configuration
    func configure(title: String, items: [(String, String)], navigationCallback: @escaping () -> Void) {
        titleLabel.text = title
        self.items = items.map { (beforeImage: $0.0, afterImage: $0.1) }
        self.navigationCallback = navigationCallback
        collectionView.reloadData()
    }

    @objc private func allButtonTapped() {
        navigationCallback?()
    }
}

// MARK: - Collection View Delegate & DataSource
extension HeaderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComparisonCell", for: indexPath) as! ComparisonCollectionViewCell
        let item = items[indexPath.item]
        cell.configure(beforeImage: item.beforeImage, afterImage: item.afterImage)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.65, height: height) // Adjust aspect ratio as needed
    }
}

// MARK: - Collection View Cell for Image Comparison
class ComparisonCollectionViewCell: UICollectionViewCell {
    private let comparisonCard: ImageComparisonCard = {
        let card = ImageComparisonCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(comparisonCard)
        NSLayoutConstraint.activate([
            comparisonCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            comparisonCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            comparisonCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            comparisonCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Add rounded corners and shadow
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }

    func configure(beforeImage: String, afterImage: String) {
        comparisonCard.configure(beforeImage: beforeImage, afterImage: afterImage)
    }
}

// MARK: - All Images View Controller
class AllImagesViewController: UIViewController {
    // Implement your grid view of all images here
    // This is where the "All >" button will navigate to
}
