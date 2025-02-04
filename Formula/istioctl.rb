class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.6.7",
      revision: "2511ab8c8c59a203e77bb804846593c3690fcf4a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ded69ebfe8c096594421fdf6b098b1e9846e455565bf9ab33552fcd7b1f0427" => :catalina
    sha256 "0ded69ebfe8c096594421fdf6b098b1e9846e455565bf9ab33552fcd7b1f0427" => :mojave
    sha256 "0ded69ebfe8c096594421fdf6b098b1e9846e455565bf9ab33552fcd7b1f0427" => :high_sierra
    sha256 "88b7cdd21c7c6ac471617bfb31f8ac1518dbf1d7a8958ef17a20dab00422558d" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
