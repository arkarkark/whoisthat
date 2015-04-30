config:
	./genconfig.py > config.new
	if [[ $$(stat -f%z config.new) -gt 7000 ]]; then \
	  mv -f -v config.js bak/config.js.$(date +%F); mv -f -v config.new config.js; \
	  rsync -avub --exclude .git --exclude bak ./ ~/Google\ Drive/Public/lookeraterer/ \
	; else echo "Something wrong with config.js"; fi
