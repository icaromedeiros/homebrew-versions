class Virtuoso616 < Formula
  homepage "http://virtuoso.openlinksw.com/wiki/main/"
  url "https://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.6/virtuoso-opensource-6.1.6.tar.gz"
  sha256 "c6bfa6817b3dad5f87577b68f4cf554d1bfbff48178a734084ac3dcbcea5a037"

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", :branch => "develop/6"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl"

  conflicts_with "unixodbc", :because => "Both install `isql` binaries."

  skip_clean :la

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end

  test do
    "[[ $(#{bin}/virtuoso-t --help) != *6.1.6* ]]"
  end
end
