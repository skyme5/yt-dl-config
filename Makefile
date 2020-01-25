build:
	ruby generate.rb

install: build
	mkdir -p ~/.config/youtube-dl ~/.yt-dl
	cp config/* ~/.yt-dl/
	cp config/yt.default.conf ~/.config/youtube-dl/config
	cp yt.rb ~/.yt-dl/

clean:
	rm -rf config/
	rm flags.json

all: clean build
