module.exports = {
  overrides: [
    {
      // Needed until this is resolved
      // https://github.com/prettier/prettier/issues/11834
      files: "*.hbs",
      options: { parser: "html" },
    },
    {
      files: ".{parcelrc,postcssrc}",
      options: { parser: "json" },
    },
  ],
};
