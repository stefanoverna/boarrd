namespace :cache do
  desc "Clear the cache"
  task :reset => :environment do
    Rails.cache.clear
  end
end
