module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint", "react"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "prettier",
  ],
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
  },
  rules: {
    "react/react-in-jsx-scope": 0,
    "react/jsx-uses-react": 0,
  },
  env: {
    node: true,
  },
  settings: {
    react: {
      version: "detect",
    },
  },
};
