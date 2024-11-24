//
//  ExploreViewController.swift
//  EventHub
//
//  Created by Валентина Попова on 17.11.2024.
//

import UIKit

final class ExploreViewController: UIViewController, SearchBarDelegate {
    private var categories: [Category] = []
    private var selectedCategory: Int?
    
    private let blueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .blueBackground
        view.layer.cornerRadius = 33
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Current Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial", size: 14)
        button.alpha = 0.8
        button.setImage(UIImage(named: "Down"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bell"), for: .normal)
        button.backgroundColor = .blueForButtonExplore
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchBar: SearchBarView = {
        let searchBar = SearchBarView()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let filtersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filters", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AirbnbCereal_W_Bk", size: 12)
        button.setImage(UIImage(named: "Filter"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blueForButtonExplore
        button.layer.cornerRadius = 16
        button.semanticContentAttribute = .forceLeftToRight
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        return button
    }()
    
    private let cityLabel = UILabel.makeCustomLabel(text: "New York, USA",
                                                    font: UIFont(name: "Arial", size: 15) ?? .systemFont(ofSize: 15),
                                                    textColor: .white,
                                                    numberOfLines: 1,
                                                    textAligment: .center)
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 106, height: 40)
        layout.minimumLineSpacing = 11
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        return collectionView
    }()
    
    let button = CustomButton(title: "out", isBlue: true, fontSize: .med)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
        layoutViews()
        loadCategories()
        setupSavedCity()
        categoriesCollectionView.delegate = self
        currentLocationButton.addTarget(self, action: #selector(didTapChangeCity), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setViews() {
        view.addSubview(blueBackgroundView)
        view.addSubview(currentLocationButton)
        view.addSubview(cityLabel)
        view.addSubview(notificationButton)
        view.addSubview(searchBar)
        view.addSubview(filtersButton)
        view.addSubview(categoriesCollectionView)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            blueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            blueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blueBackgroundView.heightAnchor.constraint(equalToConstant: 200),
            
            currentLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            currentLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            cityLabel.topAnchor.constraint(equalTo: currentLocationButton.bottomAnchor, constant: 6),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            notificationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            notificationButton.heightAnchor.constraint(equalToConstant: 36),
            notificationButton.widthAnchor.constraint(equalToConstant: 36),
            
            searchBar.topAnchor.constraint(equalTo: cityLabel.topAnchor, constant: 25),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            searchBar.trailingAnchor.constraint(equalTo: filtersButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            filtersButton.topAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: 20),
            filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            filtersButton.heightAnchor.constraint(equalToConstant: 32),
            filtersButton.widthAnchor.constraint(equalToConstant: 80),
        
            categoriesCollectionView.topAnchor.constraint(equalTo: filtersButton.bottomAnchor, constant: 20),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func searchBarTextDidChange(_ searchText: String) {
        print("Search text changed: \(searchText)")
    }
    
    func searchBarDidCancel() {
        print("Search cancelled")
    }
    
    private func loadCategories() {
        CategoryProvider.shared.fetchCategoriesFromAPI { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCategories):
                    self?.categories = fetchedCategories
                    self?.categoriesCollectionView.reloadData()
                case .failure(let error):
                    print("Failed to load categories: \(error)")
                }
            }
        }
    }
    
    private func loadEvents(for citySlug: String) {
        let request = EventsByCityRequest(headers: [:], citySlug: citySlug)
        let networkService = NetworkService()
        networkService.request(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    print("Events for city \(citySlug): \(events)")
                case .failure(let error):
                    print("Failed to load events for city \(citySlug): \(error)")
                }
            }
        }
    }
    
    @objc private func didTapChangeCity() {
        let citySelectionVC = CitySelectionViewController()
        citySelectionVC.modalPresentationStyle = .overCurrentContext
        citySelectionVC.modalTransitionStyle = .crossDissolve
        citySelectionVC.onCitySelected = { [weak self] city in
            self?.cityLabel.text = city.name
            SelectedCityManager.saveSelectedCity(city)
            self?.loadEvents(for: city.slug)
        }
        present(citySelectionVC, animated: true)
    }
    
    private func setupSavedCity() {
        if let savedCity = SelectedCityManager.getSelectedCity() {
            cityLabel.text = savedCity.name
            loadEvents(for: savedCity.slug)
        } else {
            cityLabel.text = "Select a City"
        }
    }
}

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        let isSelected = (indexPath.item == selectedCategory)
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previouslySelectedIndex = selectedCategory
        selectedCategory = indexPath.item

        var indexesToReload: [IndexPath] = [indexPath]
        if let previousIndex = previouslySelectedIndex, previousIndex != indexPath.item {
            indexesToReload.append(IndexPath(item: previousIndex, section: 0))
        }
        collectionView.reloadItems(at: indexesToReload)

        print("Selected category: \(categories[indexPath.item].name)")
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        
        // Расчёт ширины текста
        let textWidth = category.name.size(withAttributes: [
            .font: UIFont(name: "AirbnbCereal_W_Bk", size: 15)!
        ]).width
        
        // Учитываем размер значка и отступы
        let iconWidth: CGFloat = 20
        let spacing: CGFloat = 6
        let padding: CGFloat = 16

        // Итоговая ширина ячейки
        let totalWidth = iconWidth + spacing + padding + textWidth
        
        return CGSize(width: max(106, totalWidth), height: 40)
    }
    

    @objc private func didTapLogout() {
            AuthService.shared.signOut { [weak self] error in
                guard let self = self else {return }
                if let error = error {
                    
                    return
                }
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }
}
