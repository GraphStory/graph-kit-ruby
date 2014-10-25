Spree::LineItem.class_eval do
  after_create :log_to_graph

  delegate :user, to: :order, prefix: false

  def log_to_graph
    user.graphed.purchases << product.graphed
  end
end
