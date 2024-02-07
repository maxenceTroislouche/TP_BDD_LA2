import jsonData from './JSON/Question_Reponses_Soft.json' with { type: "json" };
import writeArrayToCSV from './csvparser.js';

const generateQuestionsAnswersCSV = (nbQuestions, questionsCSVFilepath, answersCSVFilepath) => {
    let jsonDataCopy = [...jsonData];

    let questionsCSVData = [["id", "texte", "datePublication"]];
    let reponsesCSVData = [["idQuestion", "texte", "datePublication"]];

    // Checks if we have enough questions ...
    if (nbQuestions > jsonDataCopy.length) {
        nbQuestions = jsonDataCopy.length;
    }

    let randomIndex = 0;

    // TODO: Ajouter qui a posé la question ?
    while (questionsCSVData.length < nbQuestions + 1) {
        randomIndex = Math.random() * jsonDataCopy.length;

        let data = jsonDataCopy.splice(randomIndex, 1);

        
    }
}

export default generateQuestionsAnswersCSV