defmodule Companies.Factory do
  use ExMachina.Ecto, repo: Companies.Repo

  alias Companies.Schema.{Company, Industry, Job, User}

  def company_factory do
    %Company{
      description: "A test company",
      industry: insert(:industry),
      name: sequence(:name, &"Test Company #{&1}"),
      url: "www.example.com"
    }
  end

  def job_factory do
    %Job{
      title: "Job",
      url: "www.example.com/joblisting",
      company: insert(:company)
    }
  end

  def industry_factory do
    %Industry{
      name: sequence(:name, &"Test Industry #{&1}"),
    }
  end

  def user_factory do
    %User{
      email: sequence(:email, &"user-#{&1}@example.com"),
      token: "abc1234"
    }
  end
end
