class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.10-27.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-7.0.10-27.tar.xz"
  sha256 "7f8664a6b75149569a3795e3e63bb12ed90e590e6d3edf384ab79c553f6867ab"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "07b7bc234d1366b25e611ecaa1d7ba4dc30236245e1534fc54e05d70235fad1f" => :catalina
    sha256 "8c887493477f2f08ce57bf5f437236b1080833455f51b225c9adc36e15ea0cfe" => :mojave
    sha256 "1eec78b469a5fc7de0e54d6f4e6e874fd824e748aba1ff8e51f2e5a2e1b5e0c1" => :high_sierra
    sha256 "a83efcce62b80583245f7c7f68d455924fd8d3dc747abfb09d9f87ed24d99bb3" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "liblqr"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = %W[
      --enable-osx-universal-binary=no
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-openjp2
      --with-openexr
      --with-webp=yes
      --with-heic=yes
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --with-lqr
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
      --enable-openmp
      ac_cv_prog_c_openmp=-Xpreprocessor\ -fopenmp
      ac_cv_prog_cxx_openmp=-Xpreprocessor\ -fopenmp
      LDFLAGS=-lomp\ -lz
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
    assert_match "Helvetica", shell_output("#{bin}/identify -list font")
  end
end
