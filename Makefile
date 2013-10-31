test:
	xctool \
		clean build test \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
		
build-ios:
	xctool \
		clean build \
		-scheme 'UICKeyChainStore' \
		-sdk iphonesimulator \
		-arch i386 \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
		
build-osx:
	xctool \
		clean build \
		-scheme 'libUICKeyChainStore' \
		-sdk macosx \
		-arch x86_64 \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
