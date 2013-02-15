# Hardy

Hardy is a [Thor][thor] library which easily converts an [HTTP Archive
(HAR)][har] file into a [siege][siege] URLs file.

What does that mean for you? Well, it means that it's now a trivial task to
generate load testing scripts for your HTTP(S) web applications.

## Installation

Add this line to your application's Gemfile:

    gem 'hardy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hardy

### Generating HAR files

Creating a HAR file is simple:

1. Open Chrome,
2. Open the Chrome Developer Tools panel (cmd-shift-i on a Mac),
3. With the tools panel open, navigate to the site you want to test,
4. Click the Preserve Log upon Navigation button on the Network tab of the
   tools panel (otherwise, your Network tab will be cleared with each page
   view),
5. Click around the site! Act like the user you want to simulate. Meaning,
   click links, post forms, change pages, sign in, sign out. Whatever you do
   here will be recreated by your load test users, so try to do things that
   will generate interesting test metrics.
6. Right-click in the Network panel and click "Save as HAR with Content"

You now have a HAR file to source for load testing! :beer:

### Installing siege

Note: If you are planning on testing a site which uses a JSON interface, you'll
want to read the Enabling JSON support in siege section further down this
README.

On a Mac, you can install siege with homebrew:

    $ brew install siege

On Ubuntu:

    $ apt-get install siege

Installing from source:

    $ curl http://www.joedog.org/pub/siege/siege-latest.tar.gz -o siege-latest.tar.gz
    $ tar xvfz siege-latest.tar.gz
    $ cd siege-*
    $ ./configure
    $ make
    $ make install

It is important to note that if you want to load test an HTTPS (SSL) site,
you'll need to install siege with SSL support. The Mac homebrew installation
and Ubuntu package already enable this, by default.

    $ ./configure --with-ssl

## Usage

Once you've created or otherwise acquired your HAR file, use Hardy to convert
it to a [siege URLs file][urls-file]:

    $ hardy convert my-har-file.env

By default, this will create a `urls.siege` file and a `data` directory full of
data files to support it.

### Enabling JSON support in siege

So, you're load testing a web application which uses JSON, huh? Does it look
like your application is not recognizing the parameters as JSON? Yeah... as of
siege 2.74 (currently the latest version), siege does not recognize `.json`
files, nor does it support automatically setting the `Content-Type:
application/json` request header. Bummer.

But you need JSON support, you say? Yeah, me too. Sadly, that means you get to
edit some C source code. So, download the latest source (as instructed in the
Installing siege section, above) and before you `./configure`, you'll need to
edit `src/load.c`:

```diff
static const struct ContentType tmap[] = {
  {"default", TRUE,  "application/x-www-form-urlencoded"},
  {"ai",      FALSE, "application/postscript"},
  ...
+ {"json",    FALSE, "application/json"},
  ...
  {"xyz",     FALSE, "chemical/x-pdb"},
  {"zip",     FALSE, "application/zip"}
};
```

Just add an entry to allow `.json` files to be recognized and transmitted as
"application/json" format. Once that's done, re-configure, build, and install
siege, as detailed above. Now, when the URLs file defines a `.json` file, siege
will automatically recognize it and make the request with the proper
`Content-Type` request header.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[har]: http://www.softwareishard.com/blog/har-12-spec/
[siege]: http://www.joedog.org/siege-home/
[thor]: https://github.com/wycats/thor
[urls-file]: http://www.joedog.org/siege-manual/#a05