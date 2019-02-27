![Elixir Companies](https://user-images.githubusercontent.com/73386/33328317-e6e58c6e-d416-11e7-9a16-b60700db0a51.png)

[![Build Status](https://travis-ci.org/doomspork/elixir-companies.svg?branch=master)](https://travis-ci.org/doomspork/elixir-companies)

# Elixir Companies

A [collection of companies using Elixir](https://elixir-companies.com/) in production.

Proudly built with [Phoenix](https://phoenixframework.org).

## Running

1. Install dependencies with `mix deps.get`
1. Create and migrate your database with `mix ecto.setup`
1. Install Node.js dependencies with `cd assets && npm install`
1. Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

_Note_: You need to setup a [GitHub Application](https://developer.github.com/) and ensure `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` are available to your application. 

_Note_: If for some reason you reset the database on your machine, you will see an error as the browser has cookies for a user that does not exist in the database. You will need to clear the cookies and site data for the page on your browser and refresh the page in order to remove the error.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.
