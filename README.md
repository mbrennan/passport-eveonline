passport-eveonline
==================

[Passport](http://passportjs.org/) strategy for authenticating with
[EVE Online](http://www.eveonline.com/) using the
[OAuth 2.0 API](http://oauth.net/2/).

This module lets you authenticate using EVE Online in your
[node.js](http://nodejs.org/) applications. By plugging into Passport,
EVE Online authentication can be easily and unobtrusively integrated into any
application or framework that supports
[Connect](http://www.senchalabs.org/connect/)-style middleware, including
[Express](http://expressjs.com/).

Install
-------

    $ npm install passport-eveonline

Usage
-----

#### Configure Strategy

The EVE Online authentication strategy authenticates users with an active
EVE Online account using OAuth 2.0 tokens. The strategy requires a `verify`
callback, which receives information about the character who authenticated.
The `verify` callback must call `done` providing an object used to complete
authentication.

In order to identify your application to EVE Online, first start by creating
an application on the
[EVE Developer's website](https://developers.testeveonline.com/applications).
When you create an application, you must provide a `Callback URL` which EVE
Online will redirect to once your user has authenticated.
Once you create your application on the EVE Developer's website, you will be
provided with a `Client ID` and a `Secret Key`.  When you construct a new
instance of the strategy, you should provide the `Client ID` and `Secret ID`
provided to you along with your `Callback URL` within `options`.

All of the information provided in `characterInformation` parameter to the
`verify` callback is documented the EVE Developer's website under the
[Single Sign-On (SSO) section](https://developers.testeveonline.com/resource/single-sign-on).
Here's an example of how to construct and configure the strategy:

    passport.use(new EveOnlineStrategy({
        clientID: EVEONLINE_CLIENT_ID,
        secretKey: EVEONLINE_SECRET_KEY,
        callbackURL: "http://mysite.com/auth/eveonline/callback"
      },
      function(characterInformation, done) {
        User.findOrCreate(
          { characterID: characterInformation.characterID },
          function (err, user) {
            return done(err, user);
          }
        );
      }
    ));

- Note:  The authentication token and refresh token are not provided because in
the initial release of the EVE Online SSO API does not provide any other API
calls other than authentication.  Refreshing tokens is also not possible.

You may also override the default authorization, token, and verify URLs by
providing them in the options:

    passport.use(new EveOnlineStrategy({
        ...
        authorizationURL:   'https://some.other.url.com/auth',
        tokenURL:           'https://some.other.url.com/token',
        verifyURL:          'https://some.other.url.com/verify'
        ...
        }))
    ...

#### Authenticate Requests

Use `passport.authenticate()`, specifying the `'eveonline'` strategy, to
authenticate requests.

For example, as route middleware in an [Express](http://expressjs.com/)
application:

    app.get('/auth/eveonline',
      passport.authenticate('eveonline'));

    app.get('/auth/eveonline/callback',
      passport.authenticate('eveonline', {
        successRedirect: '/',
        failureRedirect: '/login'
      })
    );

## Tests

    $ npm install
    $ npm test

## Credits

  - [Mike Brennan](http://github.com/mbrennan)

## License

[The ISC License](http://en.wikipedia.org/wiki/ISC_license)

Copyright (c) 2014 Mike Brennan
