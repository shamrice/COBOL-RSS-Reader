
# Last updated: 2022-04-19

CBL=cobc
CBLFLAGS=-Wall -O2 -fstatic-call # --debug

CBL_MAIN=./crssr.cbl
CBL_SOURCES=$(shell find . -type f -name '*.cbl' -o -name '*.cob' | grep -v '${CBL_MAIN}')

APP_VERSION=\"v0.50\"
SOURCE_URL=\"https\\:\\/\\/github.com\\/shamrice\\/COBOL-RSS-Reader\"
CUR_BUILD_DATE=\"$(shell date +%Y-%m-%d)\"

all: build

build: prepare crssr postbuild 

clean:
	rm -rfv ../bin


prepare: 
	mkdir -p -v ../bin/	
	mkdir -p -v ../bin/feeds
	sed -i "s/__APP_VERSION/${APP_VERSION}/" crssr.cbl
	sed -i "s/__SOURCE_URL/${SOURCE_URL}/" crssr.cbl
	sed -i "s/__BUILD_DATE/${CUR_BUILD_DATE}/" crssr.cbl
	sed -i "s/__APP_VERSION/${APP_VERSION}/" rss_reader_help.cbl
	sed -i "s/__SOURCE_URL/${SOURCE_URL}/" rss_reader_help.cbl
	sed -i "s/__BUILD_DATE/${CUR_BUILD_DATE}/" rss_reader_help.cbl


crssr: ${CBL_MAIN} ${CBL_SOURCES} 	
	${CBL} ${CBLFLAGS} -x -o ../bin/$@ $^


postbuild:
	sed -i "s/${APP_VERSION}/__APP_VERSION/" crssr.cbl
	sed -i "s/${SOURCE_URL}/__SOURCE_URL/" crssr.cbl
	sed -i "s/${CUR_BUILD_DATE}/__BUILD_DATE/" crssr.cbl
	sed -i "s/${APP_VERSION}/__APP_VERSION/" rss_reader_help.cbl
	sed -i "s/${SOURCE_URL}/__SOURCE_URL/" rss_reader_help.cbl
	sed -i "s/${CUR_BUILD_DATE}/__BUILD_DATE/" rss_reader_help.cbl	


