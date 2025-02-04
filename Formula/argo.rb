class Argo < Formula
  desc "Get stuff done with container-native workflows for Kubernetes"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj/argo.git",
      tag:      "v2.9.5",
      revision: "5759a0e198d333fa8c3e0aeee433d93808c0dc72"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8db9382788c4305eda6d2ee651cd6384dc4b7e5f163c23fc703cd5158abfbde" => :catalina
    sha256 "4ac01435917d55a35f7d60dc6d861f9332f8319ab71a78499e2725c2f0e03687" => :mojave
    sha256 "2ba249f5d2a348b140dc07de880f1aff21c75e100e2342cd5dcab8dca2390b12" => :high_sierra
    sha256 "70277609f3b5a483c6a60464c096db4a52e3706941ac9b196e68bb2a57c07f66" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # this needs to be remove to prevent multiple 'operation not permitted' errors
    inreplace "Makefile", "CGO_ENABLED=0", ""
    system "make", "dist/argo"
    bin.install "dist/argo"
  end

  test do
    assert_match "argo is the command line interface to Argo",
      shell_output("#{bin}/argo --help")

    # argo consumes the Kubernetes configuration with the `--kubeconfig` flag
    # Since it is an empty file we expect it to be invalid
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/argo lint --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
