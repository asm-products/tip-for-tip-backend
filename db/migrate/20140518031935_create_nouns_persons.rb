class CreateNounsPersons < ActiveRecord::Migration
  def change

    # The normal plural of person was persons, as in “two persons were present”.
    # However, there is evidence from Chaucer onwards that some writers chose to
    # use people as a plural for person, not only in the generalised sense of “an
    # uncountable or indistinct mass of individuals” but also in specific countable
    # cases (Chaucer wrote of “a thousand people”). This began to be questioned in
    # Victorian times, and the pseudo-rule grew up that the plural of person is
    # persons when a specific, countable number of individuals is meant, but that
    # people should be used when the number is large or indefinite.
    create_table :nouns_persons do |t|
      t.string :uuid, null: false, unique: true, limit: 36
      t.string :name, null: false
      t.timestamps
    end

    add_index :nouns_persons, :uuid, unique: true
    add_index :nouns_persons, :name
  end
end
