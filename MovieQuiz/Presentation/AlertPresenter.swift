import UIKit

final class AlertPresenter {
    weak var delegate: AlertDelegate?
    private let statisticService: StatisticServiceProtocol

    init(delegate: AlertDelegate?, statisticService: StatisticServiceProtocol) {
        self.delegate = delegate
        self.statisticService = statisticService
    }

    func showResultAlert(correctAnswers: Int, totalQuestions: Int, completion: @escaping () -> Void) {
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
        
        showAlert(alert: alert, alertAction: alertAction)
    }
    
    func showNetworkErrorAlert(tryAgain: @escaping () -> Void) {
        let alert = Alert(title: "Что то пошло не так(", message: "Невозможно загрузить данные", buttonText: "Попробовать еще раз")
        let alertAction = UIAlertAction(title: alert.buttonText, style: .default) { _ in
            tryAgain()
        }
        
        showAlert(alert: alert, alertAction: alertAction)
    }
    
    private func showAlert(alert: Alert, alertAction: UIAlertAction) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(alertAction)

        delegate?.presentAlert(alert: alertController)
    }
}
