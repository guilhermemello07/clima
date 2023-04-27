# clima
A simple Clima app, developed for the Angela Yu iOS course

As this app was developed for the course mentioned above, I will include here in the README the highlights of this section of the course, what I understood from the lessons regarding each concept and what are the things I think I need to improve:

## WeatherVireController file

This section was the first in the course that made use of the Delegate pattern, and the things that I found most interesting are:

First of all, in order to use the DELEGATE methods, I need to define my WeatherViewController as a subclass of the UITextFieldDelegate too, as I did on line 11. [adopt the UITextFieldDelegate protocol]

After doing this, the second step is to actually delegate all UITextFields I have in the app to SELF, or better said, telling the UITextField that it should inform and DELEGATE all the actions to the WeatherViewController, and this piece of code is on line 20, inside the ViewDidLoad( ) function.

One thing to keep in mind is that, every time I want the textField to send the message “the user end editing me” I need to call the endEditing(true) method on the textField, which I did on lines 24, and 29.

For the purpose of this app, I needed to use and define three different textField Delegate methods, and here I will explain each one of them:

	textFieldShouldReturn( ) -> Bool { … }
	This method is used to define the behavior of the textField when the user press the return button on the keyboard, and as we want the textField to return and process information, we actually called some methods inside this function, the endEditing(true) to make the textField inform that it is done editing, and the resignFirstResponder( ) so the keyboard hides itself when the user interacts with any other thing in the app.

	textFieldShouldEndEditing( ) -> Bool { … }
	here I can define some behavior to allow or not the textField to endEditing, for example, here in this app I only allowed the textField to endEditing if the textField.text property is anything different than an EMPTY STRING, as I did on line 41, 42 and 43.

	textFieldDidEndEditing( ) { … }
	This function allows us to control the behavior of the textField when it is done, so we can define some actions or behavior moments before the textField endEditing, for example, in this code, I have defined the cityLabel.text field to be equal to what was inserted by the user in the textField.text property, as it is on line 36.
  
## WeatherManager and WeatherData files

In this project, we used the Open Weather Map API, and to use it, the course provided a deep explanation. Below are my thoughts about it:

How can I make requests for LIVE Weather data by using the Open Weather Map API?
Through the API’s documentation [ https://openweathermap.org/current ], if we want to get the live weather by the city name, we can use the following: 

https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API Key} 
* One pattern that we can spot here is the fact that we separate the parameters for the API request through the use of an &.
    * So, we have two parameters:
        * appid = which is our api key.
        * q = which is our query, in this case, the city name.

