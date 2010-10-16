namespace :assets do
    desc 'Updates stylesheets if necessary from their Sass templates.'

    task :sass => :environment do
        Sass::Plugin.update_stylesheets
    end

    task :js => :environment do
      Jammit.packager.precache_all
    end
end
