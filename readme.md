# docker-sendy
Dockerized Sendy application with [one-click deployment setup for Railway](https://railway.app/new/template/t2Bx2s?referralCode=8PomhT) 

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/t2Bx2s?referralCode=8PomhT)

[Sendy](https://sendy.co/?ref=IKsrE) is a self-hosted email newsletter application that lets you send trackable emails via Amazon Simple Email Service (SES). This makes it possible for you to send authenticated bulk emails at an insanely low price without sacrificing deliverability.

For more information and related downloads for Sendy Server and other products, please visit [Sendy.co](https://sendy.co/?ref=IKsrE).

## Setup

* Create a new project on Railway [using this template](https://railway.app/new/template/t2Bx2s?referralCode=8PomhT)
* Set the following environment variables:
  * `SENDY_FQDN` - The URL of your Sendy instance
  * `MYSQL_HOST` - The hostname of your database
  * `MYSQL_USER` - The username of your database
  * `MYSQL_PASSWORD` - The password of your database
  * `DB_PORT` - The port of your database
* Deploy the project
* Visit the URL of your project to complete the setup.
* You're done!

## Thanks
Adapted from [bubbajames-docker/sendy](https://github.com/bubbajames-docker/sendy)

## License
MIT &copy; [Kamran Ahmed](https://github.com/kamranahmedse)
