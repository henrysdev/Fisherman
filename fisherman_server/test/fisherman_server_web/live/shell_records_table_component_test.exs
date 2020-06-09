defmodule FishermanServerWeb.ShellRecordsTableComponentTest do
  use FishermanServerWeb.ConnCase
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest

  alias FishermanServer.TestFns

  test "disconnected and connected mount", %{conn: conn} do
    user = TestFns.add_user!()

    conn =
      get(conn, "/shellfeed", %{
        "user_id" => user.uuid
      })

    assert html_response(conn, 200) =~ "Time (UTC)"

    {:ok, _view, _html} = live(conn)
  end

  test "no session error on mount", %{conn: conn} do
    assert {:error, :nosession} = live(conn, "shellfeed")
  end
end
