namespace :dev do
    desc "TODO"
    task setup: :environment do
    puts "Adding examples"
    1000.times do |i|
        Score.create!(
        "username": Faker::Name.name,
        "score": rand(100..10000)
        )
    end

    puts "Finish."
    end
end
