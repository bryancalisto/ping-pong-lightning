const generateRandomPort = () => {
  const ports = Array(100).fill(3000).map((num, i) => num + i); // 3000 - 3099
  return ports[Math.floor(Math.random() * 100)];
}

module.exports = {
  generateRandomPort
};