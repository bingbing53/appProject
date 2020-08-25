// module.exports = {
//   presets: [
//     '@vue/app'
//   ],
//    plugins: [
//     ['import', {
//       libraryName: 'vant',
//       libraryDirectory: 'es',
//       style: true
//     }, 'vant']
//   ]
// }

const plugins = [
    ['import', {
      libraryName: 'vant',
      libraryDirectory: 'es',
      style: true
    }, 'vant']
  ]
if (['production', 'prod'].includes(process.env.NODE_ENV)) {
    plugins.push("transform-remove-console")
}
module.exports = {
    "presets": [
        [
            '@babel/preset-env',
            // {
            //     polyfills: [
            //         'es6.promise',
            //         'es6.symbol'
            //     ]
            // }
        ]
    ],
    // presets: [
    //     [
    //         "@vue/app",
    //         {
    //             "useBuiltIns": "entry",
    //             polyfills: [
    //                 'es6.promise',
    //                 'es6.symbol'
    //             ]
    //         }
    //     ]
    // ],
    plugins: plugins
};