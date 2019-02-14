module Tree.Data exposing (fullTree)

import Tree.Model exposing (Node(..), Tree(..))


fullTree : Tree Node
fullTree =
    Question
        (Node "Is it an exotic fruit?"
            [ { name = "no"
              , selected = False
              , childNode =
                    Question
                        (Node "Is it citric or stone fruit?"
                            [ { name = "citric", selected = False, childNode = citricNode }
                            , { name = "stone fruit", selected = False, childNode = stoneFruitNode }
                            ]
                        )
              }
            , { name = "yes"
              , selected = False
              , childNode =
                    Question
                        (Node "Is it a melon?"
                            [ { name = "yes", selected = False, childNode = melonNode }
                            , { name = "no", selected = False, childNode = bananaNode }
                            ]
                        )
              }
            ]
        )


citricNode : Tree Node
citricNode =
    Question
        (Node "Green or orange?"
            [ { name = "green"
              , selected = False
              , childNode =
                    Question
                        (Node "Is it big or small?"
                            [ { name = "big", selected = False, childNode = Answer "grapefruit" }
                            , { name = "small", selected = False, childNode = Answer "lime" }
                            ]
                        )
              }
            , { name = "orange"
              , selected = False
              , childNode =
                    Question
                        (Node "Is it big or small?"
                            [ { name = "big", selected = False, childNode = Answer "orange" }
                            , { name = "small", selected = False, childNode = Answer "mandarin" }
                            ]
                        )
              }
            ]
        )


stoneFruitNode : Tree Node
stoneFruitNode =
    Question
        (Node "Is it dark-coloured?"
            [ { name = "yes", selected = False, childNode = Answer "plum" }
            , { name = "no"
              , selected = False
              , childNode =
                    Question
                        (Node "Is it big or small?"
                            [ { name = "big", selected = False, childNode = Answer "peach" }
                            , { name = "small", selected = False, childNode = Answer "apricot" }
                            ]
                        )
              }
            ]
        )


melonNode : Tree Node
melonNode =
    Question
        (Node
            "What colour is it?"
            [ { name = "pink", selected = False, childNode = Answer "watermelon" }
            , { name = "orange", selected = False, childNode = Answer "rockmelon" }
            , { name = "green", selected = False, childNode = Answer "honeydew" }
            ]
        )


bananaNode : Tree Node
bananaNode =
    Question
        (Node "Is it a banana?"
            [ { name = "yes", selected = False, childNode = Answer "banana" }
            , { name = "no", selected = False, childNode = Answer "mango" }
            ]
        )
