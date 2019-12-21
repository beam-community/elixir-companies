defmodule JobCheckerTest do
  use Companies.DataCase

  alias Companies.{Jobs, PendingChanges, JobChecker}

  describe "check_job/1" do
    setup do
      bypass = Bypass.open(port: 9002)
      job = insert(:job, url: "http://localhost:9002/")
      editor_user = insert(:user)

      Application.put_env(:companies, :jobs_url_checker, user_id: editor_user.id)

      {:ok, bypass: bypass, job: job, editor_user: editor_user}
    end

    test "job URL responded with HTTP 200", %{bypass: bypass, job: job} do
      Bypass.expect_once(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 200, "pong")
      end)

      JobChecker.check_job(job)

      assert %{total_entries: 0} = PendingChanges.all()
    end

    test "job URL responded with HTTP 503", %{bypass: bypass, job: job} do
      Bypass.expect_once(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 503, "pong")
      end)

      JobChecker.check_job(job)

      assert %{total_entries: 0} = PendingChanges.all()
    end

    test "job URL isn't there", %{bypass: bypass, job: job} do
      Bypass.down(bypass)

      JobChecker.check_job(job)

      assert %{total_entries: 0} = PendingChanges.all()
    end

    test "job URL responded with HTTP 404", %{bypass: bypass, job: job, editor_user: editor_user} do
      Bypass.expect_once(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 404, "No longer here")
      end)

      JobChecker.check_job(job)

      assert %{entries: [entry], total_entries: 1} = PendingChanges.all()

      assert(entry.action == "delete")
      assert(entry.resource == "job")
      assert(entry.changes["id"] == job.id)
      assert(entry.user_id == editor_user.id)
    end

    test "when there is already a pending PendingChange for the other job", %{bypass: bypass, job: job} do
      Bypass.expect(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 404, "No longer here")
      end)

      another_job = insert(:job, url: "http://localhost:9002/")

      JobChecker.check_job(job)
      JobChecker.check_job(another_job)

      assert %{total_entries: 2} = PendingChanges.all()
    end

    test "when there is already a pending PendingChange for the same job", %{bypass: bypass, job: job} do
      Bypass.expect(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 404, "No longer here")
      end)

      JobChecker.check_job(job)
      JobChecker.check_job(job)

      assert %{total_entries: 1} = PendingChanges.all()
    end
  end

  describe "check_all/0" do
    setup do
      bypass = Bypass.open(port: 9002)
      passing_job = insert(:job, url: "http://localhost:9002/ok")
      failing_job = insert(:job, url: "http://localhost:9002/not_found")

      editor_user = insert(:user)
      Application.put_env(:companies, :jobs_url_checker, user_id: editor_user.id)

      {:ok, bypass: bypass, passing_job: passing_job, failing_job: failing_job, editor_user: editor_user}
    end

    test "removes only failed jobs", %{
      bypass: bypass,
      passing_job: passing_job,
      failing_job: failing_job,
      editor_user: editor_user
    } do
      Bypass.expect_once(bypass, "HEAD", "/ok", fn conn ->
        Plug.Conn.resp(conn, 200, "pong")
      end)

      Bypass.expect_once(bypass, "HEAD", "/not_found", fn conn ->
        Plug.Conn.resp(conn, 404, "failing_job")
      end)

      JobChecker.check_all()

      Jobs.get!(passing_job.id)
      Jobs.get!(failing_job.id)

      assert %{entries: [entry], total_entries: 1} = PendingChanges.all()

      assert(entry.action == "delete")
      assert(entry.resource == "job")
      assert(entry.changes["id"] == failing_job.id)
      assert(entry.user_id == editor_user.id)
    end
  end
end
