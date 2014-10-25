Spree::Product.class_eval do
  def users_also_bought
    users = line_items.flat_map(&:order).uniq.flat_map(&:user).uniq
    users.flat_map(&:orders).uniq.flat_map(&:products).uniq - [self]
  end

  def graphed
    Recs::Product.from_spree_product self
  end
end
