require 'xcjobs'

def destinations
  [ 'name=iPad 2,OS=7.1',
    'name=iPad 2,OS=8.1',
    'name=iPad Air,OS=7.1',
    'name=iPad Air,OS=8.1',
    'name=iPhone 4s,OS=7.1',
    'name=iPhone 4s,OS=8.1',
    'name=iPhone 5s,OS=7.1',
    'name=iPhone 5s,OS=8.1',
    'name=iPhone 6,OS=8.1',
    'name=iPhone 6 Plus,OS=8.1'
  ]
end

XCJobs::Build.new('ios:build') do |t|
  t.workspace = 'UICKeyChainStore'
  t.scheme = 'iOS'
  t.configuration = 'Release'
  t.build_dir = 'build'
  t.formatter = 'xcpretty -c'
  t.add_build_setting('CODE_SIGN_IDENTITY', '')
  t.add_build_setting('CODE_SIGNING_REQUIRED', 'NO')
end

XCJobs::Build.new('osx:build') do |t|
  t.workspace = 'UICKeyChainStore'
  t.scheme = 'Mac'
  t.configuration = 'Release'
  t.sdk = 'macosx'
  t.build_dir = 'build'
  t.formatter = 'xcpretty -c'
end

XCJobs::Test.new('ios:test') do |t|
  t.workspace = 'UICKeyChainStore'
  t.scheme = 'iOS'
  t.configuration = 'Release'
  destinations.each do |destination|
    t.add_destination(destination)
  end
  t.build_dir = 'build'
  t.formatter = 'xcpretty -c'
  t.add_build_setting('GCC_INSTRUMENT_PROGRAM_FLOW_ARCS', 'YES')
  t.add_build_setting('GCC_GENERATE_TEST_COVERAGE_FILES', 'YES')
end

XCJobs::Test.new('osx:test') do |t|
  t.workspace = 'UICKeyChainStore'
  t.scheme = 'Mac'
  t.configuration = 'Release'
  t.sdk = 'macosx'
  t.build_dir = 'build'
  t.formatter = 'xcpretty -c'
  t.add_build_setting('GCC_INSTRUMENT_PROGRAM_FLOW_ARCS', 'YES')
  t.add_build_setting('GCC_GENERATE_TEST_COVERAGE_FILES', 'YES')
end
