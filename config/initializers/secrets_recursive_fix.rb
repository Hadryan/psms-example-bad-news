secrets = Rails.application.secrets.to_hash
Rails.application.secrets = Hashie::Mash.new(secrets)
