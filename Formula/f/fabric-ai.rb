class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.230.tar.gz"
  sha256 "4f5960ad8a97fdd23c04b674da4a833d7769f5983f94fda31b15756b292d149d"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff8a5aa6297401ab9929f1a8a2fbd757c2d05498f6ea782ff85df974a0df6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cff8a5aa6297401ab9929f1a8a2fbd757c2d05498f6ea782ff85df974a0df6a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cff8a5aa6297401ab9929f1a8a2fbd757c2d05498f6ea782ff85df974a0df6a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8cbfef7d4bf4be242333df46af503dc5df6cd6cf678c1c23906751e91b8f3f"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8cbfef7d4bf4be242333df46af503dc5df6cd6cf678c1c23906751e91b8f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a35f55e9dfe0484a485381dfbe91947ff0515a3085846c4ea977b332152b507e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
