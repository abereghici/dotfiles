/**
 * @see https://prettier.io/docs/en/options
 * @type {import("prettier").Config}
 */
const config = {
  plugins: ['prettier-plugin-sh'],
  singleQuote: true,
  semi: false,
  trailingComma: 'es5',
  overrides: [
    {
      files: '*.md',
      options: {
        arrowParens: 'avoid',
        printWidth: 80,
        proseWrap: 'always',
        trailingComma: 'none',
      },
    },
  ],
}

module.exports = config
