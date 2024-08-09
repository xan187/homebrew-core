class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3557",
      revision: "3071c0a5f218f107dabd13b73f6090af683ef5ec"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c91fb4428dda3174a3633b401a78b28a28b0aa718e452220e020cdc65397c30"
    sha256 cellar: :any,                 arm64_ventura:  "627a8d12966de10e85df43170e9900c5d17bd6d8b646933029022a53bedcb657"
    sha256 cellar: :any,                 arm64_monterey: "608ffb4785791edabcf1af88932c3bf34f4b2e3eae7a1dd6ccdccd40b1e46f4d"
    sha256 cellar: :any,                 sonoma:         "539dce2d0c682884b2f26052aa97d93342051759c8d7871e7e650d1ad23cedf9"
    sha256 cellar: :any,                 ventura:        "6c5f8443bb29f324bc7c4a8ad1d7f74a41e0ad9b1cc2220ffca6ac78cbbb152f"
    sha256 cellar: :any,                 monterey:       "1d5ee1e57986403633995f313c822c77d80b95f04a0ed80ffad604391248028e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf66032959b0f2cd51cc12d6fe51e7adc785df098e69ef09df76712fd0d40ac"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
