import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [RoomNoteEntry] = []
    @Published var settings: AppSettings = AppSettings()

    /// Free tier allows this many entries. Kept comfortably above seed data
    /// so a fresh install never trips the paywall immediately.
    static let freeEntryLimit = 12

    private let fileURL: URL
    private let settingsURL: URL

    init() {
        let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: supportDir, withIntermediateDirectories: true)
        fileURL = supportDir.appendingPathComponent("rentalhandofflog_entries.json")
        settingsURL = supportDir.appendingPathComponent("rentalhandofflog_settings.json")
        load()
    }

    var isAtFreeLimit: Bool {
        entries.count >= Store.freeEntryLimit
    }

    func canAdd(isPro: Bool) -> Bool {
        isPro || entries.count < Store.freeEntryLimit
    }

    func add(_ entry: RoomNoteEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: RoomNoteEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: RoomNoteEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func seedIfNeeded() {
        guard entries.isEmpty else { return }
        entries = [
        RoomNoteEntry(roomName: "Living Room", condition: "Good - minor scuff on wall", notes: "Move-in 2025-01-01"),
        RoomNoteEntry(roomName: "Kitchen", condition: "Excellent", notes: "Move-in 2025-01-01")
        ]
        save()
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([RoomNoteEntry].self, from: data) {
            entries = decoded
        }
        seedIfNeeded()
        if let data = try? Data(contentsOf: settingsURL),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            try? data.write(to: settingsURL, options: .atomic)
        }
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var compactList: Bool = false
    var showNotesInline: Bool = true
}
