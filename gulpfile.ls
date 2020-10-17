require! {
  gulp: { series, parallel, src, dest, watch }
  del
  'webpack-stream': webpack
  'gulp-image': image
  'gulp-pug': pug
  'gulp-htmlmin': htmlmin
  'gulp-sass': sass
  'gulp-postcss': postcss
  'browser-sync'
  'gulp-plumber': plumber
  './webpack.development.ls': webpack-development-config
  './webpack.production.ls': webpack-production-config
}
bs = browser-sync.create!

require! sass: dart-sass
sass.compiler = dart-sass

image-extensions = <[ png jpg jpeg gif svg ]>

src-images = image-extensions
  .map (ext) -> 'src/assets/**/*.' + ext

src-assets = [ 'src/assets/**' ]
  .concat src-images.map (glob) -> '!' + glob

dist-files =
  * 'dist/*.html'
  * 'dist/*.js'
  * 'dist/*.css'
  * 'dist/assets/*'

clean = (done) !->
  del dist-files
  done!

copy-images = (done) !->
  src src-images
    .pipe image!
    .pipe dest 'dist/assets'
  done!

copy-assets = (done) !->
  src src-assets
    .pipe dest 'dist/assets'
  done!

build-webpack = (debug) -> (done) !->
  src 'src/app.js'
    .pipe plumber!
    .pipe webpack do
      config: if debug then webpack-development-config else webpack-production-config
    .pipe dest 'dist'
  done!

build-pug = (done) !->
  src 'src/presentation.pug'
    .pipe plumber!
    .pipe pug!
    .pipe htmlmin do
      collapse-boolean-attributes: on
      collapse-whitespace: on
      remove-attribute-quotes: on
      remove-comments: on
      remove-redundant-attributes: on
    .pipe dest 'dist'
    .pipe bs.stream!
  done!

build-sass = (done) !->
  src 'src/override.sass'
    .pipe plumber!
    .pipe sass do
      indented-syntax: on
      output-style: \compressed
      include-paths:
        * 'node_modules'
        ...
    .pipe postcss!
    .pipe dest 'dist'
    .pipe bs.stream!
  done!

browser-sync-init = (done) !->
  bs.init do
    server:
      base-dir: \.
      index: 'dist/presentation.html'

    startPath: '/dist/presentation.html'
    port: 8080
    https: off
    reload-delay: 500
    reload-on-restart: on

  done!

browser-sync-reload = (done) !->
  bs.reload!
  done!

watch-then-sync = (done) !->
  watch 'src/app.js', series build-webpack(on), browser-sync-reload
  watch 'src/**/*.pug', series build-pug, browser-sync-reload
  watch 'src/**/*.sass', series build-sass, browser-sync-reload
  done!

exports <<<
  default: series do
    clean
    parallel do
      build-webpack(on)
      build-pug
      build-sass
      copy-images
      copy-assets
    parallel do
      browser-sync-init
      watch-then-sync

  build: series do
    clean
    parallel do
      build-webpack(off)
      build-pug
      build-sass
      copy-images
      copy-assets
