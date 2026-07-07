import Foundation

struct RoomNoteEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var roomName: String
    var condition: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), roomName: String = "", condition: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.roomName = roomName
        self.condition = condition
        self.notes = notes
    }
}
