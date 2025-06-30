import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameResult) -> Bool {
        let currentAccuracy = total == 0 ? 0 : Double(correct) / Double(total)
        let otherAccuracy = another.total == 0 ? 0 : Double(another.correct) / Double(another.total)
        return currentAccuracy > otherAccuracy
    }
}
