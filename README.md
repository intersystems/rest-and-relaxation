# Rest & Relaxation
### By Michael Smart

__Description:__ An example of a REST web service implemented with ObjectScript that demonstrates a number of development best practices. This is the companion to a live webinar presented by InterSystems Learning Services on December 7, 2017.

__Requirements:__ 2016.2 or higher.

__To install:__

1. Create the CSP application `/rnr` for the desired namespace.
2. Set the __Dispatch Class__ option for `/rnr` to `RNR.Service`.
3. Load the files in the __RestAndRelaxation__ directory to a new project using Atelier.
4. Compile the new project in Atelier.

__Instructions:__

You can consult the URLMap in the RNR.Travel.BestPractices class to see which resources are available. Here are a few examples you can try with your favorite REST testing utility.

* To retrieve a list of travel reservations, make a GET request to `http://<server>:<port>/rnr/travel/reservations`.

* To add a new travel reservation, send a POST request to `http://<server>:<port>/rnr/travel/reservation` using the following JSON as an example for the request body:

```
{
    "customer": "Michael",
    "startLocation": "Boston",
    "destination": "London",
    "startDate": "2018-02-01",
    "endDate": "2018-02-10"
}
```

Enjoy!

_— MS_