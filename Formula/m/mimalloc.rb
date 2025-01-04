class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "4d7e771b51ba0d3c4a5850d3f7f7f82c1b04af318e1351553f46aa3336439540"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d36d1549f3b7984858fb7ae64674b731758f8f40d9a0b9db95c5b6e4ff928f12"
    sha256 cellar: :any,                 arm64_sonoma:  "bed3eb65b43376dfb67e5d7f74366f12ed42b2bbede8aed7d74a8603ababb66c"
    sha256 cellar: :any,                 arm64_ventura: "197bb07e96aeab9461da36846113cd858f2511b4fa52b7b14235970dac186c35"
    sha256 cellar: :any,                 sonoma:        "11f2ec710fc3a6f0ca38b59aeada9275b6fe5df76e23d5856914e1dc3d908cc6"
    sha256 cellar: :any,                 ventura:       "633ae867151e711f2e614c5176d90e499a387792d6a6b5da1702c1a7e79af25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3526a6bf0ceca26ceb8db2fddc6ed7ea1948e3fecd4799f691ef6b4f3aa740ee"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
