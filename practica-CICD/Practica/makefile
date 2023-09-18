all: git_repo install_dependencies unit_test build run funcional_test

git_repo:
	if [ -d gogs ]; then
		cd gogs
		git pull https://github.com/gogs/gogs.git v0.13.0 --force 
	else
		git clone -b v0.13.0 https://github.com/gogs/gogs.git gogs
		cd gogs
	fi

install_dependencies:
	go get -t ./...
	go get github.com/mattn/go-sqlite3@latest

unit_test:
	cd gogs
	xGO_TEST_RESULTS_FILE=/tmp/go_test_result
	pwd
	go get -x -t ./...
	go test -cover ./... | tee $xGO_TEST_RESULTS_FILE 
	xGO_TEST_EXIT_CODE=$?
	xGO_TEST_FAILED="$(grep '^FAIL' $xGO_TEST_RESULTS_FILE | wc -l)"
	xGO_TEST_OK="$(grep '^ok' $xGO_TEST_RESULTS_FILE | wc -l)"
	xGO_TEST_NO="$(grep '^?' $xGO_TEST_RESULTS_FILE | wc -l)"

build:
	cd gogs
	go build -o gogs

run:
	./gogs --version
	./gogs web

funcional_test:
	cd gogs
	./gogs web &
	sleep 10
	curl -I http://localhost:3000/
	xCURL_TEST=$?
	if [ $xCURL_TEST -eq 0 ]
		echo "TEST SUCCESSFUL"
	else
		echo "TEST FAIL"
	fi	  
