class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftpmirror.gnu.org/screen/screen-4.4.0.tar.gz"
    mirror "https://ftp.gnu.org/gnu/screen/screen-4.4.0.tar.gz"
    sha256 "ef722a54759a3bf23aad272bbf33c414c1078cad6bcd982fada93c0d7917218b"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "791f7efb94556fee2535bad543dd3ded0afc85b083fed0ce354c9cf859479cee" => :el_capitan
    sha256 "34713de232c8da57b7af9c38eda55cc9f649dc7713ad3c92a58a7ea23b964af1" => :yosemite
    sha256 "456f6a6a6743c4e0dc1af4793fbe4e8908ba966510f2edeaecf0e46023a5c7e5" => :mavericks
  end

  head do
    url "git://git.savannah.gnu.org/screen.git"

    # This patch avoid a bug that prevents detached sessions to reattach
    # See http://lists.gnu.org/archive/html/screen-users/2016-10/msg00007.html
    patch do
      url "https://gist.githubusercontent.com/sobrinho/5a7672e088868c2d036957dbe7825dd0/raw/c6fe5dc20cb7dbd0e23f9053aa3867fcbc01d983/diff.patch"
      sha256 "47892633ccb137316a0532b034d0be81edc26fc72a6babca9761a1649bc67fd1"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    if build.head?
      cd "src"
    end

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256",
                          "--enable-pam"

    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/screen -h", 1)
  end
end
