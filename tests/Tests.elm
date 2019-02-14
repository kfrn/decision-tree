module Tests exposing (all)

import Expect
import Messages exposing (Msg(..))
import Test exposing (..)
import Tree.Model exposing (Tree(..), Node(..), findClosestAncestor, setSelectionOn)
import Update exposing (update)


all : Test
all =
    describe "Decision Tree" <|
        let
            childTree =
                Answer "child answer"

            parentTree =
                Question (Node "parent question text" [ { name = "parent option", selected = False, childNode = childTree } ])

            parentTreeSelected =
                Question (Node "parent question text" [ { name = "parent option", selected = True, childNode = childTree } ])

            grandparentTree =
                Question
                    (Node "question text"
                        [ { name = "option"
                          , selected = False
                          , childNode = parentTree
                          }
                        ]
                    )

            grandparentTreeSelected =
                Question
                    (Node "question text"
                        [ { name = "option"
                          , selected = True
                          , childNode = parentTree
                          }
                        ]
                    )
        in
        [ describe "setSelectionOn" <|
            [ describe "when a parent tree contains a child tree" <|
                [ test "the option in the parent tree which contains the child tree is set as selected" <|
                    \_ -> Expect.equal parentTreeSelected (setSelectionOn parentTree childTree)
                ]
            , describe "when the first tree does not contain the second tree" <|
                [ test "No option in the first tree is set as selected" <|
                    \_ -> Expect.equal parentTree (setSelectionOn parentTree (Answer "some answer"))
                ]
            ]
        , describe "findClosestAncestor" <|
            [ describe "when searching for the ancestor of the child tree" <|
                [ test "it returns the parent" <|
                    \_ -> Expect.equal (Just parentTree) (findClosestAncestor childTree [ parentTree ])
                ]
            , describe "when searching for the ancestor of the parent tree" <|
                [ test "it returns the grandparent tree" <|
                    \_ -> Expect.equal (Just grandparentTree) (findClosestAncestor parentTree [ grandparentTree, parentTree ])
                ]
            , describe "when searching for the ancestor of the grandparent tree" <|
                [ test "it returns Nothing" <|
                    \_ -> Expect.equal Nothing (findClosestAncestor grandparentTree [ grandparentTree, parentTree ])
                ]
            ]
        , describe "SelectOption" <|
            [ describe "when choosing a direct child of the most recent choice" <|
                [ test "the child tree is stored as a choice, and the parent tree is selected" <|
                    let
                        initialModel =
                            [ parentTree ]

                        expectedModel =
                            [ parentTreeSelected, childTree ]
                    in
                    \_ -> Expect.equal ( expectedModel, Cmd.none ) (update (SelectOption childTree) initialModel)
                ]
            , describe "when choosing an ancestor node of the most recent choice" <|
                [ test "the tree is 'reset' to the current choice, with the parent of that ancestor set to selected" <|
                    let
                        initialModel =
                            [ grandparentTree, parentTree, childTree ]

                        expectedModel =
                            [ grandparentTreeSelected, parentTree ]
                    in
                    \_ -> Expect.equal ( expectedModel, Cmd.none ) (update (SelectOption parentTree) initialModel)
                ]
            ]
        ]
