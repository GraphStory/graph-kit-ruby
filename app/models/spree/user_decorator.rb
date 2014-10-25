Spree::User.class_eval do
  def graphed
    Recs::User.from_spree_user self
  end
end
