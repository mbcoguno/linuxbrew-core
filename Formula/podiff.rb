class Podiff < Formula
  desc "Compare textual information in two PO files"
  homepage "https://puszcza.gnu.org.ua/software/podiff/"
  url "https://download.gnu.org.ua/pub/release/podiff/podiff-1.1.tar.gz"
  sha256 "a97480109c26837ffa868ff629a32205622a44d8b89c83b398fb17352b5be6ff"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "34c82b7a2caa7d65bea883d10bf20dc29346a04c381c9e7bf4a38473916d079f" => :catalina
    sha256 "2a9b5cb91d5f6b36ea965f2d7bd85fd47c5719f3a9d9079cba7e5d2f6cd667c3" => :mojave
    sha256 "c862b6ec4c259c495879fd91dcb143e9768b2cbb12ae5e07506d63350e36cdbb" => :high_sierra
    sha256 "be964cc5259d37f0f4676d5e3a0fac77b42e4f3e7641c7579d47182e4f036e83" => :sierra
    sha256 "24f385afff1c9074d995cd1374c005e8770a80ef11b06058f6024eee67a9de69" => :el_capitan
    sha256 "21cc248bf36ce685061e234f57c6fc5cbe0d207b201e7a8e485ee7b71d3d21c6" => :yosemite
    sha256 "c3a3b66344303ad473d8c6808eb9e2a2124bb0a801536870b739beba4de3d5ae" => :mavericks
    sha256 "cce3e54a70334a0804fe4be7800efd8ac9b713a73227f7ce6f8876b6626448d0" => :x86_64_linux
  end

  def install
    system "make"
    bin.install "podiff"
    man1.install "podiff.1"
  end

  def caveats
    <<~EOS
      To use with git, add this to your .git/config or global git config file:

        [diff "podiff"]
        command = #{HOMEBREW_PREFIX}/bin/podiff -D-u

      Then add the following line to the .gitattributes file in
      the directory with your PO files:

        *.po diff=podiff

      See `man podiff` for more information.
    EOS
  end

  test do
    system "#{bin}/podiff", "-v"
  end
end
