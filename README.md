# Who is That

## Overview

I recently got a new job and wanted to hit the ground running. I'd
already called people the wrong name during the interview process and
I have a hard time remembering people's names and faces (especially if
they're not on a bike). Who is that is a quiz web app that shows you
faces and helps you learn who they are. You can often get a list of
people from linkedin or the company website.

## setup

 * If you're using genconfig.py you need:
     * looker.url and
     * image_base_dir.url
     * public/img/favicon.ico
     * public/img/logo.png
     * npm install -g firebase-tools

 * and you need fuzzyset.js
   ```
	 wget -O public/third_party/fuzzyset.js \
	   https://raw.githubusercontent.com/Glench/fuzzyset.js/master/lib/fuzzyset.js
	 ```

## TODO
  * show correct answer
  * big red X and Big green checkmark
  * first names only
  * departments...
  * type in name...
