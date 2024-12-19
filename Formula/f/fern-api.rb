class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.6.tgz"
  sha256 "3f16586bb3466ea973daf195405465b15eca38e4991703be7cc0a4f398b961f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aed44eacc7be5dc754533aafb7cd35336706c7a0cccc5ad902a303f47bae7545"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end
