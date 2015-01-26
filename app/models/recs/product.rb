module Recs
  class Product
    include Neo4j::ActiveNode

    property :name
    property :slug

    has_many :in, :users, origin: 'purchases', model_class: Recs::User

    def in_spree
      Spree::Product.find_by!(slug: slug)
    end

    def users_also_bought(limit: 3)
      users.purchases(:product).users.purchases(:other_product).where("other_product.slug <> product.slug").
        limit(limit).
        pluck('DISTINCT other_product')
    end

    def self.from_spree_product(spree_product)
      where(slug: spree_product.slug).first ||
        create(name: spree_product.name, slug: spree_product.slug)
    end
  end
end
