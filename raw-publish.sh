#
# Load config file
#

if [ -f $FILE ]; then
	. config.sh
fi
cd $WORKING_DIR

#
# Define a function for logging
#

function say {
	if [[ $JAWS_COLOR -eq 1 ]]; then
		echo ""
		echo -e "\033[4;32m$1\033[0m"
	else
		echo ""
		echo $1
		echo "----------------------------------"
	fi
}

#
# immediately regenerate the site
#

say "Generating Site"

$JAWS_GENERATE

#
# Use absolute CDN paths for images, css, js
#

say "Replacing CDN Paths"

VERBOSE=
if [[ $JAWS_VERBOSE -eq 1 ]]; then
	VERBOSE="-exec echo {} ;"
fi

# Escape path for sed
STATICCDN=${JAWS_STATICCDN//\//\\\/}
IMAGECDN=${JAWS_STATICCDN//\//\\\/}

find -E _site \
	-type f \
	-regex '.*\.(html|js|css)' \
	$VERBOSE \
	-exec sed -Ei '' "s/\"\/([^\/][^\"]+\.(css|js))\"/\"$STATICCDN\1?r=$JAWS_REVISION\"/g" {} \; \
	-exec sed -Ei '' "s/\"\/([^\/][^\"]+\.(png|jpg|jpeg|gif))\"/\"$IMAGECDN\1?r=$JAWS_REVISION\"/g" {} \; \
	-exec sed -Ei '' "s/'\/([^\/][^']+\.(css|js))'/'$STATICCDN\1?r=$JAWS_REVISION'/g" {} \; \
	-exec sed -Ei '' "s/'\/([^\/][^']+\.(png|jpg|jpeg|gif))'/'$IMAGECDN\1?r=$JAWS_REVISION'/g" {} \;

# TODO - this should really be replaced by a proper parser to be safe

# Dissection of horrible regex:
# "/([^/]         - Quoted, absolute paths. Make sure to exclude no-protocol links e.g., //ajax.googleapis.com/
#   [^"]*+        - Any non-quote character. It's ok that this is greedy unless you do something like not closing your quotes
#   \.(css|js)    - Different file extensions for which to replace
# )"              - End

#
# Minify JS, CSS, and HTML files
#

say "Minifying JS"

find _site -name '*.js' \
	$VERBOSE \
	-exec java -jar $SCRIPTS_DIR/yuicompressor.jar -o {} {} \;

say "Minifying CSS"

find _site -name '*.css' \
	$VERBOSE \
	-exec java -jar $SCRIPTS_DIR/yuicompressor.jar -o {} {} \;

say "Minifying HTML"

find _site -name '*.html' \
	$VERBOSE \
	-exec java -jar $SCRIPTS_DIR/htmlcompressor.jar \
		--compress-js \
		--compress-css \
		--remove-intertag-spaces \
		--type html \
		-o {} {} \;

#
# gzip text-based files
#

say "Compressing text files"

# TODO additional prefixes like .txt? document files? configurable, ideally
find _site -name '*.html' $VERBOSE -exec $JAWS_ZIPCMD {} \; -exec mv {}.gz {} \;
find _site -name '*.xml'  $VERBOSE -exec $JAWS_ZIPCMD {} \; -exec mv {}.gz {} \;
find _site -name '*.js'   $VERBOSE -exec $JAWS_ZIPCMD {} \; -exec mv {}.gz {} \;
find _site -name '*.css'  $VERBOSE -exec $JAWS_ZIPCMD {} \; -exec mv {}.gz {} \;

#
# sync gzipped html/xml:
#

say "Syncing HTML/XML"

s3cmd sync \
	--progress \
	--guess-mime-type \
	--acl-public \
	$DELETE \
	$INVALIDATE \
	--add-header 'Content-Encoding:gzip' \
	--exclude '*.*' \
	--include '*.html' \
	--include '*.xml' \
		_site/ $JAWS_BUCKET

#
# sync gzipped files which get a timestamp, so we can cache for a very long time
#

say "Syncing CSS/JS"

s3cmd sync \
	--progress \
	--guess-mime-type \
	--acl-public \
	$INVALIDATE \
	--add-header 'Content-Encoding:gzip' \
	--add-header "Cache-Control: max-age=$JAWS_LONGCACHE" \
	--exclude '*.*' \
	--include '*.js' \
	--include '*.css' \
		_site/ $JAWS_BUCKET

#
# sync remaining files, e.g., images, documents
#

say "Syncing Remaining Files"

s3cmd sync \
	--progress \
	--guess-mime-type \
	--acl-public \
	$INVALIDATE \
	--add-header "Cache-Control: max-age=$JAWS_SHORTCACHE" \
	--exclude '*.html' \
	--exclude '*.xml' \
	--exclude '*.js' \
	--exclude '*.css' \
		_site/ $JAWS_BUCKET

say "Done."
