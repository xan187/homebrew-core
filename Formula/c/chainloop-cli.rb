class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.168.0.tar.gz"
  sha256 "36addb33087ddd44386b97e7b57abe26a0402702ff45b5efcc95aec21bf60928"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0581eb0db0f441f52a1b3939ba23094dd8eeb6a3c8a7986ccca942bf81072a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0581eb0db0f441f52a1b3939ba23094dd8eeb6a3c8a7986ccca942bf81072a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0581eb0db0f441f52a1b3939ba23094dd8eeb6a3c8a7986ccca942bf81072a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "402e6243a5d1f0e768241a0fcddccb825944bf6e0d56c90c284c392f0e192dab"
    sha256 cellar: :any_skip_relocation, ventura:       "ba6254765e15372bb966bd7e9508e5b6049b4d4608371101ac7393329a26597d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e1c88ac6e75c575d0e7d9a2672d04e109b3a9ca97f4cc81aeee7b3b7f44f02e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
