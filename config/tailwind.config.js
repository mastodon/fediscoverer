const defaultTheme = require('tailwindcss/defaultTheme')
const execSync = require('child_process').execSync

let content = [
  './public/*.html',
  './app/helpers/**/*.rb',
  './app/javascript/**/*.js',
  './app/views/**/*.{erb,haml,html,slim}'
]

const gems = ['fasp_base']

gems.forEach((gem) => {
  const gemPath = execSync(`bundle show ${gem}`, { encoding: 'utf-8' }).trim()
  content.push(`${gemPath}/app/helpers/**/*.rb`)
  content.push(`${gemPath}/app/javascript/**/*.js`)
  content.push(`${gemPath}/app/views/**/*.{erb,haml,html,slim}`)
})

console.log(content)

module.exports = {
  content: content,
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
