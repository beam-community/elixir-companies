defmodule Companies.JobCheckerTest do
  use Companies.DataCase

  alias Companies.Jobs

  describe "check_job/1" do
    setup do
      bypass = Bypass.open(port: 9002)
      job = insert(:job, url: "http://localhost:9002/")
      {:ok, bypass: bypass, job: job}
    end

    test "job URL responded with HTTP 200", %{bypass: bypass, job: job} do
      Bypass.expect_once(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 200, "pong")
      end)

      Companies.JobChecker.check_job(job)

      Jobs.get!(job.id)
    end

    test "job URL responded with HTTP 503", %{bypass: bypass, job: job} do
      Bypass.expect_once(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 503, "pong")
      end)

      Companies.JobChecker.check_job(job)

      Jobs.get!(job.id)
    end

    test "job URL isn't there", %{bypass: bypass, job: job} do
      Bypass.down(bypass)

      Companies.JobChecker.check_job(job)

      Jobs.get!(job.id)
    end

    test "job URL responded with HTTP 404", %{bypass: bypass, job: job} do
      Bypass.expect_once(bypass, "HEAD", "/", fn conn ->
        Plug.Conn.resp(conn, 404, "No longer here")
      end)

      Companies.JobChecker.check_job(job)

      assert_raise(Ecto.NoResultsError, fn -> Jobs.get!(job.id) end)
    end
  end

  describe "check_all/0" do
    setup do
      bypass = Bypass.open(port: 9002)
      passing_job = insert(:job, url: "http://localhost:9002/ok")
      failing_job = insert(:job, url: "http://localhost:9002/not_found")
      {:ok, bypass: bypass, passing_job: passing_job, failing_job: failing_job}
    end

    test "removes only failed jobs", %{bypass: bypass, passing_job: passing_job, failing_job: failing_job} do
      Bypass.expect_once(bypass, "HEAD", "/ok", fn conn ->
        Plug.Conn.resp(conn, 200, "pong")
      end)

      Bypass.expect_once(bypass, "HEAD", "/not_found", fn conn ->
        Plug.Conn.resp(conn, 404, "failing_job")
      end)

      Companies.JobChecker.check_all()

      Jobs.get!(passing_job.id)
      assert_raise(Ecto.NoResultsError, fn -> Jobs.get!(failing_job.id) end)
    end
  end
end
