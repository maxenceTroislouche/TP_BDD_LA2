db.biens.aggregate([
    {
      $match: {
        "questions.reponses": { $exists: true, $not: {$size: 0} }
      }
    }
  ]);