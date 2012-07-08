# Airbrake API [![Build Status](https://secure.travis-ci.org/spagalloco/airbrake-api.png)](http://travis-ci.org/spagalloco/airbrake-api)

A ruby client for the [Airbrake API](http://help.airbrake.io/kb/api-2/api-overview)

## Usage

## Changes in 4.0

AirbrakeAPI has been completely rewritten in 4.0.  Why the high version number?
This was the first gem I ever wrote and it's wandered a path that started with
ActiveResource, followed by HTTParty, and now Faraday.  Along the way, AirbrakeAPI
has lost it's ActiveRecord-like syntax for a more concise and simple API.  Instead
of using classes such as `AirbrakeAPI::Error`, the entire API is contained within
`AirbrakeAPI::Client`.

The following classes are now deprecated:

* `AirbrakeAPI::Error`
* `AirbrakeAPI::Notice`
* `AirbrakeAPI::Project`

## Configuration

AirbrakeAPI can be configured by passing a hash to the configure method:

    AirbrakeAPI.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)

or via a block:

    AirbrakeAPI.configure do |config|
      config.account = 'anapp'
      config.auth_token = 'abcdefg'
      config.secure = true
    end

## Finding Errors

Errors are paginated, the API responds with 25 at a time, pass an optional params hash for additional pages:

    AirbrakeAPI.errors
    AirbrakeAPI.errors(:page => 2)

To find an individual error, you can find by ID:

    AirbrakeAPI.error(error_id)


## Finding Notices

Find *all* notices of an error:

    AirbrakeAPI.notices(error_id)

Find an individual notice:

    AirbrakeAPI.notice(notice_id, error_id)

To resolve an error via the API:

    AirbrakeAPI.update(1696170, :group => { :resolved => true})

Recreate an error:

    STDOUT.sync = true
    AirbrakeAPI.notices(error_id) do |batch|
      batch.each do |notice|
        result = system "curl --silent '#{notice.request.url}' > /dev/null"
        print (result ? '.' : 'F')
      end
    end

## Projects

To retrieve a list of projects:

    AirbrakeAPI.projects

## Deployments

    AirbrakeAPI.deployments

## Responses

If an error is returned from the API, an AirbrakeError exception will be raised.  Successful responses will return a Hashie::Mash object based on the data from the response.

## Contributors

* [Matias Käkelä](https://github.com/massive) - SSL Support
* [Jordan Brough](https://github.com/jordan-brough) - Notices
* [Michael Grosser](https://github.com/grosser) - Numerous performance improvements and bug fixes
* [Brad Greenlee](https://github.com/bgreenlee) - Switch from Hoptoad to Airbrake
