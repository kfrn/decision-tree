module Tree.Model exposing (DecisionTree(..), Option, Status(..), TreeNode(..), tree)


type DecisionTree a
    = Answer AnswerText
    | Question a


type TreeNode
    = TreeNode QuestionText (List Option)


type alias AnswerText =
    String


type alias QuestionText =
    String


type alias Option =
    { name : String
    , status : Maybe Status
    , childNode : DecisionTree TreeNode
    }


type Status
    = Selected
    | Disabled


tree : DecisionTree TreeNode
tree =
    Question
        (TreeNode "Is it an exotic fruit?"
            [ { name = "no"
              , status = Nothing
              , childNode =
                    Question
                        (TreeNode "Is it citric or stone fruit?"
                            [ { name = "citric", status = Nothing, childNode = citricNode }
                            , { name = "stone fruit", status = Nothing, childNode = stoneFruitNode }
                            ]
                        )
              }
            , { name = "yes"
              , status = Nothing
              , childNode =
                    Question
                        (TreeNode "Is it a melon?"
                            [ { name = "yes", status = Nothing, childNode = melonNode }
                            , { name = "no", status = Nothing, childNode = bananaNode }
                            ]
                        )
              }
            ]
        )


citricNode : DecisionTree TreeNode
citricNode =
    Question
        (TreeNode "Green or orange?"
            [ { name = "green"
              , status = Nothing
              , childNode =
                    Question
                        (TreeNode "Is it big or small?"
                            [ { name = "big", status = Nothing, childNode = Answer "grapefruit" }
                            , { name = "small", status = Nothing, childNode = Answer "lime" }
                            ]
                        )
              }
            , { name = "orange"
              , status = Nothing
              , childNode =
                    Question
                        (TreeNode "Is it big or small?"
                            [ { name = "big", status = Nothing, childNode = Answer "orange" }
                            , { name = "small", status = Nothing, childNode = Answer "mandarin" }
                            ]
                        )
              }
            ]
        )


stoneFruitNode : DecisionTree TreeNode
stoneFruitNode =
    Question
        (TreeNode "Is it dark-coloured?"
            [ { name = "yes", status = Nothing, childNode = Answer "plum" }
            , { name = "no"
              , status = Nothing
              , childNode =
                    Question
                        (TreeNode "Is it big or small?"
                            [ { name = "big", status = Nothing, childNode = Answer "peach" }
                            , { name = "small", status = Nothing, childNode = Answer "apricot" }
                            ]
                        )
              }
            ]
        )


melonNode : DecisionTree TreeNode
melonNode =
    Question
        (TreeNode
            "What colour is it?"
            [ { name = "pink", status = Nothing, childNode = Answer "watermelon" }
            , { name = "orange", status = Nothing, childNode = Answer "rockmelon" }
            , { name = "green", status = Nothing, childNode = Answer "honeydew" }
            ]
        )


bananaNode : DecisionTree TreeNode
bananaNode =
    Question
        (TreeNode "Is it a banana?"
            [ { name = "yes", status = Nothing, childNode = Answer "banana" }
            , { name = "no", status = Nothing, childNode = Answer "mango" }
            ]
        )