Another thing that we can incorporate into our API’s request, is regarding to the unit that we want the information to be responded, and to do this, the only thing we need to include, is the units parameter:
So, for example, my request for the live weather for Rome, with my api key, and asking for the units to be in the metric system:
[ https://api.openweathermap.org/data/2.5/weather?q=rome&appid=9f0e78c6d9bc2de2e10c19e9ed120ba3&units=metric ]

NOTE: The two most used unit for this measure are:
* metric
* imperial

How can I make this request through my app?
First of all, in order to manage the weather inside my app, I will create a new Swift file, inside the MODEL folder, which I can name WeatherManager.
Inside the WeatherManager file, I created a WeatherManager struct in order to hold both the base url, and I also created a method to help me fetch the weather data, using the base url string with the required pieces to create the right url for the specific city name:

On line 15 I did the string completion to append the base string, which is the weatherURL to the function’s parameter cityName, with the required pieces in between [&q=] 

After this, I just created an WeatherManager object into my WeatherViewController file, called it weatherManager, and call the fetchWeatherData( ) function when appropriate.
And now, I can print to the console the url that let me access the weather data for that specific city.

How can I use URLSessions for Networking?

In order to perform a networking between my app and the Open Weather api, I need to complete the 4-step process:
	1- create a URL
	2- create a URLSession 
	3- give the session a task
	4- Start the task.

There are two functions that need our attention here!
	1- performRequest(urlString: String) { … }
	2- handle(data: Data?, response: URLResponse?, error: Error?) { … }

1- performRequest(urlString: String) { … }
This function’s intent is to perform the 4-step process to get the data from a URL Request.
First of all, I created a URL using the URL structure Apple provides [22]

After, I passed to the next step, which is to create a session, and here I just used the URLSession(configuration: .default) initializer in order to create the URLSession and assign it to the newly created session variable.

The third step is to give that specific session a task, and I can accomplish this by using the session method dataTask(with: url, completionHandler: handler[which is a function I created / closure]).
Here, as we can see, we need a function to be triggered when the task completes, which we will create and pass as an argument for the completionHandler.

Before going to the function number two, we just need to resume( ) the task, which will continue the task beginning where it was left.

2- handle(data: Data?, response: URLResponse?, error: Error?) { … }
This function was created to satisfy the step number three of the previous function requirements, which is to be used into the dataTask method from the session we initialized to deal with our URL Request.

The name of the function is just to reming us that it will handle the completion of the dataTask we asked the session to do.

We begin this function declaration by providing the arguments needed by the completionHandler in the dataTask method, which are: Data? [an optional Data structure], URLResponse? [an optional URL Response], and Error? [an optional error]

In the body of the function, we begin by verifying if there’s an error in the dataTask we performed, and if we receive an error, the function should return without doing anything else, otherwise, if there’s no error, then the function can continue to the next step.

Here, I used the if let … statement to assure that the optional data can be passed to a safeData with no nil value.

If the safeData is now available, I can convert it to a dataString, which is accomplished by the use of the String(data: safeData, encoding: .utf8) method.

If we get this dataString, then we can inspect it at this stage, but we will eventually use the JSON Parsing in order to get the information we need from this dataString.

### Parsing JSON with JSONDecoder

When parsing JSON data, the first thing I need to do is to create a struct that has the properties that I need to access from the JSON object, and those properties NEED TO BE NAMED THE SAME they are named in the JSON file. Also, I cannot forget to make the struct and every subsequent struct involved in this JSON decoding, to adopt the CODABLE protocol.

After creating the struct, we need to make a function to parseJSON inside the structure that really needs to parse the JSON, in this app, for example, the structure responsible for this is the WeatherManager.

Inside the MODEL folder, there are two files that I needed to create in order to get my app to run:

First of all, I needed to create the WeatherManager Struct, and as I have written here before, I needed to perform a request for the data to be provided, which I did through the performRequest() method, and this method gave me a Data datatype, which I need to parse into a JSON formatted data:

On line 40, I have created the parseJSON method, which requires the weatherData parameter, that is os type Data [the type that is given for us from the dataTask() method called on line 25]. This function creates a decoder, which is the name I gave to the JSONDecoder() that I created in order to parse this Data into a JSON formatted data.
This is achieved through the use of a DO … TRY / CATCH block of code, where:
	on line 42 I initiate the DO,
	on line 43 I TRY to decode the decoder data through the use of the .decode( Type: From: ) method, and here, the data type is obviously the WeatherData Struct which adopts the DECODABLE protocol, and it decodes from the weatherData that was passed as a parameter to the function.
	from line 44 to line 46, I’m only printing to the console some values that I need to check.
	on line 47 I’m CATCHing any error that eventually may occur, and here, I’m only printing them.

As we could see, in order to get the decodedData, we needed to create a WeatherData struct, which adopts the DECODABLE protocol, and I did it in the WeatherData file.

As I wanted to retrieve the -> weather[0].description value, I needed to create all the structure that lead the data from the outside of the structure to there, as well as some other values, like main.temp, and main.feels_like.

Create a WeatherModel and Understand Computed Properties 
In order to better hold all the values I need to deal with, it’s mandatory to create a new structure, called WeatherModel:

This struct was created to hold all the weather values that we need to pass through the app, for example:
The variable cityName will hold the name of the city that the JSON parser retrieves.
One other thing that we need to take care here is the conditionName variable, which is like a function. And this type of variable is called computed variables, because we use the Swift functionality of letting the variable compute it’s own value, like a function.

The conditionName variable takes into account the Open Weather API documentation, which has a section called list of condition codes, and these codes are the ones that I’m considering in the SWITCH statement, at the same time, the variable returns the String containing the name of the apple SF Logo that we intend to use in our app based on the weather condition code.

So, how did I used this struct?

So, basically, as the app is not completed yet, I first got the values for the variables that will populate my WeatherModel structure, and I did this through the parseJSON function, which stored all the information inside the decoder object, then I used the decodedData in order to retrieve and store the information I want, and here they are: name, description, temp, and id, which I used to populate my WeatherModel object on line 48.
Later, I just printed some information to the screen, as from now, I will figure out how to display these information to the user!

How to transfer the WeatherModel data from the WeatherManager to the WeatherViewController?
To accomplish this, I will use the Protocol and Delegate methods!

First of all, inside the structure or class that will use the protocol, I create it.
Outside the struct itself, I declare the protocol and declare what are the methods that any one that adopts this protocol will have to define, and here, I named the protocol as WeatherManagerDelegate, and just defined two methods, the didUpdateWeather to be implemented when I got an updated weather, and the didFailWithError, which I can use to define some ways to handle errors that may arise.

The next important step inside this file, is to obviously, create the optional DELEGATE variable, to be used when we need access to one of the methods that the protocol requires. [line 19]

Where did I use these methods?

Inside the performRequest() function, if I do get the dataTask from my session object returned properly, and managed to get the safeData variable, then I need to create the weatherModel data through the use of the parseJSON method, and then I can ask the delegate to call the didUpdateWeather() method.

And here, as I want to use the information retrieved from the parseJSON data inside my weatherViewController, I need to make it conform to the WeatherManagerDelegate protocol, and also implement the methods:

To make it adopt the WeatherManagerDelegate protocol, I just need to declare it in the WeatherViewController declaration, as well as create a weatherManager object from the WeatherManager struct [line 18], define the delegate variable inside the weatherManager variable to be self [WeatherViewController], and finally, define the methods asked by the protocol.

### Updating the UI by using the DispatchQueue

Inside the didUpdateWeather( ) method, I need to call the DispatchQueue.main.async { … } in order to let the main thread update the UserInterface, because this is the only way to do this!

Inside the DispatchQueue.main.async, I updated the temperatureLabel.text property to show the temperatureString from my weather object, also I updated the cityLabel.text in order to change the name of the city from my weather object, and finally, I update the system image related to the SF Symbol for the weather, and here, I just updated the conditionImageView.image property to be equal to a UIImage(systemName: ) and this is important to tell Xcode that it need to match the weather.conditionName to a UIImage that has the same systemName.

## Using CoreLocation to get the user's location data

The first thing we need to consider when dealing with core location is, obviously, to import apple’s library that deals with this:

CoreLocation [https://developer.apple.com/documentation/corelocation] documentation.

The second step is to create a variable called locationManager, which is, of course, an instance of the CLLocationManager( ) class.

	<code>
		let locationManager = CLLocationManager()
	</code>

After this step, we need to include some functionality to be done as soon as the app loads, so, inside our viewDidLoad( ) function, we add:

	<code>
		locationManager.requestWhenInUseAuthorization( ) 
		locationManager.requestLocation( )
	</code>

The first method call, the locationManager.requestWhenInUseAuthorization( ) is to ask the user if our app can get access to his location, and we need to include this functionality inside our info.plist folder, which I will explain using an image.

Inside the info folder, I just clicked on the + (add) button in order to add another Information Property List, and to add the one that I intend to use in the app, I needed to add the “Privacy - Location When In Use Usage Description” and also add a description to explain to the user the reason why our app need his location.
