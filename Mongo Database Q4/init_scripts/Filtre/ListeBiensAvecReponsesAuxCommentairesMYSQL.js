db.bien.aggregate([
    {
      $lookup: {
        from: "lcd",
        localField: "_id",
        foreignField: "codeBien",
        as: "lcds"
      }
    },
    {
      $unwind: "$lcds"
    },
    {
      $lookup: {
        from: "commentaire",
        localField: "lcds._id",
        foreignField: "idLCD",
        as: "lcds.commentaires"
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
        lcds: { $push: "$lcds" }
      }
    },
    {
       $project: {
        codePostal: 1,
        nomRue: 1,
        numAppartement: 1,
        numEtage: 1,
        numRue: 1,
        ville: 1,
        lcds: {
          $map: {
            input: "$lcds",
            as: "lcd",
            in: {
              commentaires: {
                $map: {
                  input: "$$lcd.commentaires",
                  as: "commentaire",
                  in: {
                    texte: "$$commentaire.texte",
                    idTiers: "$$commentaire.idTiers"
                  }
                }
              }
            }
          }
        }
      }
    }
  ]);
  