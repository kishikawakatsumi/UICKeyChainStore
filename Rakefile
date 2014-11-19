DESTINATIONS = ["name=iPad 2,OS=7.1",
                "name=iPad 2,OS=8.1",
                "name=iPad Air,OS=7.1",
                "name=iPad Air,OS=8.1",
                "name=iPhone 4s,OS=7.1",
                "name=iPhone 4s,OS=8.1",
                "name=iPhone 5s,OS=7.1",
                "name=iPhone 5s,OS=8.1",
                "name=iPhone 6,OS=8.1",
                "name=iPhone 6 Plus,OS=8.1"]

desc 'Clean, Build and Test for iOS and OS X'
task :default => [:ios, :osx]

desc 'Cleans for iOS and OS X'
task :clean => ['ios:clean', 'osx:clean']

desc 'Builds for iOS and OS X'
task :build => ['ios:build', 'osx:build']

desc 'Test for iOS and OS X'
task :test => ['ios:test', 'osx:test']

desc 'Clean, Build, and Test for iOS'
task :ios => ['ios:clean', 'ios:build', 'ios:test']

namespace :ios do
  desc 'Clean for iOS'
  task :clean do
    sh %[xcodebuild clean -scheme iOS]
  end

  desc 'Build for iOS'
  task :build do
    sh %[xcodebuild -scheme iOS CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO]
  end

  desc 'Test for iOS'
  task :test do
    options = DESTINATIONS.map { |destination| %[-destination "#{destination}"] }.join(" ")
    sh %[xcodebuild test -scheme iOS -configuration Debug -sdk iphonesimulator #{options}]
  end
end

desc 'Clean, Build, and Test for OS X'
task :osx => ['osx:clean', 'osx:build', 'osx:test']

namespace :osx do
  desc 'Clean for OS X'
  task :clean do
    sh %[xcodebuild clean -scheme Mac]
  end

  desc 'Build for OS X'
  task :build do
    sh %[xcodebuild -scheme Mac]
  end

  desc 'Test for OS X'
  task :test do
    sh %[xcodebuild test -scheme Mac -configuration Debug -destination platform='OS X', arch=x86_64]
  end
end
