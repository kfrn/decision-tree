module Utils exposing (getNext)

import List.Extra as ListX


getNext : a -> List a -> Maybe a
getNext item list =
    ListX.elemIndex item list
        |> Maybe.map (\idx -> ListX.getAt (idx + 1) list)
        |> Maybe.withDefault Nothing
