*Disclaimer:* this project is totally unrelated to [servant-app/JAWS](https://github.com/servant-app/JAWS) (which is a cool project that you should definitely check out if you're interested in static sites and AWS). This project is also unmaintained and unused by me now.

# <img src="http://www.paulzumbrun.com/img/jaws-small.png" alt="_jaws logo" /> _jaws

Awesome **J**ekyll deployment scripts for **AWS** (S3 and CloudFront). Works with any other static site too.

_jaws:

* minifies HTML, JavaScript and CSS
* gzips assets and includes appropriate headers
* allows images, CSS, and JS to be served from a different domain name
* syncs your site to an S3 bucket
* invalidates changed files in CloudFront

all with a single command.

## Dependencies

_jaws probably **only works on Mac OS X** at the moment (and maybe BSD variants) due to some of the shell commands used. This is a high priorty issue to fix.

The only hard dependencies are [s3cmd](http://s3tools.org/s3cmd) and Java (and some other things that you're almost guaranteed to have like gzip and bash).

You can install [`zopfli`](https://code.google.com/p/zopfli/) for better compression. _jaws uses `gzip` by default.

_jaws is configured to use [Pygments](http://pygments.org/) by default for syntax highlighting, but you can easily configure it not to use this.

## Installation

From your Jekyll project's root directory:

    git clone git@github.com:pauljz/_jaws.git
    cp _jaws/config.sample.sh _jaws/config.sh

Then edit your `config.sh`. By default the only things you need to change are `JAWS_BUCKET`, `JAWS_STATICCDN`, and `JAWS_IMAGECDN`.

Additional configuration options are documented in `config.sh`. 

You'll also need to set up S3 and CloudFront correctly. I will have a walkthrough for [setting up S3 and CloudFront for Jekyll](http://www.paulzumbrun.com/Setting-up-S3-and-CloudFront-for-static/) correctly on my blog shortly.

If this is your first time using s3cmd, you'll need to run `s3cmd --configure` to get started.

## Usage

There are 3 scripts to use directly:

<table>
  <tr>
    <td>
      <code>_jaws/publish.sh</code>
    </td>
    <td>Normal use.</td>
  </tr>
  <tr>
    <td>
      <code>_jaws/publish-invalidate.sh</code>
    </td>
    <td>Same as <code>publish.sh</code>, except it also invalidates your cache in CloudFront. Worth using if you've made substantial changes and/or need things to go live quickly.</td>
  </tr>
  <tr>
    <td>
      <code>_jaws/publish-delete.sh</code>
    </td>
    <td>Same as <code>publish-invalidate.sh</code>, except it also deletes files not in your local copy of the site. Use if you have removed blog posts, compromising photos, etc. </td>
  </tr>
</table>

### Usage with other static sites

There's nothing that requires _jaws to be used with Jekyll.
*Any* static site can be published to AWS using these scripts with some basic configuration.

Change the `JAWS_GENERATE` configuration option to whatever generates your static site. If it's literally just flat files, your configuration should look something like:

    JAWS_GENERATE="rm -rf _site && cp -R yourSite _site"
    
## Legal

Copyright &copy; 2013 Paul Zumbrun, http://www.paulzumbrun.com/

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
