DESTINATIONS = ["name=iPhone Retina (3.5-inch),OS=7.0",
                "name=iPhone Retina (3.5-inch),OS=7.1",
                "name=iPhone Retina (4-inch),OS=7.0",
                "name=iPhone Retina (4-inch),OS=7.1",
                "name=iPhone Retina (4-inch 64-bit),OS=7.0",
                "name=iPhone Retina (4-inch 64-bit),OS=7.1"]

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
    sh "xcodebuild clean -scheme iOS | xcpretty -c; exit ${PIPESTATUS[0]}"
  end
  
  desc 'Build for iOS'
  task :build do
    sh "xcodebuild -scheme iOS CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO | xcpretty -c; exit ${PIPESTATUS[0]}"
  end
  
  desc 'Test for iOS'
  task :test do
    DESTINATIONS.each do |destination|
      sh "xcodebuild test -scheme iOS -configuration Debug -sdk iphonesimulator -destination \"#{destination}\" | xcpretty -tc; exit ${PIPESTATUS[0]}"
    end
  end
end

desc 'Clean, Build, and Test for OS X'
task :osx => ['osx:clean', 'osx:build', 'osx:test']

namespace :osx do
  desc 'Clean for OS X'
  task :clean do
    sh "xcodebuild clean -scheme Mac | xcpretty -c; exit ${PIPESTATUS[0]}"
  end

  desc 'Build for OS X'
  task :build do
    sh "xcodebuild -scheme Mac | xcpretty -c; exit ${PIPESTATUS[0]}"
  end
  
  desc 'Test for OS X'
  task :test do
    sh "xcodebuild test -scheme Mac -configuration Debug -destination platform='OS X', arch=x86_64 | xcpretty -tc; exit ${PIPESTATUS[0]}"
  end
end
