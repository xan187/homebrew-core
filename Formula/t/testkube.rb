class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.80.tar.gz"
  sha256 "ab2ea07f5a640221e0d9655d5fa3353557558e2b0569a021e566fb9d88467495"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6a0a5152d5a3a604fdb7bc19e0a151f2ac7404b34abd9a247f2567146fbe97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d6a0a5152d5a3a604fdb7bc19e0a151f2ac7404b34abd9a247f2567146fbe97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d6a0a5152d5a3a604fdb7bc19e0a151f2ac7404b34abd9a247f2567146fbe97"
    sha256 cellar: :any_skip_relocation, sonoma:        "c80b5420329d4bf2c14c2092dab1560418d858662ffe1c7c035014878f6529ef"
    sha256 cellar: :any_skip_relocation, ventura:       "c80b5420329d4bf2c14c2092dab1560418d858662ffe1c7c035014878f6529ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd37bfaff3a1726537fe76bafe25616e0cd800e3055e7fe11add3d7aeb8435b"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
