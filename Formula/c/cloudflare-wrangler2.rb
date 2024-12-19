class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.98.0.tgz"
  sha256 "717cd0c848e03d73d396095d46e40251ca368040dfbbd02b7908680515998df7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfd81c1760dbf4df6cb53a2ab6c1ae5fbadc372e94dcde48db67589a096ee6a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfd81c1760dbf4df6cb53a2ab6c1ae5fbadc372e94dcde48db67589a096ee6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfd81c1760dbf4df6cb53a2ab6c1ae5fbadc372e94dcde48db67589a096ee6a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2bd725fd5c41d917d5c201a27c37304804ba0efc99ab6a3ada26384e16655c4"
    sha256 cellar: :any_skip_relocation, ventura:       "a2bd725fd5c41d917d5c201a27c37304804ba0efc99ab6a3ada26384e16655c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d435813507fd6a7e1e763d5848d77535b7e6eb530d39b33df2d92b887fdf2186"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
