require 'spree/testing_support/factories'

############################################################
# Setup
############################################################

puts "** Dumping existing user and product graph nodes"
Recs::User.destroy_all
Recs::Product.destroy_all

############################################################
# Nasty global variableses
############################################################


$colors   = %w[red green brown blue pink orange yellow]
$families = %w[collar leash pillow shirt frisbee house bed]
$products = []
$users    = []


############################################################
# Simply seed helpers
############################################################

# Trying to speed this up by delaying writes to both DBs til the end
def with_transactions(&block)
  Neo4j::Transaction.run do
    ActiveRecord::Base.transaction do
      yield
    end
  end
end

# fake up some products with color and product family combinations
def create_fake_products!
  puts '** Creating fake products'
  $colors.product($families).each do |color, family|
    name = [color, family].join(' ').titleize
    $products << FactoryGirl.create(:product, name: name)
  end
end

# fake up some user with color and product family combinations as name + product preference
def create_fake_users!
  puts '** Creating fake users'
  [$colors, $families].flatten.each do |attr|
    salutation = %w[mr ms].sample
    $users << FactoryGirl.create(:user, email: "#{salutation}-#{attr.pluralize}@customer-email.net")
  end
end

# infer user product preference by looking at the user's email
def preferred_products_for(user)
  color  = $colors.select   { |c| user.email.include?(c) }.first
  family = $families.select { |f| user.email.include?(f) }.first
  hit    = color || family

  $products.select { |p| p.name.downcase.include?(hit) }
end

# fake up some order history for users that match their avowed preferences
def create_fake_order_history_for(user)
  puts "** Creating fake order history for #{user.email}"
  order = FactoryGirl.create(:order, user: user)

  preferred_products_for(user).shuffle.first(5).each do |product|
    puts "  [#{user.email}] can't resist buying\t[#{product.name}].  Of course."
    order.line_items.create(variant: product.master, quantity: rand(1..3))
  end

  order.update_totals until !order.total.zero?
  order.save! if order.changed?

  puts ""
end


############################################################
# Actually seed the DB
############################################################

with_transactions do
  create_fake_products!
  create_fake_users!
end

$users.shuffle.each do |user|
  with_transactions do
    create_fake_order_history_for user
  end
end

puts "** Done loading fake order seeds"
