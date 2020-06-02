class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
      t.string :picture
      t.string :name
      t.string :category
      t.string :ability

      t.timestamps
    end
  end
end
