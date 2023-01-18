class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :artworks do |t|
      t.string :name
      t.string :author
      t.string :category
      t.integer :year
      t.string :tags, array: true, default: []

      t.timestamps
    end

    create_table :prints do |t|
      t.integer :serial_number
      t.string :format
      t.references :artwork, null: false, foreign_key: true

      t.timestamps
    end

    create_table :listings do |t|
      t.integer :price
      t.datetime :sold_at
      t.references :print, null: false, foreign_key: true

      t.timestamps
    end
  end
end
