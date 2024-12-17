//
//  Homevc.swift
//  PHOTOAI
//
//  Created by loki on 16/12/2024.
//

import UIKit
import SDWebImage
import AVKit

class CarouselViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView!
    private let carouselCellId = "CarouselCell"
    private let regularCellId = "RegularCell"
    private let carouselItemCellId = "CarouselItemCell"
    
    private let gifs = [
        "preview",
        "preview",
        "preview",
    ]
    
    private let texts = ["Change Your Look", "Instant Face Fix", ""]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        let backgroundView = AIGlassmorphismBackground()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundView, at: 0)
        backgroundView.isHidden = true
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupTableView()
//        edgesForExtendedLayout = .all
//        navigationController?.navigationBar.isTranslucent = true
//        modalPresentationStyle = .overFullScreen
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: InputTableViewCell.identifier)
        tableView.register(HeaderCollectionViewCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.register(ImagesTableViewCell.self, forCellReuseIdentifier: ImagesTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: regularCellId)
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CarouselViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // Adjust based on your needs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: InputTableViewCell.identifier, for: indexPath) as! InputTableViewCell
            cell.configure(
                placeholder: """
Enter a prompt to generate an image.

Tips:
- Be specific (e.g., "sunset over mountains").
- Include details like colors or objects.
""",
                buttonTitle: "Generate Image",
                buttonAction: { [weak self] in
                    // Handle button tap
                    if let text = cell.getText() {
                        print("Submitted text: \(text)")
                    }
                }
            )
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesTableViewCell.identifier, for: indexPath) as! ImagesTableViewCell

            // Configure with your images
            let images = [
                "https://cdn.midjourney.com/d54082b7-2f05-4765-8b75-a27d2521dfc6/0_0.png",
                "https://cdn.midjourney.com/1f1ac077-df00-41ae-acdb-bcd3eb5b1cd0/0_3.png",
                "https://cdn.midjourney.com/3adf8066-141d-4d6e-a5d2-d000c79570be/0_1.png",
                "https://cdn.midjourney.com/51eef6fc-2975-468f-a73d-b4f27dd89835/0_0.png"
            ].compactMap { $0 }

            cell.configure(with: images, title: "Kids")
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCollectionViewCell

            // Configure with your images
            let items = [
                ("https://replicate.delivery/pbxt/KDMkjS4SpsGieAxMdkBUNWT5zFI8BvAU4XjiyI2xmLny3skZ/Buffalo%20Bank%20Buffalo,%20New%20York,%20circa%201908.%20Erie%20County%20Savings%20Bank,%20Niagara%20Street.jpg", "https://replicate.delivery/pbxt/ZumJoHeMlA0WVyesmCZlkoKtNPakny5ariWAaXR3aEhvflXkA/out.png"),
                ("https://replicate.delivery/pbxt/LKXd5RrqR3YITx6LYu6HFOIHgQl8EdHZV2qQcLhPoI4deTpO/f84e7869-32ca-444b-a720-19e4325f4347.jpg","https://replicate.delivery/pbxt/uVYXPohfE3U5WC67kSr4TahCjwuu1hJJZz3f633PfMwQtDYmA/output.jpg"),
                ("https://replicate.delivery/pbxt/K2gjWl0c5hGCKrNBj2xyJpt7QhOpwNpYXfJ4pnJS56RoN1KK/4904b1be-61dc-4ef0-916b-2f33b2ca953a.webp","https://replicate.delivery/pbxt/7eGrkbFfBKnULU3ubOrjfqCFeyqhdQCr9VEiKAS2159fhOiZC/output.jpg"),
            ]

            cell.configure(title: "LinkedIn", items: items) { [weak self] in
                // Handle navigation to AllImagesViewController
                let allImagesVC = AllImagesViewController()
                self?.navigationController?.pushViewController(allImagesVC, animated: true)
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCollectionViewCell

            // Configure with your images
            let items = [
                ("before","after"),
                ("https://replicate.delivery/pbxt/KU1AG0cit5nc3xIG1BBZ6DKkhunvvGsZXmEZzuW9HPYVkj8o/MTk4MTczMTkzNzI1Mjg5NjYy.webp", "https://replicate.delivery/xezq/GYZ115u3skagJdL7xC3PjthXhR4yNGHrSPO8YOyJtGtxEY9E/ComfyUI_00001_.png"),
                ("https://replicate.delivery/pbxt/KU26einXlg9brDfulWW8b5D4DVQzoqFony2KQDrW0JTNqne7/download.jpg", "https://replicate.delivery/pbxt/iRu4aUq6wDZlExiRDYif1OdZdAQc2p5NDHjwxqJnmeLmgRbSA/ComfyUI_00001_.png"),
                ("https://replicate.delivery/pbxt/KU2Lw4JnWQyGYbOsnwrpVQ1PAeeF2FsgeCNQGu8EEY7LRwBy/out-0-1.png","https://replicate.delivery/pbxt/0nusMxqZYQpRNFMTHHPCFkVIE0W4xC84PAgBHLOee9OnsRbSA/ComfyUI_00001_.png")
                // Add more items as needed
            ]

            cell.configure(title: "Transformation", items: items) { [weak self] in
                // Handle navigation to AllImagesViewController
                let allImagesVC = AllImagesViewController()
                self?.navigationController?.pushViewController(allImagesVC, animated: true)
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 350
        case 1,3:
            return 250
        default:
            return 170
        }
    }
}
