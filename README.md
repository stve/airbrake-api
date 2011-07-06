Hoptoad API
===========

An unofficial Ruby library for interacting with the [Hoptoad API](http://hoptoadapp.com/pages/api)

Usage
-----

The first thing you need to set is the account name.  This is the same as the web address for your account.

    Hoptoad.account = 'myaccount'

Then, you should set the authentication token.

    Hoptoad.auth_token = 'abcdefg'

If your account uses ssl then turn it on:

    Hoptoad.secure = true

Optionally, you can configure through a single method:

    Hoptoad.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)

Once you've configured authentication, you can make calls against the API.  If no token or authentication is given, a HoptoadError exception will be raised.

Finding Errors
--------------

Errors are paginated, the API responds with 25 at a time, pass an optional params hash for additional pages:

    Hoptoad::Error.find(:all)
    Hoptoad::Error.find(:all, :page => 2)

To find an individual error, you can find by ID:

    Hoptoad::Error.find(error_id)

Find *all* notices of an error:

    Hoptoad::Notice.find_all_by_error_id(error_id)

Find an individual notice:

    Hoptoad::Notice.find(notice_id, error_id)

To resolve an error via the API:

    Hoptoad::Error.update(1696170, :group => { :resolved => true})

Recreate an error:

    STDOUT.sync = true
    Hoptoad::Notice.find_all_by_error_id(error_id) do |batch|
      batch.each do |notice|
        result = system "curl --silent '#{notice.request.url}' > /dev/null"
        print (result ? '.' : 'F')
      end
    end

Projects
--------

To retrieve a list of projects:

    Hoptoad::Project.find(:all)

Responses
---------

If an error is returned from the API.  A HoptoadError will be raised.  Successful responses will return a Hashie::Mash object based on the data from the response.


Requirements
------------

* HTTParty
* Hashie

Contributors
------------

* Matias Käkelä (SSL Support)
* Jordan Brough (Notices)
