
IOS_SDK_VERSION?=2.4.1
ANDROID_SDK_VERSION?=5.0.0
UNITY_VERSION?=2.0.0
export ANDROID_HOME?=$(shell echo ${HOME})/Library/Android/sdk
unitypackage:
	./build.sh --apple-sdk-version=${IOS_SDK_VERSION} --android-sdk-version=${ANDROID_SDK_VERSION} --version=${UNITY_VERSION}

release:
	git add Makefile
	git checkout .
	git clean -f -d
	find Leanplum-Unity-Plugin/ -type f -delete
	./build.sh --apple-sdk-version=${IOS_SDK_VERSION} --android-sdk-version=${ANDROID_SDK_VERSION} --version=${UNITY_VERSION}
	git add Leanplum-Unity-Plugin/
	@while [ -z "$$CONTINUE" ]; do \
		read -r -p "Push new release to master? [y/N]: " CONTINUE; \
	done ; \
	[ $$CONTINUE = "y" ] || [ $$CONTINUE = "Y" ] || (echo "Exiting."; exit 1;)
	@echo "Pushing ${UNITY_VERSION} to master."
	git commit -m "Updating to ${UNITY_VERSION}"
	git push
	git tag ${UNITY_VERSION}
	git push --tags