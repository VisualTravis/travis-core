module Travis
  module Github
    module Services
      autoload :FetchConfig,       'travis/github/services/fetch_config'
      autoload :FindOrCreateOrg,   'travis/github/services/find_or_create_org'
      autoload :FindOrCreateOwner, 'travis/github/services/find_or_create_owner_' # TODO wtf!
      autoload :FindOrCreateRepo,  'travis/github/services/find_or_create_repo'
      autoload :FindOrCreateUser,  'travis/github/services/find_or_create_user'
      autoload :SetHook,           'travis/github/services/set_hook'
      autoload :SyncUser,          'travis/github/services/sync_user'

      class << self
        def register
          constants(false).each { |name| const_get(name) }
        end
      end
    end
  end
end
