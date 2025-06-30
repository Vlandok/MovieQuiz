import UIKit

final class ResultAlertPresenter {
    weak var delegate: AlertDelegate?
    private let statisticService: StatisticServiceProtocol

    init(delegate: AlertDelegate?, statisticService: StatisticServiceProtocol) {
        self.delegate = delegate
        self.statisticService = statisticService
    }

    func showAlert(correctAnswers: Int, totalQuestions: Int, completion: @escaping () -> Void) {
        let bestGame = statisticService.bestGame
        let formattedDate = DateFormatter.localizedString(from: bestGame.date, dateStyle: .short, timeStyle: .short)
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)

        let message = """
        Ваш результат: \(correctAnswers)/\(totalQuestions)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))
        Средняя точность: \(accuracy)%
        """

        let alert = Alert(title: "Этот раунд окончен!", message: message, buttonText: "Сыграть еще раз")

        let alertAction = UIAlertAction(title: alert.buttonText, style: .default) { _ in
            completion()
        }

        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(alertAction)

        delegate?.presentAlert(alert: alertController)
    }
}
