![Elixir Companies](https://user-images.githubusercontent.com/73386/33328317-e6e58c6e-d416-11e7-9a16-b60700db0a51.png)

![main branch badge](https://github.com/beam-community/elixir-companies/actions/workflows/ci.yaml/badge.svg?branch=main)

# Elixir Companies

A [collection of companies using Elixir](https://elixir-companies.com/) in production.

Proudly built with [Phoenix](https://phoenixframework.org).

### Adding a new company be showcased

- Fork the repo
- Use the helper Mix task to generate the file:
  ```sh
  mix create_company_file {{ your company name }}
  ```

**-- OR --**

- Add your company information to a new `/priv/companies/{{company_name}}.exs` in the following format:

  ```elixir
  # Company file for Acme Corp
  # Created on: 2024-01-01

  %{
    name: "Acme Corp",
    website: "https://example.com/",
    github: "https://github.com/example/acme-corp",
    # reference lib/companies/industries.ex for a list of recommended industries to use here
    industry: "Information Technology",
    location: %{
      city: "City",
      state: "State",
      country: "Country"
    },
    description: """
    Description of Acme Corp goes here.
    """,
    last_changed_on: ~D[2024-01-01]
  }
  ```

- Run `mix validate_company_file priv/companies/your-new-file.exs` to validate the new company file.
- Create a pull request adding the new company file

## Development

1. Install current elixir, erlang and nodejs versions

   1. This project uses [asdf](https://asdf-vm.com/) to manage the language versions of the project.
   1. Follow the instructions on [asdf#getting-started](https://asdf-vm.com/guide/getting-started.html) to install asdf.
   1. Once complete, run the following command to install the language versions:

      ```sh
      asdf install
      ```

   **-- OR --**

   1. If you manage your language versions differently, please reference [~/.tool-versions](.tool-versions) for the specific versions to run the project.

1. Install elixir and nodejs dependencies with `mix setup`
1. Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Localization

In order to add a new language to the available list of locales, you have to do the following:

- `mix gettext.extract` in order to extract all the latest gettext msgids from the code
- `mix gettext.merge --priv/gettext` in order to merge the latest msgids with the locales.
- `mix gettext.merge --priv/gettext --locale locale_code` in order the generate the files for the new locale.
- Edit the `default.po` and `errors.po` in the `priv/gettext/{locale_code}/LC_MESSAGES/` dir. You leave the msgids intact and only touch the msgstr fields, where you translate the text accordingly.
