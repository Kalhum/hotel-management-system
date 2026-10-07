.PHONY: clean test pod-install

#======== Clean cache and get dependencies
clean:
	flutter clean
	flutter pub get

#======== Run tests with coverage and generate HTML report
test:
	flutter test --coverage 
	genhtml coverage/lcov.info -o coverage/html 
	open coverage/html/index.html

#======== Clean pods and reinstall dependencies for iOS
pod-install:
	flutter clean
	flutter pub get
	@if [ -d ios ]; then \
		cd ios && pod deintegrate && pod install; \
	else \
		echo "Skip pod install: ios directory not found in this package."; \
	fi