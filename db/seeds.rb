
puts "Seeding Core Accounting Accounts"
# Core accounting records.
Accounts.seed

puts "Seeding Thing Nouns"
Nouns::Thing.create name: "Tip for Tip"


