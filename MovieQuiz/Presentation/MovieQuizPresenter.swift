import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol = StatisticService()

    private var questionsAmount: Int { questionFactory?.questionsAmount ?? 0 }

    weak var delegate: AlertDelegate?

    func viewDidLoad() {
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory

        questionFactory.requestNextQuestion()
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question

        let quiz = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.upadeteQuiz(quiz: quiz)
            self?.delegate?.clearQuizImageBorder()
        }
    }

    func noButtonClicked() {
        showAnswerResult(isYesClicked: false)
    }

    func yesButtonClicked() {
        showAnswerResult(isYesClicked: true)
    }

    private func showAnswerResult(isYesClicked: Bool) {
        guard let currentQuestion = currentQuestion else { return }

        let isCorrect = currentQuestion.correctAnswer == isYesClicked
        if isCorrect { correctAnswers += 1 }
        let color = (isCorrect ? UIColor.YpGreen : UIColor.YpRed).cgColor

        delegate?.setQuizImageBorder(width: 8, color: color)
        delegate?.setEnabledButtonsChooseAnswer(isEnable: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            guard let self = self else { return }
            delegate?.setEnabledButtonsChooseAnswer(isEnable: true)
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            showAlertResult()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    private func showAlertResult() {
        let bestGame = statisticService.bestGame

        let formattedDate = DateFormatter.localizedString(
            from: bestGame.date,
            dateStyle: .short,
            timeStyle: .short
        )

        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)

        let message =
            "Ваш результат: \(correctAnswers)/\(questionsAmount)\n"
            + "Количество сыгранных квизов: \(statisticService.gamesCount)\n"
            + "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))\n"
            + "Средняя точность: \(accuracy)%"

        let alert = Alert(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть еще раз"
        )

        let alertAction = UIAlertAction(
            title: alert.buttonText, style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }

        let uiAlertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )

        uiAlertController.addAction(alertAction)

        delegate?.presentAlert(alert: uiAlertController)
    }

    private func convert(model: QuizQuestion) -> QuizStep {
        return QuizStep(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
