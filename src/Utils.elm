module Utils exposing (listWithoutLast)

import List.Extra as ListX


listWithoutLast : List a -> List a
listWithoutLast list =
    case ListX.init list of
        Just head ->
            head

        Nothing ->
            []
