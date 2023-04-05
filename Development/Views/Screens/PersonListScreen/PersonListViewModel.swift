//
//  ContactsViewModel.swift
//  ScorpHomeA.
//
//  Created by BEKIR TEK on 4.04.2023.
//

import Foundation

internal protocol PersonListViewModelInterface {
    var view: PersonListViewInterface? { get set }
    
    func viewDidLoad(initialRequest: Bool)
    func pulledDownReflesh(initialRequest: Bool)
    func scrolledToEnd(initialRequest: Bool)
    func cellForItem(at indexPath: IndexPath) -> Person
    func numberOfRows() -> Int
}

final class PersonListViewModel {
    
    weak var view: PersonListViewInterface?
    
    private var next: String?
    private var people = [Person]()
    
    private func getPeopleList(initialRequest: Bool) {
        view?.beginRefleshing()
        if initialRequest { self.next = nil ; self.people = [Person]() }
        
        DataSource.fetch(next: self.next) { [weak self] (fetchResponse, fetchError) in
            guard let self else { return }
            DebugManager.shared.debugStartOfRequest(initialRequest: initialRequest, fetchResponse: fetchResponse, people: self.people)
            if let fetchResponse = fetchResponse {
                if initialRequest && fetchResponse.people.count == 0 {
                    self.view?.noDataView(shouldShow: true)
                    self.view?.endRefleshing()
                } else {
                    self.view?.noDataView(shouldShow: false)
                    self.processPeopleList(fetchResponse: fetchResponse)
                    self.next = fetchResponse.next
                }
            } else if let fetchError = fetchError {
                DebugManager.shared.log("Request Error: \(fetchError.errorDescription)", signatureImage: "🛑", repeatCount: 2)
                self.getPeopleList(initialRequest: false)
                return
            }
        }
    }
    
     private func processPeopleList(fetchResponse: FetchResponse) {
        let newPeople = fetchResponse.people
        for newMember in newPeople {
            let isIdUnique = !people.contains(where: { $0.id == newMember.id } )
            if isIdUnique { people.append(newMember) }
            if !isIdUnique { DebugManager.shared.log("Sama ID detected for \(newMember.fullName)",signatureImage: "❗️", repeatCount: 2) }
        }
        DebugManager.shared.debugEndOfAdding(people: self.people)
        self.view?.reloadData()
        self.view?.endRefleshing()
    }
}

extension PersonListViewModel: PersonListViewModelInterface {
    
    func viewDidLoad(initialRequest: Bool) {
        DebugManager.shared.log("View Did Load", signatureImage: "🏈")
        view?.setupTableView()
        view?.setupRefleshControl()
        getPeopleList(initialRequest: initialRequest)
    }
    
    func cellForItem(at indexPath: IndexPath) -> Person {
        return people[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        return people.count
    }
    
    func pulledDownReflesh(initialRequest: Bool) {
        DebugManager.shared.log("Pulled Down to Reflesh", signatureImage: "🏈")
        getPeopleList(initialRequest: initialRequest)
    }
    
    func scrolledToEnd(initialRequest: Bool) {
        DebugManager.shared.log("Scrolled to End", signatureImage: "🏈")
        getPeopleList(initialRequest: initialRequest)
    }
}
