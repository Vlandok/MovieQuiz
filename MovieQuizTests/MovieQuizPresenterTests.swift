import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        let presenter = MovieQuizPresenter()
            
        let emptyData = Data()
        let question = QuizQuestion(
            image: emptyData,
            text: "Question Text",
            correctAnswer: true
        )
        let quizStep = presenter.convert(model: question)
            
        XCTAssertNotNil(quizStep.image)
        XCTAssertEqual(quizStep.question, "Question Text")
        XCTAssertEqual(quizStep.questionNumber, "1/10")
    }
}
