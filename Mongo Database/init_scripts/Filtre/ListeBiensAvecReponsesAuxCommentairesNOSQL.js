db.biens.aggregate([
    {
      $match: {
        "reservations.commentaire.reponses": { $exists: true, $not: {$size: 0} }
      }
    },
    {
      $project: {
        nom_rue: 1,
        ville: 1,
        code_postal: 1,
        reservations: {
          $filter: {
            input: "$reservations",
            as: "reservation",
            cond: { $not: [{$eq: ["$$reservation.commentaire.reponses", []]}] }
          }
        }
      }
    },
    {
      $unwind: "$reservations"
    },
    {
      $project: {
        nom_rue: 1,
        ville: 1,
        code_postal: 1,
        commentaire: "$reservations.commentaire.commentaire",
        reponses: "$reservations.commentaire.reponses"
      }
    }
  ]);
  