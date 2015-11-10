config:
	python ./genconfig.py > config.new
	if [[ $$(stat -f%z config.new) -gt 7000 ]]; then \
	  mv -f -v config.js bak/config.js.$$(date +%F); \
	  mv -f -v config.new config.js; \
	  if [ -d "$$HOME/Google Drive/Public/lookeraterer/" ]; then \
	    echo "Publishing to Google Drive"; \
	    rsync -avub --exclude .git --exclude bak ./ ~/Google\ Drive/Public/lookeraterer/; \
	  fi; \
	else \
	  echo "Something wrong with config.js"; \
	fi
