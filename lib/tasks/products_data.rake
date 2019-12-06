namespace :products do
  desc "Create Dummy Data Products"
  task data: :environment do 
    data = [
      ["A", 30], ["B", 20], ["C", 50], ["D", 15]
    ]
    data.each { |arr| Product.create(name: arr[0], price: arr[1], active: true) }
  end
end