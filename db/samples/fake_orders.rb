require 'ffaker' # included with Spree

require 'spree/testing_support/factories'

# create short list of products
puts "** Loading fake product seeds"
FactoryGirl.create_list(:product, 20) unless Spree::Product.count >= 20

# create longer list of users
puts "** Loading fake user seeds"
FactoryGirl.create_list(:user, 100)   unless Spree::User.count >= 100

# create some orders for those users
puts "** Loading fake order seeds"
Spree::User.all.each_with_index do |u, i|
  puts "** Loading fake order seeds for user #{i}"
  FactoryGirl.create_list(:order, rand(1..10), user: u) unless u.admin?
end unless Spree::Order.count >= 10
puts "** Done loading fake order seeds"

# create some line items for those orders for an assortment of the products
def add_product_to_order(product, order)
  return if order.products.include? product
  order.line_items.create(variant: product.master, quantity: rand(1..3))
  order.update_totals until !order.total.zero?
  order.save! if order.changed?
  order
end

# Ensure at least 250 line items are created so we can see some data clusters
puts "** Loading fake line item seeds"
ActiveRecord::Base.transaction {
  until Spree::LineItem.count >= 250
    puts "LI count: #{Spree::LineItem.count}"
    add_product_to_order Spree::Product.sample, Spree::Order.sample
  end
}
puts "** Done loading fake line item seeds"
