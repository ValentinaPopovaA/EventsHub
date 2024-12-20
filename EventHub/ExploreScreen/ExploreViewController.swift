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
    private var upcomingEvents: [Event] = []
    private var nearbyEvents: [Event] = []
    private var slug: Place?
    private let eventService = EventService()
    
    private let buttonsView: ButtonsView = {
        let view = ButtonsView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let exploreView: ExploreView = {
        let view = ExploreView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
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
        button.addTarget(self, action: #selector(openNotificationsView), for: .touchUpInside)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
        layoutViews()
        loadCategories()
        setupSavedCity()
        categoriesCollectionView.delegate = self
        exploreView.parentViewController = self
        currentLocationButton.addTarget(self, action: #selector(didTapChangeCity), for: .touchUpInside)
        buttonsView.delegate = self
        exploreView.collectionView.delegate = self
        fetchAndDisplayUpcomingEvents()
        fetchAndDisplayNearbyEvents()
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
        view.addSubview(buttonsView)
        view.addSubview(exploreView)
        
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
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor,constant: 24),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            buttonsView.bottomAnchor.constraint(equalTo: exploreView.topAnchor, constant: -14),
            buttonsView.heightAnchor.constraint(equalToConstant: 38),
            
            exploreView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor,constant: 14),
            exploreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exploreView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exploreView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    private func fetchAndDisplayUpcomingEvents() {
        eventService.fetchUpcomingEvents { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self?.upcomingEvents = events
                    self?.exploreView.updateUpcomingEvents(events)
                case .failure(let error):
                    print("Ошибка загрузки предстоящих событий: \(error)")
                }
            }
        }
    }
    
    private func fetchAndDisplayNearbyEvents() {
        guard let selectedCity = SelectedCityManager.getSelectedCity() else {
            return
        }
        eventService.fetchNearbyEvents(for: selectedCity.slug) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self?.nearbyEvents = events
                    self?.exploreView.updateNearbyEvents(events)
                case .failure(let error):
                    print("Ошибка загрузки предстоящих событий: \(error)")
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadVisibleCells()
        reloadVisibleCell()
    }
    
    private func reloadVisibleCells() {
        let visibleIndexPaths = exploreView.collectionView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
            guard let cell = exploreView.collectionView.cellForItem(at: indexPath) as? UpcomingEventsCell else { continue }
            let event = upcomingEvents[indexPath.item]
            cell.configure(with: event)
        }
    }
    private func reloadVisibleCell() {
        let visibleIndexPaths = exploreView.collectionView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
            guard let cell = exploreView.collectionView.cellForItem(at: indexPath) as? NearbyEventsCell else { continue }
            let event = nearbyEvents[indexPath.item]
            cell.configure(with: event)
        }
    }
    func searchBarTextDidChange(_ searchText: String) {
        print("Search text changed: \(searchText)")
    }
    
    func searchBarDidCancel() {
        print("Search cancelled")
    }
    @objc private func openNotificationsView() {
        let noNotificationsVC = NoNotificationsViewController()
        noNotificationsVC.modalPresentationStyle = .fullScreen
        present(noNotificationsVC, animated: true)
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
            self?.fetchAndDisplayNearbyEvents()
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
    
    func searchBarDidSearch(_ searchText: String) {
        let searchVC = SearchViewController()
        searchVC.initialQuery = searchText
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
    
    private func navigateToEventDetail(with event: Event) {
        let detailVC = EventsDetailViewController(event: event, segment: .upcoming)
        detailVC.modalPresentationStyle = .fullScreen
       present(detailVC, animated: true)
        
    }
    
    private func filterEvents(by category: Category) {
           let categorySlug = category.slug
           let citySlug = SelectedCityManager.getSelectedCity()?.slug
           
           eventService.fetchEvents(for: categorySlug, in: citySlug) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let events):
                       self?.upcomingEvents = events
                       self?.exploreView.updateUpcomingEvents(events)
                   case .failure(let error):
                       print("Failed to fetch events for category \(category.name): \(error)")
                   }
               }
           }
           
           eventService.fetchEvents(for: categorySlug, in: citySlug) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let events):
                       self?.nearbyEvents = events
                       self?.exploreView.updateNearbyEvents(events)
                   case .failure(let error):
                       print("Failed to fetch events for category \(category.name): \(error)")
                   }
               }
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
        if collectionView == categoriesCollectionView {
            let previouslySelectedIndex = selectedCategory
            selectedCategory = indexPath.item
            
            var indexesToReload: [IndexPath] = [indexPath]
            if let previousIndex = previouslySelectedIndex, previousIndex != indexPath.item {
                indexesToReload.append(IndexPath(item: previousIndex, section: 0))
            }
            categoriesCollectionView.reloadItems(at: indexesToReload)
            
            let selectedCategory = categories[indexPath.item]
            filterEvents(by: selectedCategory)
        } else if collectionView == exploreView.collectionView {
            guard let sectionType = Section(rawValue: indexPath.section) else {
                return
            }
            
            let selectedEvent: Event
            switch sectionType {
            case .upcomingCollection:
                guard indexPath.item < upcomingEvents.count else { return }
                selectedEvent = upcomingEvents[indexPath.item]
            case .nearbyCollection:
                guard indexPath.item < nearbyEvents.count else { return }
                selectedEvent = nearbyEvents[indexPath.item]
            }
            
            navigateToEventDetail(with: selectedEvent)
        }
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

extension ExploreViewController: ButtonsViewDelegate {
    @objc func todayButtonTapped() {
        print("1")
    }
    
    @objc func filmsButtonTapped() {
        print("2")
    }
    
    @objc func listsButtonTapped() {
        print("3")
    }
    
}
