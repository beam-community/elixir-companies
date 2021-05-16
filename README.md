![Elixir Companies](https://user-images.githubusercontent.com/73386/33328317-e6e58c6e-d416-11e7-9a16-b60700db0a51.png)

![](https://github.com/beam-community/elixir-companies/workflows/.github/workflows/elixir.yml/badge.svg?branch=master)

# Elixir Companies

A [collection of companies using Elixir](https://elixir-companies.com/) in production.

Proudly built with [Phoenix](https://phoenixframework.org).

## Development

1. Install dependencies with `mix deps.get`
1. Install Node.js dependencies with `cd assets && npm install`
1. Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Localization

In order to add a new language to the available list of locales, you have to do the following:
- `mix gettext.extract` in order to extract all the latest gettext msgids from the code
- `mix gettext.merge --priv/gettext` in order to merge the latest msgids with the locales.
- `mix gettext.merge --priv/gettext --locale locale_code` in order the generate the files for the new locale.
- Edit the `default.po` and `errors.po` in the `priv/gettext/{locale_code}/LC_MESSAGES/` dir. You leave the msgids intact and only touch the msgstr fields, where you translate the text accordingly.
