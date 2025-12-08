class AddEmbeddingToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :embedding, :vector, limit: 1536
  end
end
