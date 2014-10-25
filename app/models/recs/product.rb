module Recs
  class Product
    include Neo4j::ActiveNode

    property :name
    property :slug

    has_many :in, :users, origin: 'purchases', model_class: Recs::User

    def self.from_spree_product(spree_product)
      where(slug: spree_product.slug).first ||
        create(name: spree_product.name, slug: spree_product.slug)
    end
  end
end
