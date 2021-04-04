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

View vs Template
When phoenix first boots up, for every module in the views folder it takes the name of the view
It then looks inside the templates folder and it will try to find a folder with that name in it
If it finds one, it will take every file in that template folder and it will add it as a function to the page view and that function is render("index.html")

Names of Models, Controllers, Views and Template folders are intrinsically linked: FOLLOW NAMING CONVENTIONS

Debugging tool:
When the server is NOT running, $ iex -S mix phoenix.server
Opens the server in your terminal
Discuss.PageView.render("index.html")