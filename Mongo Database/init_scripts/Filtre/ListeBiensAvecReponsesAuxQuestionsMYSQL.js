db.bien.aggregate([
    {
      $lookup: {
        from: "question",
        localField: "_id",
        foreignField: "idBien",
        as: "questions"
      }
    },
    {
      $unwind: "$questions"
    },
    {
      $lookup: {
        from: "reponse",
        localField: "questions._id",
        foreignField: "idQuestion",
        as: "questions.reponses"
      }
    },
    {
      $group: {
        _id: "$_id",
        codePostal: { $first: "$codePostal" },
        dateCreation: { $first: "$dateCreation" },
        idChauffage: { $first: "$idChauffage" },
        idClasseBien: { $first: "$idClasseBien" },
        idEauChaude: { $first: "$idEauChaude" },
        idTypeBien: { $first: "$idTypeBien" },
        idTypeLocation: { $first: "$idTypeLocation" },
        nbPieces: { $first: "$nbPieces" },
        nomRue: { $first: "$nomRue" },
        numAppartement: { $first: "$numAppartement" },
        numEtage: { $first: "$numEtage" },
        numRue: { $first: "$numRue" },
        surfaceHabitable: { $first: "$surfaceHabitable" },
        ville: { $first: "$ville" },
        questions: { $push: "$questions" }
      }
    },
    {
      $project: {
        codePostal: 1,
        dateCreation: 1,
        nomRue: 1,
        numAppartement: 1,
        numEtage: 1,
        numRue: 1,
        ville: 1,
        questions: {
          texte: 1,
          datePublication: 1,
          reponses: {
            texte: 1,
            datePublication: 1
          }
        }
      }
    }
  ]);
  