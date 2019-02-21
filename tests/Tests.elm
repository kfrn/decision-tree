module Tests exposing (all)

import Expect
import List.Extra as ListX
import Test exposing (..)
import Tree.Model exposing (Option, Tree(..), focusChildOption)


all : Test
all =
    describe "Decision Tree" <|
        let
            tree =
                Branch "is it native or foreign?" [ nativeOption, foreignOption ]

            nativeOption =
                { answer = "native"
                , tree =
                    Branch "do tuis like it?" [ kowhaiOption, rimuOption, flaxOption ]
                }

            foreignOption =
                { answer = "foreign"
                , tree =
                    Branch "Does it have fruit?"
                        [ { answer = "yes", tree = Leaf "apple tree" }
                        , { answer = "no", tree = Leaf "oak tree" }
                        ]
                }

            kowhaiOption =
                { answer = "yes", tree = Leaf "kowhai" }

            rimuOption =
                { answer = "no", tree = Leaf "rimu" }

            flaxOption =
                { answer = "maybe", tree = Leaf "flax" }

            initialZipper =
                { focus = { answer = "welcome to the tree", tree = tree }
                , breadcrumbs = []
                }
        in
        [ describe "focusChildOption" <|
            [ describe "Top-level choice" <|
                [ describe "Ts it native or foreign? -> native" <|
                    let
                        newZipper =
                            focusChildOption nativeOption initialZipper
                    in
                    [ test "it focuses the native tree option" <|
                        \_ -> Expect.equal newZipper.focus nativeOption
                    , test "it adds a breadcrumb with the question, and the foreignOption added to the rightSiblings field" <|
                        let
                            crumb =
                                { previousChoice = ( "is it native or foreign?", "native" )
                                , leftSiblings = []
                                , rightSiblings = [ foreignOption ]
                                }
                        in
                        \_ -> Expect.equal newZipper.breadcrumbs [ crumb ]
                    ]
                ]
            , describe "Second-level choice" <|
                [ describe "Native tree. Do tuis like it? -> no" <|
                    let
                        newZipper =
                            focusChildOption rimuOption <|
                                focusChildOption nativeOption initialZipper
                    in
                    [ test "it focuses the first grandchild tree" <|
                        \_ -> Expect.equal newZipper.focus rimuOption
                    , test "it adds a breadcrumb to the breadcrumbs field" <|
                        \_ -> Expect.equal (List.length newZipper.breadcrumbs) 2
                    , test "the new breadcrumb includes the question, and the sibling options of the choice" <|
                        let
                            crumb =
                                { previousChoice = ( "do tuis like it?", "no" )
                                , leftSiblings = [ kowhaiOption ]
                                , rightSiblings = [ flaxOption ]
                                }
                        in
                        \_ -> Expect.equal (List.head newZipper.breadcrumbs) (Just crumb)
                    ]
                ]
            ]
        ]
