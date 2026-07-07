import Foundation

struct Entry: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var location: String
    var flights: String
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), location: String = "", flights: String = "", notes: String = "") {
        self.id = id
        self.date = date
        self.location = location
        self.flights = flights
        self.notes = notes
    }
}
