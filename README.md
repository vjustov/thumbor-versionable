thumbor-versionable
===================

[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/vjustov/thumbor-versionable?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A Thumbor client that lets you specify versions of given image and generates the url for them.

Often you'll want to add different versions of an image. The classic example is image thumbnails but doing that on the server is time/resource consuming, that's when [thumbor](https://github.com/thumbor/thumbor) comes in.

This gem provides a simple and extremely flexible way generate thumbor URLs for each image version in Ruby applications. It works well with Rack based web applications, such as Ruby on Rails and is a drop drop-in replacement for [carrierwave](https://github.com/carrierwaveuploader/carrierwave) when the image processing times have gone too high.


## Installation

In Rails, add it to your Gemfile:

    gem 'thumbor-versionable', github: 'vjustov/thumbor-versionable'

Finally, restart the server to apply the changes.

## Usage

    class Product
      include Versionable

      versionable :image, :external_fake_image do
        version :form_thumbnail, width: 100, height: 150 do
          filter :quality, 50
        end
        version :notification_thumbnail, width: 50, height: 50
      end
    end

Then you can access a version by doing:

    @product.image.form_thumbnail.url

## Support

Available arguments to a version are:

    meta: bool
    width: int
    height: int
    smart: bool
    fit_in: bool

Filters can be specified in a DSL way and all are supported. You can also include the same filter more than once and they will appear in that order.

    version :form_thumbnail, width: 100, height: 150 do
      filter :colorize, [25,10,53,'79A8B2']
      filter :quality, 50
      filter :grayscale
      filter :colorize, [35,40,50,'79A8B2']
    end

If you need more info on what each option does, check [thumbor's documentation](github.com/thumbor/thumbor/wiki).

## Contributing

- [Fork it](https://github.com/vjustov/thumbor-versionable)
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am "Add some feature")
- Run `rake` to run all of the specs and make sure they are all green.
- Run `rubocop` and keep the cop happy.
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request
