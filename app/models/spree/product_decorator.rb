Spree::Product.class_eval do
  def users_also_bought
    graphed.users_also_bought(limit: 3).map(&:in_spree)
  end

  def graphed
    Recs::Product.from_spree_product self
  end
end
