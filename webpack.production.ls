require! {
  'webpack-merge': { merge }
  './webpack.common.ls': webpack-common
}

module.exports = merge webpack-common,
  mode: \production
