README
======

Introduction
------------

This is an app mocking the IMDB. The two main categories are movies and actors. The most information are from IMDB and stored 
in local database. Also implemented are custom searching and querying functions showing trends in motion picture industry. As 
a information displaying app, main effort is on showing the data. Simple CRUD functions are implemented to manage the data.

Build
-----
This app is built with Rails using mongodb database with the mongoid orm. The NoSQL solution makes database design quite flexible. 
Images/videos are uploaded onto Amazon S3 through background processing with redis and sidekiq. The web interface is designed based on Foundaation 
CSS framework.

Todo
----
1. Finish CRUD functionality
2. Add real movie/actor data
3. Testing
4. Incorporating JS frameworks  

Other
-----
*  Start Redis server  redis-server
*  Start application 
*  Start sidekiq  bundle exec sidekiq