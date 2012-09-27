class Build

  # The build's start and finish events (state changes) trigger denormalization
  # of certain attributes to the repository in order to disburden the db a bit.
  #
  # E.g. on `start` the `started_at` attribute of a build gets set to its
  # repository's `last_started_at` attribute. Likewise on `finish` the
  # `finished_at` and `result` attributes are set to `last_finished_at` and
  # `last_result` on the repository.
  #
  # These attributes are used in the repositories list and thus read frequently.
  module Denormalize
    def denormalize(event, *args)
      repository.update_attributes!(denormalize_attributes_for(event)) if denormalize?(event)
    end

    DENORMALIZE = {
      :start  => %w(id language number result duration started_at finished_at),
      :finish => %w(duration result finished_at)
    }

    def denormalize?(event)
      DENORMALIZE.key?(event) && !pull_request?
    end

    def denormalize_attributes_for(event)
      DENORMALIZE[event].inject({}) do |result, key|
        result.merge(:"last_build_#{key}" => send(key))
      end
    end
  end
end
