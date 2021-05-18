defmodule CompaniesWeb.CompanyComponent do
  use CompaniesWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <li class="flex flex-col text-center bg-white rounded-lg shadow group col-span-1 divide-y divide-gray-200">
      <div class="flex flex-col flex-1 p-8">
        <a href="<%= @company.url %>" target="_blank" class="mx-auto">
          <%= if length(@company.jobs) == 0 do %>
            <!-- Heroicon name: solid/building -->
            <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-full text-gray-300 group-hover:text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          <% else %>
            <!-- Heroicon name: solid/briefcase -->
            <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-full text-brand-purple group-hover:text-brand-pink" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            <p class="-mt-2"><%= gettext("Hiring") %><p>
          <% end %>
        </a>
        <h3 class="mt-6 text-xl font-bold text-brand-purple group-hover:text-brand-pink"><%= @company.name %></h3>
        <dl class="flex flex-col justify-between flex-grow mt-1">
          <dt class="sr-only">Industries</dt>
          <dd class="text-sm text-gray-500">
            <%= for industry <- @company.industries do %>
              <span><%= industry %></span>
            <% end %>
          </dd>
          <dt class="sr-only">Contact Information</dt>
          <dd class="mt-3">
            <div class="flex justify-center space-x-6">
              <%= if @company.blog && @company.blog != "" do %>
                <a href="<%= @company.blog %>" target="_blank" class="text-gray-400 hover:text-gray-500">
                  <span class="sr-only">Blog</span>
                  <!-- heroicons outline/book-open -->
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                  </svg>
                </a>
              <% end %>

              <a href="https://github.com/<%= @company.github %>" target="_blank" class="text-gray-400 hover:text-gray-500">
                <span class="sr-only">GitHub</span>
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path fill-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z" clip-rule="evenodd" />
                </svg>
              </a>
            </div>
          </dd>
          <dt class="sr-only"><%= gettext("Locations") %></dt>
          <dd class="mt-3">
            <%= for location <- @company.locations do %>
              <span class="px-2 py-1 text-xs font-medium text-white rounded-full bg-brand-purple group-hover:bg-brand-pink"><%= location %></span>
            <% end %>
          </dd>
        </dl>
      </div>
    </li>
    """
  end
end
