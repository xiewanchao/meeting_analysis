const plugins = []

if(process.env.NODE_ENV === 'production') {
  plugins.push(["transform-remove-console",{"exclude":["error","warn"]}])
}

module.exports = {
  "presets": [
    "@babel/preset-env"
  ],
  plugins
}