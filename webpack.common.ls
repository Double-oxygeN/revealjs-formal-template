require! path

module.exports =
  entry: './src/app.ls'
  output:
    filename: 'app.js'
    path: path.resolve __dirname, \dist

  module:
    rules:
      * test: /\.ls$/
        use:
          * loader: \livescript-loader
          ...
      ...
