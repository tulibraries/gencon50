import resolve from "@rollup/plugin-node-resolve"
import commonjs from "@rollup/plugin-commonjs"

export default {
  input: {
    application: 'app/javascript/application.js'
  },
  output: {
    dir:            'app/assets/builds',
    format:         'esm',
    sourcemap:      true,
    entryFileNames: '[name].js'
  },
  plugins: [
    resolve({ browser: true }),
    commonjs()
  ]
}
