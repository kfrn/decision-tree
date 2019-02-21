module Tree.Data exposing (fullTree)

import Tree.Model exposing (Tree(..))


fullTree : Tree
fullTree =
    Branch "Is it an exotic fruit?"
        [ { answer = "no"
          , tree =
                Branch "Is it citric or stone fruit?"
                    [ { answer = "citric", tree = citricBranch }
                    , { answer = "stone fruit", tree = stoneFruitBranch }
                    ]
          }
        , { answer = "yes"
          , tree =
                Branch "Is it a melon?"
                    [ { answer = "yes", tree = melonBranch }
                    , { answer = "no", tree = bananaBranch }
                    ]
          }
        ]


citricBranch : Tree
citricBranch =
    Branch "Green or orange?"
        [ { answer = "green"
          , tree =
                Branch "Big or small?"
                    [ { answer = "big", tree = Leaf "grapefruit" }
                    , { answer = "small", tree = Leaf "lime" }
                    ]
          }
        , { answer = "orange"
          , tree =
                Branch "Big or small?"
                    [ { answer = "big", tree = Leaf "orange" }
                    , { answer = "small", tree = Leaf "mandarin" }
                    ]
          }
        ]


stoneFruitBranch : Tree
stoneFruitBranch =
    Branch "Is it dark-coloured?"
        [ { answer = "yes", tree = Leaf "plum" }
        , { answer = "no"
          , tree =
                Branch "Is it big or small?"
                    [ { answer = "big", tree = Leaf "peach" }
                    , { answer = "small", tree = Leaf "plum" }
                    ]
          }
        ]


melonBranch : Tree
melonBranch =
    Branch "What colour is it?"
        [ { answer = "pink", tree = Leaf "watermelon" }
        , { answer = "orange", tree = Leaf "rockmelon" }
        , { answer = "green", tree = Leaf "honeydew" }
        ]


bananaBranch : Tree
bananaBranch =
    Branch "Is it a banana?"
        [ { answer = "yes", tree = Leaf "banana" }
        , { answer = "no", tree = Leaf "mango" }
        ]
