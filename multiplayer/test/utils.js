const generateRandomPort = () => {
  const min = 3000;
  const max = 3999;
  return Math.floor(Math.random() * (max - min + 1) + min);
}

module.exports = {
  generateRandomPort
};