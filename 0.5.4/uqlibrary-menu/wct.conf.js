module.exports = {
  verbose: false,
  browsers: ["chrome"],
  plugins: {
    sauce: {
      browsers: [
      {
        browserName: "Safari",
        platform: "OS X 10.9",
        version: "7.0"
      }
  ]}
}
};
