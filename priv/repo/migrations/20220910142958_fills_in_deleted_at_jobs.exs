defmodule Companies.Repo.Migrations.FillsInDeletedAtJobs do
  use Ecto.Migration

  def up do
    execute """
    UPDATE jobs SET deleted_at=NOW() WHERE removed_pending_change_id IS NOT NULL;
    """
  end

  def down do
    execute """
    UPDATE jobs SET deleted_at=NULL;
    """
  end
end
