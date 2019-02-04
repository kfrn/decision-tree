module Tree.Data exposing (fullDecisionTree)

import Tree.Model exposing (DecisionTree(..), TreeNode(..))


fullDecisionTree : DecisionTree TreeNode
fullDecisionTree =
    Question
        (TreeNode "Is it an exotic fruit?"
            [ { name = "no"
              , selected = False
              , childNode =
                    Question
                        (TreeNode "Is it citric or stone fruit?"
                            [ { name = "citric", selected = False, childNode = citricNode }
                            , { name = "stone fruit", selected = False, childNode = stoneFruitNode }
                            ]
                        )
              }
            , { name = "yes"
              , selected = False
              , childNode =
                    Question
                        (TreeNode "Is it a melon?"
                            [ { name = "yes", selected = False, childNode = melonNode }
                            , { name = "no", selected = False, childNode = bananaNode }
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
              , selected = False
              , childNode =
                    Question
                        (TreeNode "Is it big or small?"
                            [ { name = "big", selected = False, childNode = Answer "grapefruit" }
                            , { name = "small", selected = False, childNode = Answer "lime" }
                            ]
                        )
              }
            , { name = "orange"
              , selected = False
              , childNode =
                    Question
                        (TreeNode "Is it big or small?"
                            [ { name = "big", selected = False, childNode = Answer "orange" }
                            , { name = "small", selected = False, childNode = Answer "mandarin" }
                            ]
                        )
              }
            ]
        )


stoneFruitNode : DecisionTree TreeNode
stoneFruitNode =
    Question
        (TreeNode "Is it dark-coloured?"
            [ { name = "yes", selected = False, childNode = Answer "plum" }
            , { name = "no"
              , selected = False
              , childNode =
                    Question
                        (TreeNode "Is it big or small?"
                            [ { name = "big", selected = False, childNode = Answer "peach" }
                            , { name = "small", selected = False, childNode = Answer "apricot" }
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
            [ { name = "pink", selected = False, childNode = Answer "watermelon" }
            , { name = "orange", selected = False, childNode = Answer "rockmelon" }
            , { name = "green", selected = False, childNode = Answer "honeydew" }
            ]
        )


bananaNode : DecisionTree TreeNode
bananaNode =
    Question
        (TreeNode "Is it a banana?"
            [ { name = "yes", selected = False, childNode = Answer "banana" }
            , { name = "no", selected = False, childNode = Answer "mango" }
            ]
        )
