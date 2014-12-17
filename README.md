thumbor-versionable
===================

[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/vjustov/thumbor-versionable?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Code Climate](https://codeclimate.com/github/vjustov/thumbor-versionable/badges/gpa.svg)](https://codeclimate.com/github/vjustov/thumbor-versionable)
[![Test Coverage](https://codeclimate.com/github/vjustov/thumbor-versionable/badges/coverage.svg)](https://codeclimate.com/github/vjustov/thumbor-versionable)
[![Build Status](https://travis-ci.org/vjustov/thumbor-versionable.svg?branch=master)](https://travis-ci.org/vjustov/thumbor-versionable)

A Thumbor client that lets you specify versions of given image and generates the url for them.

Often you'll want to add different versions of an image. The classic example is image thumbnails but doing that on the server is time/resource consuming, that's when [thumbor](https://github.com/thumbor/thumbor) comes in.

This gem provides a simple and extremely flexible way generate thumbor URLs for each image version in Ruby applications. It works well with Rack based web applications, such as Ruby on Rails and is a drop drop-in replacement for [carrierwave](https://github.com/carrierwaveuploader/carrierwave) when the image processing times have gone too high.


## Installation

thumbor-versionable can be installed to use with any Ruby web framework. The first step is to install the gem:

    $ gem install thumbor-versionable

Or include it in your project's Gemfile with Bundler:

```ruby
gem 'thumbor-versionable', github: 'vjustov/thumbor-versionable'
```

If you are using rails, that's it! if you are using anything else you will have to require the gem whenever you want to use it.

```ruby
require 'versionable'
```

Just in case, restart the server to apply the changes.

## Usage

You can use thumbor-versionable in one of two ways. if you just want to generate a url of an image to use with thumbor.

```ruby
require 'versionable'
require 'versionable/version'

Versionable.configure do
  thumbor_server 'thumbor_server.example.com'
  secret_key 'S3CR37_K3Y' # This is only needed if you want to sign your requests.
end

thumbor_url = Version.new(width: 45, height: 200).url
```

But if you need many thumbnails or some kind of image manipulation on one of your models you can do it this way:

```ruby
class Product
  include Versionable

  versionable :image, :external_fake_image do
    version :form_thumbnail, width: 100, height: 150 do
      filter :quality, 50
    end
    version :notification_thumbnail, width: 50, height: 0
  end
end
```

Then you can access a version by doing:

```ruby
@product.image.form_thumbnail.url
```

### Calculating Metadata

You can generate a metadata url passing the :meta key with a truthy value to Version, which you could then request using Net::HTTP.

```ruby
thumbor_url = Version.new(width: 145, height: 340, meta: true).url
```

But when you have several versions of one image, one request each to get the metadata of them all, it's not a good idea. We formulated a way to calculate the metadata of the different versions based on the metadata of the parent:

```ruby
metadata = @product.image.fetch_metadata
@product.image.height_from_metadata metadata
@product.image.width_from_metadata metadata

@product.image.notification_thumbnail.height
=> 0
@product.image.notification_thumbnail.calculate_metadata
@product.image.notification_thumbnail.height
=> 75
```

This will only work when the main image metadata has been previously set.

## Thumbor Options

Available arguments to a version are:

    meta: bool
    width: int
    height: int
    smart: bool
    fit_in: bool

Filters can be specified in a DSL way and all are supported. You can also include the same filter more than once and they will appear in that order.

```ruby
version :form_thumbnail, width: 100, height: 150 do
  filter :colorize, [25,10,53,'79A8B2']
  filter :quality, 50
  filter :grayscale
  filter :colorize, [35,40,50,'79A8B2']
end
```

If you need more info on what each option does, check [thumbor's documentation](github.com/thumbor/thumbor/wiki).

## Contributing

- [Fork it](https://github.com/vjustov/thumbor-versionable)
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am "Add some feature")
- Run `rake` to run all of the specs and make sure they are all green.
- Run `rubocop` and keep the cop happy.
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request
