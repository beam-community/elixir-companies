defmodule CompaniesWeb.JobController do
  use CompaniesWeb, :controller

  alias Companies.{Companies, Jobs, Schema.Job}
  plug :load_companies when action in [:new, :edit, :create, :update]

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, "index.html", jobs: jobs)
  end

  def new(conn, %{"company_id" => company_id}) do
    changeset = Jobs.change_job(%Job{})
    company = Companies.get_company!(company_id)
    render(conn, "new.html", changeset: changeset, company: company)
  end

  def create(conn, %{"job" => job_params}) do
    case Jobs.create_job(job_params) do
      {:ok, _job} ->
        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: Routes.company_path(conn, :recent))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    render(conn, "show.html", job: job)
  end

  def edit(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    changeset = Jobs.change_job(job)
    render(conn, "edit.html", job: job, changeset: changeset)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Jobs.get_job!(id)

    case Jobs.update_job(job, job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job updated successfully.")
        |> redirect(to: Routes.job_path(conn, :show, job))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", job: job, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    {:ok, _job} = Jobs.delete_job(job)

    conn
    |> put_flash(:info, "Job deleted successfully.")
    |> redirect(to: Routes.job_path(conn, :index))
  end

  defp load_companies(conn, _) do
    assign(conn, :companies, Companies.list_companies())
  end
end
