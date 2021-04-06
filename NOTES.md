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

Model must do two things
1. have a schema so it knows exactly what to expect from postgres
2. Add validations

Validations
struct - represents a record in the database, a hash that contains some data
params - hash that contains the properties we want to update the struct with
cast - produces a changeset, the object that records the updates in the database
validators - adds errors to changeset
changeset - knows the data we're trying to save and whether or not there are validation issues with it
The thing that we actually save to postgres is the acutal changeset object returned at the end of the changeset function

To check the validations:
$ iex -S mix
iex(1)> struct = %Discuss.Topic{}
%Discuss.Topic{
  __meta__: #Ecto.Schema.Metadata<:built, "topics">,
  id: nil,
  title: nil
}
iex(2)> params = %{title: "Great JS"}
%{title: "Great JS"}
iex(3)> Discuss.Topic.changeset(struct, params)
#Ecto.Changeset<
  action: nil,
  changes: %{title: "Great JS"},
  errors: [],
  data: #Discuss.Topic<>,
  valid?: true
>
iex(4)> Discuss.Topic.changeset(struct, %{})   
#Ecto.Changeset<
  action: nil,
  changes: %{},
  errors: [title: {"can't be blank", []}],
  data: #Discuss.Topic<>,
  valid?: false
>

Changeset + Form Template = Usable Form

To get access to the params, since "topic" is a string instead of an atom, can't call params.topic so use pattern matching instead
iex(3)> params = %{"topic" => "asdf"}
%{"topic" => "asdf"}
iex(4)> params.topic
** (KeyError) key :topic not found in: %{"topic" => "asdf"}

iex(4)> params["topic"]
"asdf"
iex(5)> %{"topic" => string} = params
%{"topic" => "asdf"}
iex(6)> string
"asdf"

To see route information:
$ mix phoenix.routes

## STANDARD CRUD from TopicController
defmodule Discuss.TopicController do 
  use Discuss.Web, :controller

  alias Discuss.Topic

  def index(conn, _params) do 
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do 
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do 
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do 
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do 
    topic = Repo.get(Topic, topic_id) #gets a single record from the Topic table with that id
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do 
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do 
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do 
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end
end

-------------------------------------------

### OAuth Configuration with .env variables
Found solution from [desar00](https://elixirforum.com/t/how-to-set-environment-variables-in-dev-exs/18552/5)

Create .env file in config folder
set up variables using:
export FIRST_VARIABLE=somevariable
System.get_env("FIRST_VARIABLE")

in terminal which in project directory run
$ source config/.env