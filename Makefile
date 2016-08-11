config:
	python ./genconfig.py > config.new
	if [[ $$(stat -f%z config.new) -gt 7000 ]]; then \
	  mv -f -v public/config.js bak/config.js.$$(date +%F); \
	  mv -f -v config.new public/config.js; \
	  echo firebase deploy; \
	else \
	  echo "Something wrong with config.js"; \
	fi
