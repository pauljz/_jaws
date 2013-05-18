##
## S3 Bucket
##
JAWS_BUCKET=s3://example/

##
## Max age cache settings
##
JAWS_LONGCACHE=2678400
JAWS_SHORTCACHE=86400

##
## CDN Paths
##   If desired, these can be the same. You might want them to be different to have different CloudFront settings
##
JAWS_STATICCDN=http://static.example.com/    
JAWS_IMAGECDN=http://images.example.com/

##
## Command to use to generate versions/timestamps on static content. If you're not using git, try the date one
##
## To use the git HEAD revision:
JAWS_REVISION=`git rev-parse HEAD`
## To use the current unix timestamp:
# JAWS_REVISION=`date +%s`

##
## Path to your deployment scripts
##
JAWS_PATH=_scripts/

##
## Whether or not to use color in the output
##
## Use color:
JAWS_COLOR=1
## Don't use color:
# JAWS_COLOR=0

##
## gzip algorithm
##
## To use gzip's highest compression setting
JAWS_ZIPCMD=gzip -9 -n
## To use zopfli (https://code.google.com/p/zopfli/) - better but slower
# JAWS_ZIPCMD=zopfli

##
## Echo out filenames that are being manipulated - Could get spammy with a large blog
##
JAWS_VERBOSE=1
