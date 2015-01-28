module.exports = {
  verbose: false,
  browsers: ["chrome"],
  plugins: {
    sauce: {
      browsers: [
      {
        browserName: "Safari",
        platform: "OS X 10.10",
        version: "8.0"
      }
  ]}
}
};
