module.exports = {
  verbose: false,
  browsers: ["chrome", "safari"],
  plugins: {
    sauce: {
      browsers: [
        {
          browserName: "Safari",
          platform: "OS X 10.9",
          version: "7.0"
        },
        {
          browserName: "Chrome",
          platform: "Windows 8.1",
          version: "36.0"
        }
      ]}
  }
};