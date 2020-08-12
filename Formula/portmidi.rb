class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "66b8773aa12201f7fa2bf44044ab32bdab1cdf763db870fde3f0bd7254c5d877" => :catalina
    sha256 "2a6258da2f83b668c2ba85edd9e49313114af5bfb288ebc681bd4cde221279c6" => :mojave
    sha256 "61f9a94aaca3f317c50e643b06617804d37798e32dd1cfcc1c24aecdc24aec75" => :high_sierra
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "alsa-lib"

    patch do
      url "https://deb.debian.org/debian/pool/main/p/portmidi/portmidi_217-6.debian.tar.xz"
      sha256 "6b2456361d87cbef6c13ecf4d03ce4fbd661101e289eb7b9cbd76301e794fce8"
      apply %W[
        patches/00_cmake.diff
        patches/01_pmlinux.diff
        patches/03_pm_test_Makefile.diff
        patches/13-disablejni.patch
        patches/20-movetest.diff
        patches/30-porttime_cmake.diff
        patches/50-change_assert.diff
      ]
    end
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :el_capitan

    inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    if OS.mac?
      # Fix outdated SYSROOT to avoid:
      # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
      inreplace "pm_common/CMakeLists.txt",
                "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
                "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

      system "make", "-f", "pm_mac/Makefile.osx"
      system "make", "-f", "pm_mac/Makefile.osx", "install"
    else
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end
end
