class Sui < Formula
  desc "Next-generation smart contract platform powered by the Move programming language"
  homepage "https://sui.io"
  url "https://github.com/MystenLabs/sui/archive/refs/tags/testnet-v1.39.0.tar.gz"
  sha256 "99dcf686d1c86220e72afaf883f80ca0698da57d6c169fc487e32b4367488dfa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^testnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "681a70e4c5e62e9fe4de918021f52e954d3bffe5139112e97ee1a13337309f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7853f390e0cde8bbe6cafb04847cc01db9445a11b6afcac68887a4c5d5a52a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e8c5b1542d5534397b0c33488216b9a8274074e003641594920f46616e702fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a33a533a8a892bbd74ccd87f965007e8bdbde586963de1aa9e143d6ae93a14f2"
    sha256 cellar: :any_skip_relocation, ventura:       "a4a3173c5db2d838f26a90e98c5515192479bcea55d58db8f75e050699c5ecf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bb21c7e0ca61dda6ae085bcbcc3094ed66efca67a689894f7cec76705e3217c"
  end

  depends_on "cmake" => :build
  depends_on "libpq" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    ENV["GIT_REVISION"] = "homebrew"
    system "cargo", "install", "--features", "tracing", *std_cargo_args(path: "crates/sui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sui --version")

    (testpath/"testing.keystore").write <<~EOS
      [
        "AOLe60VN7M+X7H3ZVEdfNt8Zzsj1mDJ7FlAhPFWSen41"
      ]
    EOS
    keystore_output = shell_output("#{bin}/sui keytool --keystore-path testing.keystore list")
    assert_match "0xd52f9cae5db1f8ab2cb0ac437cbcdda47900e92ee0a0c06906ffc84e26f999ce", keystore_output
  end
end
