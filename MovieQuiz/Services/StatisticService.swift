import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
}

extension StatisticService: StatisticServiceProtocol {

    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }

    var bestGame: GameResult {
        get {
            let correctAnswers = storage.integer(forKey: Keys.bestCorrect.rawValue)
            let totalQuestions = storage.integer(forKey: Keys.bestTotal.rawValue)
            let date = storage.object(forKey: Keys.bestDate.rawValue) as? Date ?? Date()

            return GameResult(correct: correctAnswers, total: totalQuestions, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestTotal.rawValue)
            storage.set( newValue.date, forKey: Keys.bestDate.rawValue)
        }
    }

    var totalAccuracy: Double {
        let correct = storage.integer(forKey: Keys.totalCorrect.rawValue)
        let total = storage.integer(forKey: Keys.totalQuestions.rawValue)
        guard total > 0 else { return 0.0 }
        return (Double(correct) / Double(total)) * 100
    }

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        updateTotalStatistics(count: count, amount: amount)
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
    private func updateTotalStatistics(count: Int, amount: Int) {
        let previousCorrect = storage.integer(forKey: Keys.totalCorrect.rawValue)
        let previousTotal = storage.integer(forKey: Keys.totalQuestions.rawValue)

        storage.set(previousCorrect + count, forKey: Keys.totalCorrect.rawValue)
        storage.set(previousTotal + amount, forKey: Keys.totalQuestions.rawValue)
    }
}

private enum Keys: String {
    case gamesCount = "gamesCount"
    case totalCorrect = "totalCorrect"
    case totalQuestions = "totalQuestions"
    case bestCorrect = "gameResultCorrectAnswers"
    case bestTotal = "gameResultTotalQuestions"
    case bestDate = "gameResultDate"
}
