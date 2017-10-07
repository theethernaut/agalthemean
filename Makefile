CURRENT_DIR = $(shell pwd)
LIBS = $(shell ls libs)
LIB_PATH = $(foreach d, $(LIBS), -library-path+=./libs/$d)
SRC_PATH = -source-path+=./src/
MAIN = src/io/nfg/wmg/Main.as
OPT = -swf-version=37
DEBUG = true

CONSTS = -keep-as3-metadata+=Inject -keep-as3-metadata+=InjectComplete


build:
	ascshd mxmlc -debug=$(DEBUG) $(LIB_PATH) $(SRC_PATH) -output=build/AGALTheMean.swf $(OPT) $(CONSTS) src/Main.as
	@afplay /System/Library/Sounds/Submarine.aiff &
.PHONY: build

run:
	adl -screensize 800x1280:800x1280 app.xml
	#adl -screensize 1080x1920:1080x1920 app.xml
	#adl app-desktop.xml
