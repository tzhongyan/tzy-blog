# Rails Task for COS30041 
This repo is a code dump for tasks in my uni. Its sheer purpose is to enable me to work on the same project across different devices, like you know, school lab's bloody computers.

# Software Requirements
Not really requirements, just the versions of softwares that I'm using which are working

* [Ruby ^2.4.2](https://www.ruby-lang.org/en/downloads/)
* [Gem ^2.6.12](https://rubygems.org/pages/download) (should be automatically installed when you installed ruby)
* [nodeJS ^8.9.1](https://nodejs.org/en/download/), optional but required for deploying on production
* [PostgreSQL 9.6](https://www.postgresql.org/download/)
* Super user permission for the computer on deployment

# Deploying the Application on Production
## 1. Installing passenger + nginx
First get passenger's PGP key and HTTPS supports
```bash
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
```

Add the passenger repository into APT, then install it with nginx
```bash
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

sudo apt-get install -y nginx-extras passenger
```
(More information from https://www.phusionpassenger.com/library/install/nginx/install/oss/trusty/)

## 2. Setting up Rails application
Clone this repository:
```
git clone git@github.com:tzhongyan/tzy-blog.git
```

Change into the directory by `cd tzy-blog` and install the required gem:
```
bundler install
```
If your computer complained that you have no bundler installed, install it using `gem install bundler`.

After installing, copy `.env.example` file into `.env`, and open it up using your favourite text editor. key in the relevant fields with their respective values. Note that the `SECRET_KEY_BASE` field is obtainable by running `rake secret` on the root directory of the rails application.

Set up the database for production:
```
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production
```

Compile the webpack
```
rake assets:precompile RAILS_ENV=production
```

Remember this Rails directory (obtainable by `pwd`), as we are going to need it for the next deployment step.

## 3. Deploying it on nginx via Passenger
Open up `/etc/nginx/nginx.conf` (you might need super user permission for editing the file), and you will see a line like this:
```nginx
# include /etc/nginx/passenger.conf;
```
Remove the `#` character to be like this
```nginx
include /etc/nginx/passenger.conf;
```

Then, open the file `/etc/nginx/sites-available/default` (make a backup by `cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig`) and replace the file with following code:
```nginx
server {
        listen 80;
        listen [::]:80;

        root /path/to/your/rails/application/public;

        server_name _;

        passenger_app_root /path/to/your/rails/application;
        passenger_enabled on;
        rack_env production;
}
```
Replace `/path/to/your/rails/application` with the directory to your Rails application in step 2, and be sure that the `root` has point to public. Save the code and restart nginx:
```
sudo service nginx restart
```

And your application should be running on port 80 =)

# License
MIT.