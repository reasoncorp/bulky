load "tasks/resque.rake"

namespace :bulky do
  task :setup do
    ENV['QUEUE'] = Bulky::Updater::QUEUE.to_s
    ENV['BACKGROUND'] = true.to_s
  end

  desc "start a bulky queue worker (in the background)"
  task :work => [:environment, :setup, :"resque:work"]
end
