class LinkingJob < ApplicationJob
  queue_as :default

  def perform
    Services::Linking.call
  end
end
