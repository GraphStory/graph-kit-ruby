neo4j_url = ENV.fetch('NEO4J_URI', 'http://localhost:7474')

uri        = URI.parse(neo4j_url)

server_uri = "#{uri.scheme}://#{uri.host}:#{uri.port}"

Neo4j::Session.open(:server_db, server_uri, basic_auth: { username: uri.user, password: uri.password})
