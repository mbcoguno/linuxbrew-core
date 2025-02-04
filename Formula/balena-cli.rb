require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.14.0.tgz"
  sha256 "c44712d99b9a227980a90523b0cdd256b78c240e524730b81fd6738032ec990d"
  license "Apache-2.0"

  bottle do
    sha256 "c69a1dac0d3e0685b885fa7339608e2c9f19775082db8d2b3ebdd6f97cd592af" => :catalina
    sha256 "d9ad59356130ac0f71b225c031a51126b264d330127b50b0b6853fc105feaed4" => :mojave
    sha256 "103d21397749f5152a52bf7fd6de98d1c1c01adfb6fbe7ce4f62669286597b77" => :high_sierra
    sha256 "d00c5f732815124c92ce6b9b23e53b7cf9903123882d7f06c95f47e55ba1c80b" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
