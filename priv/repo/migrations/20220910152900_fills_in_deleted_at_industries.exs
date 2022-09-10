defmodule Companies.Repo.Migrations.FillsInDeletedAtIndustries do
  use Ecto.Migration

  def up do
    execute """
    UPDATE industries SET deleted_at=NOW() WHERE removed_pending_change_id IS NOT NULL;
    """
  end

  def down do
    execute """
    UPDATE industries SET deleted_at=NULL;
    """
  end
end
