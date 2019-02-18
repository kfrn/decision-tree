module Tests exposing (all)

import Expect
import Messages exposing (Msg(..))
import Test exposing (..)
import Tree.Model exposing (Option(..), Tree(..), findClosestAncestor)
import Update exposing (update)


all : Test
all =
    describe "Decision Tree" <|
        let
            childTree =
                Leaf "child answer"

            parentTree =
                Branch "parent question text"
                    [ Option "parent answer" childTree ]

            grandparentTree =
                Branch "grandparent question text"
                    [ Option "grandparent answer" parentTree ]
        in
        [ describe "findClosestAncestor" <|
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
                [ test "the child tree is stored as a choice" <|
                    let
                        initialModel =
                            [ parentTree ]

                        expectedModel =
                            [ parentTree, childTree ]

                        ( actualModel, _ ) =
                            update (SelectOption childTree) initialModel
                    in
                    \_ -> Expect.equalLists expectedModel actualModel
                ]
            , describe "when choosing an ancestor node of the most recent choice" <|
                [ test "the tree is 'reset' to the current choice" <|
                    let
                        initialModel =
                            [ grandparentTree, parentTree, childTree ]

                        expectedModel =
                            [ grandparentTree, parentTree ]

                        ( actualModel, _ ) =
                            update (SelectOption parentTree) initialModel
                    in
                    \_ -> Expect.equalLists expectedModel actualModel
                ]
            ]
        ]
