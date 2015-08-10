# The Ruby Blocky Image Viewer

**tl;dr: terminal image displayer that’s a shameless re-write of [icat](https://github.com/atextor/icat) for Ruby**

![tldr](https://raw.github.com/bogwonch/ruby-blocky-image-viewerl/images/tldr.png)

## Summary

So you want to see an image, but don’t wanna leave your precious command-line?

`jp2a` makes you sad...

![jp2a](https://raw.github.com/bogwonch/ruby-blocky-image-viewerl/images/jp2a.png)

`img2txt` is just weird...

![img2txt](https://raw.github.com/bogwonch/ruby-blocky-image-viewerl/images/img2txt.png)

There is a better way!

![biv](https://raw.github.com/bogwonch/ruby-blocky-image-viewerl/images/biv.png)

## Features

* True color support!
* Higher definition output (2 pixels per character!)
* Width and height controls!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-blocky-image-viewer'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install ruby-blocky-image-viewer
```

## Usage

If you just wanna view an image checkout:

```sh
$ biv --help
```

Otherwise have a look at the source code, especially `Biv::Viewer`:

```ruby
puts Biv::Viewer.new(“my-image.png”).to_s
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/ruby-blocky-image-viewer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
