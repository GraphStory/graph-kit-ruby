Spree::LineItem.class_eval do
  after_create :log_to_graph

  delegate :user, to: :order, prefix: false

  def log_to_graph
    return unless user.try(:graphed)
    user.graphed.purchases << product.graphed
  end
end
