class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.155.3.tar.gz"
  sha256 "f4cfcdea4241ee597be998a7add9ab7ff7f362b17456eb24f7b08cccdbf7a648"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "5b47a949d29885683965e21b402e986a48250669cd22da05c9622889b72d002f" => :catalina
    sha256 "cc82b02587d4bb087fbcaba7d8de664fa3056c11093d50fa749fabd0d6212473" => :mojave
    sha256 "4ae120adcbf6ef121ca9dcdbddb9aaf28df1e155e8af4c1969c6cfe724d268dc" => :high_sierra
    sha256 "244405e64390fcff645b859c4d0a1fcc3fa3145edf412865dbcfc1d376207499" => :x86_64_linux
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
