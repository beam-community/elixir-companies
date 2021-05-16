defmodule CompaniesWeb.JobComponent do
  use CompaniesWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <li class="group">
      <a href="<%= @job.link %>" target="_blank" class="block hover:bg-gray-50">
        <div class="px-4 py-4 sm:px-6">
          <div class="flex items-center justify-between">
            <p class="text-sm font-medium truncate text-brand-purple group-hover:text-brand-pink">
              <%= @job.name %>
            </p>
            <div class="flex flex-shrink-0 ml-2">
              <%= case @job.type do %>
                <% "full-time" -> %>
                  <p class="inline-flex px-2 text-xs font-semibold text-green-800 bg-green-100 rounded-full leading-5">
                    <%= gettext("Full-Time") %>
                  </p>
                <% "contract" -> %>
                  <p class="inline-flex px-2 text-xs font-semibold text-green-800 bg-blue-100 rounded-full leading-5">
                  <%= gettext("Contract") %>
                  </p>
               <% end %>
            </div>
          </div>
          <div class="mt-2 sm:flex sm:justify-between">
            <div class="sm:flex">
              <p class="flex items-center text-sm text-gray-500">
                <!-- Heroicon name: solid/building -->
                <svg xmlns="http://www.w3.org/2000/svg" class="flex-shrink-0 mr-1.5 h-5 w-5 text-brand-purple group-hover:text-brand-pink" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>

                <%= @company.name %>
              </p>
              <p class="flex items-center mt-2 text-sm text-gray-500 sm:mt-0 sm:ml-6">
                <!-- Heroicon name: solid/location-marker -->
                <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400 group-hover:text-brand-purple" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
                </svg>
                <%= @job.location %>
              </p>
            </div>
            <div class="flex items-center mt-2 text-sm text-gray-500 sm:mt-0">
              <!-- Heroicon name: solid/calendar -->
              <svg class="flex-shrink-0 mr-1.5 h-5 w-5 text-gray-400 group-hover:text-brand-purple" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
              </svg>
              <p>
                Posted on
                <time datetime="<%= @job.date %>"><%= @job.date %></time>
              </p>
            </div>
          </div>
        </div>
      </a>
    </li>
    """
  end
end
