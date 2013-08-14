PROJECT = UICKeyChainStore.xcodeproj
TEST_TARGET = Tests

test:
	xctool \
		clean test \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES
		
test-with-coverage:
	xctool \
		clean test \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
		
send-coverage:
	find ./ -name "*Test.gcno" | xargs rm
	coveralls \
		-e UICKeyChainStore \
		-e UICKeyChainStoreTests \
		--verbose