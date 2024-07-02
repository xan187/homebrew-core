require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.68.0.tgz"
  sha256 "7c284bca5197e4e56d18fb509904535facc2204f4021c7a7a57371365c743479"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "012a1b2513bca130bdf0d3bd7589ec88387edbebc68d7e5379dd505cbca6bb17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52ceabe6d0dbe1fac21828c5cbf15004666e72ceb78636f66a277d089ad29ac2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff7f5617d68911dc3c03cf485b638f19bf2341b3b5b61a57b22a5c9455d5c3b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3b732013749f7c7d7653dd126711ab76b3b36efb05b6d2eea060da2af0f18e8"
    sha256 cellar: :any_skip_relocation, ventura:        "39382301a37f47cfc8c884e76e261b8640c708615ccb727bcd4cdb7221898e09"
    sha256 cellar: :any_skip_relocation, monterey:       "13aef110526fbb2402087baf236bd6659dc16df1627c6dcd688ff99de2f69243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa16b058220ed28c05a498de9b1a2e3ce303e93254604cb0e9040258dac1e61"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
