"""

Note: To Autocomplete <!DOCTYPE html> we can use (! + Tab) or Type (html:5 + Tab)

What is Django?
■ Python web framework
■ Server Side Framework
■ Designed to get you started fast Batteries included
■ MVT Design Pattern


So basically it is both front-end and back-end framework where we can develop websites really fast.
Batteries Included means that it consumes more power to run it's application 

Other Python Frameworks

■Flask
■ Cherry Pie
■ Web2py
■ Pyramid

So we start with using puddle. 
Puddle is a default project where we can create our application.

there is manage.py file which executes the command
there is urls.py which contains the url we would use 
there is settings.py where we can edit the settings

in settings.py we can see the apps section.
these mini apps are what configures and handles different part of our website

Views in Django are Python functions or classes that receive web requests and return web responses. 
They act as a bridge between URL patterns and the application logic, processing data and rendering it to the user. 

for eg : request ---> views (The functions that receive web requests and return web responses) ---> response

There are two main types of views in Django:

Function-based views:
These are Python functions that take an HttpRequest object as input and return an HttpResponse object. 
They are suitable for simple logic and CRUD (Create, Retrieve, Update, Delete) operations.


Class-based views:
These are Python classes that inherit from Django's View class. 
They offer more structure and reusability, especially for complex logic and handling different HTTP methods (GET, POST, etc.). 
Generic class-based views are available for common tasks like displaying lists, details, and forms.


Now come to include, 
include is a function which joins multiple files in various into one

for eg : 
in base.url which is by the way our app, has some set of views in it.
but puddle.url does not have it. instead of copying and pasting it, 


--------------------------------------------------------------------------------------------

Templates : in django we can create many addresses like in websites with URL's.
            at the same time, we can also use html for each addresses and this address is called Templates
            to add a Template, add its path in dir list in settings.py


---------------------------------------------------------------------------------------------

Template Inheritance : In django each template can be used with one inside another like inheritance in classes.
                       As the templates resembles classes here, we can call this Template Inheritance
                       
-----------------------------------------------------------------------------------------

Variables in Django : In Django, Where in templates, we can use variables like programming languages.
                      For that we need to use {'variable_name' : value, variables}
                      To use it, we need to use {{variable_name}}

---------------------------------------------------------------------------------------------

tags in django-html : This is a important point to remember. we are not using regular generic html
                      The HTML here we use is django-html which is the format that supports special tags.
                      

Tag	                Description
autoescape	        Specifies if autoescape mode is on or off
block	            Specifies a block section
comment	            Specifies a comment section
csrf_token	        Protects forms from Cross Site Request Forgeries
cycle	            Specifies content to use in each cycle of a loop
debug	            Specifies debugging information
extends	            Specifies a parent template
filter	            Filters content before returning it
firstof	            Returns the first not empty variable
for	                Specifies a for loop
if	                Specifies a if statement
ifchanged	        Used in for loops. Outputs a block only if a value has changed since the last iteration
include	            Specifies included content/template
load	            Loads template tags from another library
lorem	            Outputs random text
now	                Outputs the current date/time
regroup         	Sorts an object by a group
resetcycle	        Used in cycles. Resets the cycle
spaceless	        Removes whitespace between HTML tags
templatetag	        Outputs a specified template tag
url	Returns t       he absolute URL part of a URL
verbatim	        Specifies contents that should not be rendered by the template engine
widthratio	        Calculates a width value based on the ratio between a given value and a max value
with	            Specifies a variable to use in the block


these are all the template-tags in django

---------------------------------------------------------------------------------------------------------------


A simple for loop in template-tags :
{% block content%}
{% for x in data %}
    <h1>Hi</h1>
{% endfor %}
{% endblock %}

------------------------------------------------------------------------------------------------------------

Using Data in Django :

We cannot use the data directly in templates in django-html.
We can use data if we assign it in the same html but generally speaking it's not possible

for that we have to mention it in view function

syntax : 
def func_name(request):
    context={data,multiple data}
    return render(request,'name_of_html.html',{'your_new_name_to_call_that_variable':actual_name})
    
sample 

In views.py : 
def testing(request):
    context = { 
        "data" : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 
        "First_name" : "Saisakthi"
    } 
    return render(request, 'main_temp.html',context)

in main_temp.html : 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saisakthi</title>
</head>
<body>
    {% block content%}
    {% for x in data %}
        <h1>Hi</h1>
    {% endfor %}
    <hi>Hi My name is {{ First_name }}</hi>
    {% endblock %}
    
</body>
</html>


--------------------------------------------------------------------------------------------

input numeric value in url django-html : 

in urls.py :
path('room/<str:pk>/', views.room, name="room"),

Note : pk = primary key

that <str:value_inside_function> is used as a value container for int

in views.py:

def func_name(request,value_inside_function):
    return your_wish

we can also use <int>,<slug>

---------------------------------------------------------------------------------------------

Database and Admin_control : 


Creating a Database : 
To create a Database, we hve to create a class in models.py
in models.py, if we create a class it creates a SQL Table
the attributes we create inside becomes the columns inside table

Models module : it is a interpreter which converts our class into a table

from django.db import models

# Create your models here.

class Room(models.model):
    name = models.CharField(max_length=120)
    description = models.TextField(null=True)

charfield : it is character field where we can only use character
textfield : it is string field, we can input only strings 
            But a important thing to note that is we cannot use null value in description 
            which means if we create any row, we have to compulsory give a description
            

Models in Django : 

A model in Django is a special kind of object – it is saved in the database . 
A database is a collection of data. This is a place in which you will store information about users, your blog posts, etc. 
We will be using a SQLite database to store our data.

Now,we are also going to use Database we are given.

queryset = ModelName.objects.all()

variable that holds response : queryset
Modelname : The name of the model
objects : the objects created by user
all : method to get all the objects 

One to Many Models : 

Models can have multiple children classes
for eg : A user in instagram can post multiple stories.
here Model - Instagram 
     Children - Stories
     
Children in Django :
In Django, the concept of "children" typically arises in the context of model relationships, 
specifically when dealing with one-to-many or parent-child relationships.
These relationships are established using ForeignKey or, less commonly, OneToOneField in model definitions.

Take it as Inheritance but modified

class Room(models.Model):
    name = models.CharField(max_length=120)
    description = models.TextField(null=True,blank=True)
    # participants = 
    update = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return str(self.name)

class Messages(models.Model):
    # user
    room = models.ForeignKey(Room, on_delete=models.CASCADE)
    
This is a Example of OneToMany model connection.

So first we need to understand that all the classes we create is going to become a Database.
We have first database Room, it is the main Database so in default, It has the primary-key
we  have second database Messages which has a foreign key.(Foreign Key is nothing but Primary key fo the first table)
what is happening here is that it connecting the foreign key to primary key of first table

-----------------------------------------------------------------------------------------------------------------------

CRUD (Create Read Update Delete) : 
    In any website, we need to create, read, update and delete a request or response
    In Django, We can do it

Create: 
    {% csrf_token %} : This is a token used while using form using POST method.
                    This helps to prevent identify if there is a malicious attempt in request
    Ordering : in django, you can sort the order of display by Meta class.
    for eg : Class Meta :
                ordering = ['-updated','-created']
            This is going to order the data on time modified. if the data is latest, it is going to display first.
            Note: if you use ['updated','created'] it is for sending sort which reverses the sort in receive

Code For Creating a room :

in views.py:
def create_room(request):
    form = RoomForm()
    if request.method == 'POST':
        form = RoomForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('home')  # safer than using '/'
    context = {'form': form}
    return render(request, 'base/room_form.html', context)

in urls.py:
path('create-room/',views.create_room,name='create-room')

in room_form.html:
{% extends "base/main.html" %}

{% block content %}
<div>
    <form method="POST" action="">
        {% csrf_token %}
        {{ form.as_p }}
        <input type="submit" value="submit"><br>
    </form>
</div>
{% endblock content %}

in home.html:
{% extends 'base/main.html' %}

{% block content %}

<h1>Home Page</h1>

<div>
    <a href="{% url 'create-room' %}">Create Room</a>
    <div>
        {% for room in rooms %}
            <div>
                <a href="{% url 'update-room' room.id %}">Update Room</a>
                <a href="{% url 'delete-room' room.id %}">Delete Room</a>
                <span>@{{room.host.username}}</span>
                <h4>{{room.id}} - <a href="{% url 'room' room.id %}">{{room.name}}</a></h4>
                <small>{{room.topic.name}}</small>
                <hr>

            </div>
        {% endfor %}
    </div>
</div>

{% endblock %}

Explanation : 
1) First, we are creating a form object for class RoomForm 
(If you don't know what is a form is, it's just a form in html but instead of using HTML, django sets default form and returns to us)
2) in room_form.html, we create a button which if clicked, sends the POST method to the request.
3) request received a method POST and if it is true, we are creating a room with the data in the model.
4) in home.html the room created will display (This can be considered as READ function. So we completed CR)

Update: 
in views.py:
def update_room(request,pk):
    room = Room.objects.get(id=pk)
    form = RoomForm(instance=room)
    if request.method == 'POST':
        form = RoomForm(request.POST,instance=room)
        if form.is_valid():
            form.save()
            return redirect('home') 
    context = {'form' : form}
    return render(request,'base/room_form.html',context)
in home.html: 
<a href="{% url 'update-room' room.id %}">Update Room</a>
in urls.html:
path('update-room/<str:pk>/',views.update_room,name='update-room'),

How it works:
1) The option update room is given to user after each comment. this is easy to get the id 
2) if user clicks one of the comment, the view is going to retrieve the data from database using that id (primary key)
3) after retrieving, it redirects to home.
4) home gets the remaining data and display to it

Delete:
in views.py:
def delete_room(request, pk):
    room = get_object_or_404(Room, id=pk)
    
    if request.method == "POST":
        room.delete()
        return redirect("home")
    
    return render(request, 'base/delete_room.html', {'obj': room})
... (It's the same for urls)
in delete_room.html:
{% extends 'base/main.html'%}
{% block content%}
<form method="POST", action="">
    {% csrf_token %}
    <p>Are You sure you want to delete {{obj}}</p>
    <a href="{{request.META.HTTP_REFER}}"></a>
    <input type="submit", value="confirm">

</form>
{% endblock %}

How it works:
1) The same delete room is going to be appear 
2) if user clicked it , redirects to delete_room.html which going to confirmation
3) if you click confirm button, it going to send a post request
4) the request gets that post request and delete that post
5) it redirects to home page without that deleted file

----------------------------------------------------------------------------------------------------------------------------

Search: 

in views.py:
def home(request):
    q = request.GET.get('q') if request.GET.get('q') != None else " "
    rooms = Room.objects.filter(
        Q(topic__name__icontains=q) |
        Q(name__icontains=q) |
        Q(descriptions__icontains=q)
        )
    topics = Topic.objects.all()
    context = {'rooms' : rooms,
               'topics' : topics}
    return render(request, 'base/home.html',context)

there is a difference this time in home page. let's see that

{% extends 'base/main.html' %}

{% block content %}

<style>
    .home-container{
        display: grid;
        grid-template-columns: 1fr 3fr;
    }
</style>
<h1>Home Page</h1>

<div class="home-container">
    <div>
        <h3>Browse topics</h3>
        <div>
            <ul>
                <li><a href="{% url 'home'%}">All</a></li>
            </ul>
        </div>
        {% for topic in topics %}
            <div>
                <ul>
                    <li><a href="{% url 'home' %}?q={{ topic.name }}">{{ topic }}</a></li>
                </ul>
            </div>
        {% endfor %}
    </div>
    <div>
        <div>
            <a href="{% url 'create-room' %}">Create Room</a>
            {% for room in rooms %}
                <div>
                    <a href="{% url 'update-room' room.id %}">Update Room</a>
                    <a href="{% url 'delete-room' room.id %}">Delete Room</a>
                    <span>@{{room.host.username}}</span>
                    <h4>{{room.id}} - <a href="{% url 'room' room.id %}">{{room.name}}</a></h4>
                    <small>{{room.topic.name}}</small>
                    <hr>
                </div>
            {% endfor %}
        </div>
    </div>



    
    
</div>

{% endblock %}

can you spot the difference. yes we added styling this time. 
we divided the parts into 2 columns, 1 for browsing topics which is there in Topic model and
other display according to our search

Take a close look at 
rooms = Room.objects.filter(
        Q(topic__name__icontains=q) |
        Q(name__icontains=q) |
        Q(descriptions__icontains=q)
        )

and


<form method="GET", action="{% url 'home'%}">
    <input type="text" name="q" placeholder="Search Rooms..." />
</form>

This is the actual deal. First we create a search bar where we can search using form
The form gets the value and assigns to query method.
the rooms filter the value and reload the homepage and shows the result
[Don't worry about that Q thing. That Q is used for or searching. 
to simply say, the search bar doesn't know what criteria you are going to type and python doesn't have or option in function
This is where that Q comes in. first it checks the result. if it matches any one, it return that search alone]






































































































































---------------------------------------------------------------------------------------------------

waste codes :
room = None
    for i in rooms:
        if i['id'] == int(pk):
            room = i
            
---------------------------------------------------------------------------------
"""

