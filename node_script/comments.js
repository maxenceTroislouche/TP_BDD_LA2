import jsonData from './JSON/comments.json' with { type: "json" };
import writeArrayToCSV from './csvparser.js';

const getCSVData = (csvData, data, type) => {
    let id = getMaxIdFromCSVData(csvData) + 1;

    let comments = [];

    console.log(`type: ${type}`)

    for (let comment of data) {
        id = addComment(comment, id, comments, 0, type);
    }

    // console.log(comments);
    for (let comment of comments) {
        csvData.push([comment[0], comment[1], comment[2], comment[3]]);
    }

    return csvData;
}

const getMaxIdFromCSVData = (csvData) => {
    let max = 0;

    for (let data of csvData) {
        if (data[0] === "id") {
            continue;
        }
        max = Math.max(max, data[0]);
    }

    return max;
}

const addComment = (data, minId, comments, idOriginal, type) => {
    comments.push([minId, idOriginal, data.commentaire, type]);

    let childMinId = minId + 1;

    for (let answer of data.reponses) {
        childMinId = addComment(answer, childMinId, comments, minId, type);
    }

    return childMinId;
}

/**
 * Permet de générer le fichier CSV correspondant aux commentaires
 * @param {*} nbPositiveComments Non pris en compte :/ 
 * @param {*} nbNeutralComments Non pris en compte :/
 * @param {*} nbNegativeComments Non pris en compte :/
 * @param {*} commentsCSVFilepath Chemin vers le fichier CSV à créer
 */
const generateCommentsCSV = (nbPositiveComments, nbNeutralComments, nbNegativeComments, commentsCSVFilepath) => {
    let positiveDataCopy = [...jsonData.positif];
    let neutralDataCopy = [...jsonData.neutre];
    let negativeDataCopy = [...jsonData.negatif];

    let csvData = [["id", "idCommentaireOriginal", "texte", "type"]];
    getCSVData(csvData, positiveDataCopy, 1);
    getCSVData(csvData, neutralDataCopy, 2);
    getCSVData(csvData, negativeDataCopy, 3);

    writeArrayToCSV(csvData, commentsCSVFilepath);
}

export default generateCommentsCSV;