# Sprockets::Preload

[![Gem Version](https://badge.fury.io/rb/sprockets-preload.png)](http://badge.fury.io/rb/sprockets-preload)
[![Build Status](https://travis-ci.org/inossidabile/sprockets-preload.png?branch=master)](https://travis-ci.org/inossidabile/sprockets-preload)

Ever had heavy Javascript assets that were taking a while to download? **Sprockets::Preload** allows you to preload it using only the directives of **Sprockets**.

Show your users nice loading bar instead of just white loading screen!

## Usage

Imagine that you are riding on Rails and have the following `application.js` where `jquery`, `jquery-ui` and `front` (MVC front-end application) take around 500kb compressed altogether:

```javascript
//= include helpers
//= include jquery
//= include jquery-ui
//= include front

// Starting application
$ -> Front.start()
```

Let's make user experience smooth:

1. Add `sprockets-preload` to your `Gemfile` and run `bundle install`

2. Change `//= include` to `//= preload` for the assets you want to detach:

    ```javascript
    //= include helpers
    //= preload jquery
    //= preload jquery-ui
    //= preload front

    // Starting application
    $ -> Front.start()
    ```

3. Delay initialization to the moment when detached assets are loaded:

    ```javascript
    //= include helpers
    //= preload jquery
    //= preload jquery-ui
    //= preload front

    SprocketsPreload.success = function() {
      // Starting application
      $ -> Front.start()
    }
    ```

4. Track loading and show progress to user

    ```javascript
    //= include helpers
    //= preload jquery
    //= preload jquery-ui
    //= preload front

    SprocketsPreload.success = function() {
      // Starting application
      $ -> Front.start()
    }

    SprocketsPreload.progress = function(percent) {
      // User isn't going to see percents at console
      // but that's just an example after all
      console.log(percent);
    }
    ```

5. **IMPORTANT**: Rails development environment uses stub to ease debugging. Thus while things keep working, assets don't really get detached. To force production-grade loading (just to make sure things work fine) add `//= preload!` to your manifest:

    ```javascript
    //= preload!
    //= include helpers
    //= preload jquery
    //= preload jquery-ui
    //= preload front

    SprocketsPreload.success = function() {
      // Starting application
      $ -> Front.start()
    }

    SprocketsPreload.progress = function(percent) {
      // User isn't going to see percents at console
      // but that's just an example after all
      console.log(percent);
    }
    ```

    Make sure to remove `//= preload!` when your tests are done.

## Caching options

To make loading progress tracking smooth and cache manually controllable, **Sprockets::Preload** uses `localStorage` to cache assets (it falls back to default browser cache automatically). **Sprockets** provides digests and logic-aware dependency system that work much better and much more predictable than more common default HTTP caching.

That's said – you really want to keep `localStorage` strategy in the vast majority of cases. If however for some reason you still want to make it use default browser cache, set `SprocketsPreload.localStorage` to `false` like this:

```javascript
//= preload!
//= include helpers
//= preload jquery
//= preload jquery-ui
//= preload front

SprocketsPreload.localStorage = false;

SprocketsPreload.success = function() {
  // Starting application
  $ -> Front.start()
}

SprocketsPreload.progress = function(percent) {
  // User isn't going to see percents at console
  // but that's just an example after all
  console.log(percent);
}
```

**Note** that default caching strategy will still try to emulate loading progress tracking but it works MUCH worse.

## Compatibility

**Sprockets::Preload** does not depend on Rails. However it has proper rail-ties and is fully-functional on Rails out of box. If you want to use it outside of Rails with clean **Sprockets** – see `lib/sprockets/preload/engine.rb` for required initialization settings.

## History

**Sprockets::Preload** is a mutated fork of [Joosy](http://joosy.ws) 1.x preloaders. For Node.js-based applications please refer to [Loada](https://github.com/inossidabile/loada).

## Maintainers

* Boris Staal, [@inossidabile](http://staal.io)

## License

It is free software, and may be redistributed under the terms of MIT license.