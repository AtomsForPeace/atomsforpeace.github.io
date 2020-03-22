module ArtGroup exposing (main)

import Html exposing (Html, div, h1, h2, text, img, i)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Browser

main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }

type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    }

type alias Feed =
    List Photo

type alias Model =
    { feed : Feed
    }

type alias Id =
    Int

initialModel : Model
initialModel =
    { feed =
        [ { id = 1
          , url = baseUrl ++ "In Dublin's fair city.jpg"
          , caption = "In Dublin's fair city"
          , liked = False
          },
          { id = 2
          , url = baseUrl ++ "Poppy.jpg"
          , caption = "Poppy"
          , liked = False
          },
          { id = 3
          , url = baseUrl ++ "Stag.jpg"
          , caption = "Stag"
          , liked = False
          }
        ]
    }

viewFeed : Feed -> Html Msg
viewFeed feed =
    div [] (List.map viewDetailedPhoto feed)

view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Ruby Bannister Art & Craft" ] ]
        , div [ class "content-flow" ]
            [ viewFeed model.feed ]
        ]

toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }

updatePhotoById : (Photo -> Photo) -> Id -> Feed -> Feed
updatePhotoById updatePhoto id feed =
    List.map
        (\photo ->
            if photo.id == id then
                updatePhoto photo
            else
                photo
        )
        feed

update :
    Msg
    -> Model
    -> Model
update msg model =
    case msg of
        ToggleLike id ->
            { model | feed = updatePhotoById toggleLike id model.feed }


baseUrl : String
baseUrl = "./images/"

type Msg
    = ToggleLike Id

viewLoveButton : Photo -> Html Msg
viewLoveButton photo =
    let
        buttonClass =
            if photo.liked then
                "fa-heart"
            else
                "fa-heart-o"
    in
    div [ class "like-button" ]
        [ i
            [ class "fa fa-2x"
            , class buttonClass
            , onClick (ToggleLike photo.id)
            ]
            []
        ]

viewDetailedPhoto : Photo -> Html Msg
viewDetailedPhoto photo =
    div [ class "detailed-photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton photo
            , h2 [ class "caption" ] [ text photo.caption ]
            ]
        ]
