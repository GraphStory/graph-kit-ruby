if Rails.env.production?
  neo4j_url = ENV.fetch('NEO4J_URI', 'http://localhost:7474')
else
  neo4j_url = 'http://localhost:7474'
end

uri        = URI.parse(neo4j_url)

server_uri = "#{uri.scheme}://#{uri.host}:#{uri.port}"

begin
  Neo4j::Session.open(:server_db, server_uri, basic_auth: { username: uri.user, password: uri.password})
rescue Net::HTTP::Persistent::Error => err
  Rails.logger.error "Neo4j connecton problem: #{err.message}"
end
