import { write } from 'fs';
import jsonData from './JSON/Question_Reponses_Soft.json' with { type: "json" };
import writeArrayToCSV from './csvparser.js';

const generateQuestionsAnswersCSV = (nbQuestions, questionsCSVFilepath, answersCSVFilepath) => {
    let jsonDataCopy = [...jsonData];

    let questionsCSVData = [["id", "texte", "datePublication"]];
    let answersCSVData = [["idQuestion", "texte", "datePublication"]];

    // Checks if we have enough questions ...
    if (nbQuestions > jsonDataCopy.length) {
        nbQuestions = jsonDataCopy.length;
    }

    let randomIndex = 0;
    let questionId = 0;

    while (questionsCSVData.length < nbQuestions + 1) {
        questionId++;
        randomIndex = Math.random() * jsonDataCopy.length;

        let questionData = jsonDataCopy.splice(randomIndex, 1)[0];
        
        questionsCSVData.push([
            questionId,
            questionData.question,
            questionData.date
        ]);

        for (let answer of questionData.reponses) {
            answersCSVData.push([
                questionId,
                answer,
                questionData.date
            ]);
        }
    }
    writeArrayToCSV(questionsCSVData, questionsCSVFilepath);
    writeArrayToCSV(answersCSVData, answersCSVFilepath);
}

export default generateQuestionsAnswersCSV;