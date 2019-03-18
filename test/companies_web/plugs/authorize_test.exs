defmodule CompaniesWeb.Plugs.AuthorizeTest do
  use CompaniesWeb.ConnCase

  import Companies.{Factory, TestHelper}

  alias CompaniesWeb.Plugs.Authorize

  describe "call/2" do
    test "allows logged in users to continue" do
      user =
        :user
        |> build()
        |> Map.put(:maintainer, false)

      assert %{halted: false} =
               build_conn()
               |> assign(:current_user, user)
               |> Authorize.call([])
    end

    test "allows logged in maintainers to continue" do
      user =
        :user
        |> build()
        |> Map.put(:maintainer, true)

      assert %{halted: false} =
               build_conn()
               |> assign(:current_user, user)
               |> Authorize.call(maintainer: true)
    end

    test "prohibits logged in users from accessing maintainer only routes" do
      user =
        :user
        |> build()
        |> Map.put(:maintainer, false)

      assert build_conn()
             |> with_session()
             |> fetch_flash()
             |> assign(:current_user, user)
             |> Authorize.call(maintainer: true)
             |> redirected_to(401) =~ "/"
    end

    test "prohibits logged out users from continuing" do
      assert build_conn()
             |> with_session()
             |> fetch_flash()
             |> Authorize.call([])
             |> redirected_to(401) =~ "/"
    end
  end
end
