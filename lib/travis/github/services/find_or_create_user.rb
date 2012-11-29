module Travis
  module Github
    module Services
      class FindOrCreateUser < Travis::Services::Base
        register :github_find_or_create_user

        def run
          find || create
        end

        private

          def find
            ::User.where(:login => params[:login]).first # TODO should really use the github id
          end

          def create
            User.create!(
              :name => data['name'],
              :login => data['login'],
              :email => data['email'],
              :github_id => data['id'],
              :gravatar_id => data['gravatar_id']
            )
          end

          def data
            @data ||= GH["users/#{params[:login]}"] || raise(Travis::GithubApiError)
          end
      end
    end
  end
end
