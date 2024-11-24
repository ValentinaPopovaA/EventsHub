//
//  EventsDetailViewController.swift
//  EventHub
//
//  Created by Валентина Попова on 17.11.2024.
//

import UIKit

class EventsDetailViewController: UIViewController {
    
    private let eventService = EventService()
    private let eventID: Int = 125725
    
    private var overlayView: UIView?
    private let shareView: ShareView = {
        let view = ShareView()
        view.contentMode = .bottom
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "eventsDetail")
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bookmark_white"), for: .normal)
        button.setImage(UIImage(named: "Bookmark_red"), for: .selected)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveToFavorites), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share icon"), for: .normal)
        button.addTarget(self, action: #selector(sharePressedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var eventLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 35)
        label.text = "International Band Music Concert"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayForDetail
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dateIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Calendar_blue")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "14 December, 2021"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 12)
        label.text = "Tuesday, 4:00PM - 9:00PM"
        label.textColor = .subColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayForDetail
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var locationIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Location")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Gala Convention Center"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var adressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 12)
        label.text = "36 Guild Street London, UK"
        label.textColor = .subColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var photoIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image 70")
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 15)
        label.text = "Ashfak Sayem"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var organizerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 12)
        label.text = "Organizer"
        label.textColor = .subColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var aboutEventsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "About Event"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AirbnbCereal_W_Bk", size: 16)
        label.text = "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More...Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. Read More..."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraits()
        makeAttributedText()
        shareView.isHidden = true
        shareView.delegate = self
        loadEventDetails(eventID: eventID)
    }
    
    func configure(with event: Event) {
        // Название события
        eventLabel.text = event.title.capitalized
        
        // Краткое описание
        descriptionLabel.text = event.bodyText?.htmlToString() ?? "Description not available"
        
        // Загрузка информации о месте
        if let placeID = event.place?.id {
            loadPlaceDetails(placeID: placeID)
        } else {
            locationLabel.text = "Location not available"
            adressLabel.text = "Address not available"
        }
        
        // Даты и время проведения
        if let firstDate = event.dates?.first {
            // Отображение даты
            dateLabel.text = firstDate.start?.formattedDate() ?? "Date not available"
            
            // Форматирование времени
            let startTimeWithWeekday = firstDate.start?.formattedTimeWithWeekday() ?? "Start time not available"
            let startTime = firstDate.start?.formattedTime() ?? "Start time not available"
            let endTime = firstDate.end?.formattedTime() ?? "End time not available"
            
            // Если время начала и окончания одинаковое
            if startTime == endTime {
                timeLabel.text = startTimeWithWeekday
            } else {
                timeLabel.text = "\(startTimeWithWeekday) - \(endTime)"
            }
        } else {
            dateLabel.text = "Date not available"
            timeLabel.text = ""
        }
        
        // Картинка события
        if let imageUrl = event.images?.first?.image {
            imageView.loadImage(from: imageUrl)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        
        // Организатор
        if let participant = event.participants?.first?.agent.title {
            nameLabel.text = participant
        } else {
            nameLabel.text = "Unknown"
        }
    }
    
    private func configurePlaceUI(with place: Place) {
        locationLabel.text = place.title ?? "Unknown location"
        adressLabel.text = "\(place.address!), \(place.cityName(for: place.location!))"
    }
    
    private func loadEventDetails(eventID: Int) {
        eventService.fetchEventDetails(eventID: eventID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let event):
                    self?.configure(with: event)
                case .failure(let error):
                    print("Error loading event details: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadPlaceDetails(placeID: Int) {
        eventService.fetchPlaceDetails(placeID: placeID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let place):
                    self?.configurePlaceUI(with: place)
                case .failure(let error):
                    print("Error loading place details: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func makeAttributedText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributedString = NSMutableAttributedString(string: descriptionLabel.text ?? "")
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        descriptionLabel.attributedText = attributedString
        descriptionLabel.textAlignment = .justified
    }
    
    @objc private func saveToFavorites(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc private func sharePressedButton(_ sender: UIButton) {
        shareView.isHidden = false
        shareButton.isHidden.toggle()
        // Создаем затемняющий слой
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isUserInteractionEnabled = true
        view.addSubview(overlay)
        self.overlayView = overlay

        // Настраиваем Auto Layout для overlay
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Добавляем ShareView поверх overlay
        view.addSubview(shareView)
        NSLayoutConstraint.activate([
            shareView.heightAnchor.constraint(equalToConstant: 370),
            shareView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shareView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shareView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1
            self.shareView.transform = .identity
        }
    }
        
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        
        imageView.addSubview(saveButton)
        imageView.addSubview(shareButton)
        view.addSubview(scrollView)
        scrollView.addSubview(eventLabel)
        
        scrollView.addSubview(dateView)
        dateView.addSubview(dateIcon)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(timeLabel)
        
        scrollView.addSubview(locationView)
        locationView.addSubview(locationIcon)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(adressLabel)
        
        scrollView.addSubview(photoIcon)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(organizerLabel)
        scrollView.addSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(aboutEventsLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        view.addSubview(shareView)
        
    }
    
    private func makeConstraits() {
        let scrollContentGuide = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 244),
            
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: -10),
            saveButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            saveButton.heightAnchor.constraint(equalToConstant: 36),
            saveButton.widthAnchor.constraint(equalToConstant: 36),
            
            shareButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5),
            shareButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            shareButton.heightAnchor.constraint(equalToConstant: 36),
            shareButton.widthAnchor.constraint(equalToConstant: 36),
            
            scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            eventLabel.topAnchor.constraint(equalTo: scrollContentGuide.topAnchor, constant: 15),
            eventLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            eventLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 20),
            
            dateView.topAnchor.constraint(equalToSystemSpacingBelow: eventLabel.bottomAnchor, multiplier: 2),
            dateView.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 20),
            dateView.heightAnchor.constraint(equalToConstant: 48),
            dateView.widthAnchor.constraint(equalToConstant: 48),
            
            dateIcon.centerYAnchor.constraint(equalTo: dateView.centerYAnchor),
            dateIcon.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalToSystemSpacingBelow: eventLabel.bottomAnchor, multiplier: 2),
            dateLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalToSystemSpacingBelow: dateLabel.bottomAnchor, multiplier: 1),
            timeLabel.leadingAnchor.constraint(equalTo: dateView.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            
            locationView.topAnchor.constraint(equalToSystemSpacingBelow: dateView.bottomAnchor, multiplier: 2),
            locationView.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 20),
            locationView.heightAnchor.constraint(equalToConstant: 48),
            locationView.widthAnchor.constraint(equalToConstant: 48),
            
            locationIcon.centerYAnchor.constraint(equalTo: locationView.centerYAnchor),
            locationIcon.centerXAnchor.constraint(equalTo: locationView.centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 24),
            locationLabel.leadingAnchor.constraint(equalTo: locationView.trailingAnchor, constant: 10),
            locationLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            
            adressLabel.topAnchor.constraint(equalToSystemSpacingBelow: locationLabel.bottomAnchor, multiplier: 1),
            adressLabel.leadingAnchor.constraint(equalTo: locationView.trailingAnchor, constant: 10),
            adressLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            
            photoIcon.topAnchor.constraint(equalToSystemSpacingBelow: locationView.bottomAnchor, multiplier: 2),
            photoIcon.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 20),
            photoIcon.heightAnchor.constraint(equalToConstant: 48),
            photoIcon.widthAnchor.constraint(equalToConstant: 48),
            
            nameLabel.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: photoIcon.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            
            organizerLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            organizerLabel.leadingAnchor.constraint(equalTo: photoIcon.trailingAnchor, constant: 10),
            organizerLabel.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            
            descriptionStackView.topAnchor.constraint(equalTo: photoIcon.bottomAnchor, constant: 24),
            descriptionStackView.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 20),
            descriptionStackView.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -20),
            descriptionStackView.bottomAnchor.constraint(equalTo: scrollContentGuide.bottomAnchor),
            
            shareView.bottomAnchor.constraint(equalTo:view.bottomAnchor),
            shareView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shareView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shareView.heightAnchor.constraint(equalToConstant: 370)
        ])
    }
}

extension EventsDetailViewController: ShareViewDelegate {
    // Скрытие ShareView и overlay
    @objc func dismissOverlay() {
        shareButton.isHidden = false
        if let overlayView = overlayView {
            dismissShareView(overlayView: overlayView)
        }
    }
    private func dismissShareView(overlayView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            overlayView.alpha = 0
            self.shareView.transform = CGAffineTransform(translationX: 0, y: 350)
        }) { _ in
            overlayView.removeFromSuperview()
            self.overlayView = nil
        }
    }
}

