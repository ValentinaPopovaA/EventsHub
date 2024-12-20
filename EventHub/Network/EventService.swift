//
//  EventService.swift
//  EventHub
//
//  Created by Валентина Попова on 22.11.2024.
//

import Foundation

final class EventService {
    private let networkService = NetworkService()
    
    func fetchEvents(
        actualSince: Int,
        actualUntil: Int,
        sortAscending: Bool = true,
        page: Int = 1,
        pageSize: Int = 150,
        location: String? = nil,
        category: String? = nil,
        fields: String? = nil,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let request = EventsRequest(
            actualSince: actualSince,
            actualUntil: actualUntil,
            page: page,
            pageSize: pageSize,
            location: location,
            category: category,
            fields: fields
        )
        
        networkService.request(request) { (result: Result<EventsResponse, Error>) in
            completion(result.map { response in
                response.results
                    .filter { event in
                        guard let validDates = event.dates?.compactMap({ $0.start }).filter({ $0 >= actualSince && $0 <= actualUntil }) else {
                            return false
                        }
                        return !validDates.isEmpty
                    }
                    .map { event in
                        var mutableEvent = event
                        mutableEvent.dates = event.dates?.filter { $0.start ?? 0 >= actualSince && $0.start ?? 0 <= actualUntil }
                        return mutableEvent
                    }
                    .sorted { event1, event2 in
                        if sortAscending {
                            // Сортировка по возрастанию для предстоящих событий
                            let date1 = event1.dates?.compactMap({ $0.start }).min() ?? 0
                            let date2 = event2.dates?.compactMap({ $0.start }).min() ?? 0
                            return date1 < date2
                        } else {
                            // Сортировка по убыванию для прошедших событий
                            let date1 = event1.dates?.compactMap({ $0.start }).max() ?? 0
                            let date2 = event2.dates?.compactMap({ $0.start }).max() ?? 0
                            return date1 > date2
                        }
                    }
            })
        }
    }

    func fetchEventDetails(eventID: Int, completion: @escaping (Result<Event, Error>) -> Void) {
        let request = EventDetailsRequest(eventID: eventID)
        networkService.request(request, completion: completion)
    }

    func fetchPlaceDetails(placeID: Int, completion: @escaping (Result<Place, Error>) -> Void) {
        let request = PlaceDetailsRequest(placeID: placeID)
        networkService.request(request, completion: completion)
    }
    
    // Получение Upcoming Events без указания местоположения
    func fetchUpcomingEvents(
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let actualSince = Int(Date().timeIntervalSince1970)
        let actualUntil = actualSince + 60 * 60 * 24 * 30 // Ближайшие 30 дней
        
        fetchEvents(
            actualSince: actualSince,
            actualUntil: actualUntil,
            sortAscending: true,
            page: 1,
            pageSize: 50,
            location: nil,
            category: nil,
            completion: completion
        )
    }
    
    // Получение Nearby Events по выбранному городу
    func fetchNearbyEvents(
        for citySlug: String,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let actualSince = Int(Date().timeIntervalSince1970)
        let actualUntil = actualSince + 60 * 60 * 24 * 30 // Так же на ближайшие 30 дней
        
        fetchEvents(
            actualSince: actualSince,
            actualUntil: actualUntil,
            sortAscending: true,
            page: 1,
            pageSize: 50,
            location: citySlug,
            category: nil,
            completion: completion
        )
    }
    
    // Получение событий по категории и городу
    func fetchEvents(
        for category: String,
        in citySlug: String?,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let actualSince = Int(Date().timeIntervalSince1970)
        let actualUntil = actualSince + 60 * 60 * 24 * 30
        
        fetchEvents(
            actualSince: actualSince,
            actualUntil: actualUntil,
            sortAscending: true,
            page: 1,
            pageSize: 50,
            location: citySlug,
            category: category,
            completion: completion
        )
    }
}

