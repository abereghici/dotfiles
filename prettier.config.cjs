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
        printWidth: 70,
        proseWrap: 'never',
        trailingComma: 'none',
      },
    },
  ],
}

module.exports = config
