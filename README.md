![Elixir Companies](https://user-images.githubusercontent.com/73386/33328317-e6e58c6e-d416-11e7-9a16-b60700db0a51.png)

[![Build Status](https://travis-ci.org/doomspork/elixir-companies.svg?branch=master)](https://travis-ci.org/doomspork/elixir-companies)

# Elixir Companies

A [collection of companies using Elixir](https://elixir-companies.com/) in production.

Proudly built with [Phoenix](https://phoenixframework.org).

### Adding a new company to the list

- Sign with your GitHub account.
- Click on `Add a company` button and you will be redirected to a form.
- Fill all required data about the company and submit it.

After that, the admin needs to validate the request.

With everything OK the company will be approved and will appear in companies list.

### Adding a new job opportunity for a company

Once your company is available on the list, you are able to add a new Job opportunity for the given company.

- Sign with your GitHub account.
- Click on `+ Add a Job` link and you will be redirected to a form.
- Fill all required data about the company and submit it.

## Development

1. Install dependencies with `mix deps.get`
1. Create and migrate your database with `mix ecto.setup`
1. Install Node.js dependencies with `cd assets && npm install`
1. Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

_Note_: You need to set up a [GitHub Application](https://developer.github.com/) and ensure `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` are available to your application.

_Note_: You need to have Postgres version 9.5+, due to our use of certain features that are fairly new (JSONB Data Type + ON CONFLICT query).

_Note_: If for some reason you reset the database on your machine, you will see an error as the browser has cookies for a user that does not exist in the database. You will need to clear the cookies and site data for the page on your browser and refresh the page to remove the error.
