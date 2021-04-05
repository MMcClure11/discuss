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

The Model Layer in Phoenix
We have to tell Phx what kind of data to expect from the database
Phx land (topic model) <-> Postgres land (table of topic models)
Database migrations are how we give instructions to Postgres about its tables and types of data 

To generate a migration:
mix ecto.gen.migration add_topics
To run a migration:
mix ecto.migrate

To Visualize the Tables:
Download: https://eggerapps.at/postico/ 

Problem | Solution
Need a new URL for the user to visit | Add a new route in router file
New routes must map to a method in a controller | Add new method in a controller to handle request. Method will decide what to do with the request
Need to show a form to the user | Make a new template that contains the form
Need to translate data in the form to something that can be saved in the database | create a 'Topic' model that can translate raw data from the form into something that can be saved in the database
The controller and view that we currently have are related to a 'Page' but we are making stuff related to a 'Topic' | Make a new controller and view to handle everything related to 'Topics'

Router.ex
    get "/topics/new", TopicController, :new
Phx follows restful conventions

Reusing Code in Phoenix Applications
THese keywords are Elixir keywords
Keyword | Purpose
import | Take all the functions out of this module and give them to this other module
alias | Give me a shortcut to this other module, my fingers are lazy
use | I want to do some really fancy setup

in topic_controller.ex
  use Discuss.Web, :controller
this is similiar to class inheritance in OOP - how code sharing is happening

conn: short for connection, it is a struct
it's the focal point of the phoenix application
represents both the incoming and the outgoing request