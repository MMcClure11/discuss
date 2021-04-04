To start the phoenix server:

  $ mix phoenix.server

MVC architecture - not limited to OOP
Model - raw data of the topic
View - template that takes the model and makes it look nice
Controller - figures out what the use is looking for, grabs the correct model, stuffs it into the view, returns the result to the user

Requests in phoenix

HTTP Request -> Router -> Controller -> View -> Response
Database -> Model -> Controller
Template -> View

router.ex     get "/", PageController, :index
page_controller.ex def index
PageController is a general default name from the generated project