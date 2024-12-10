class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.94.0.tgz"
  sha256 "137dd5f5aaa1cb469c4588662201e07a483fe6917359e734e8a1430c56664305"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c9999a12981026f9cbc95dfb97a231959adea673ad675a9482f928b0322ad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c9999a12981026f9cbc95dfb97a231959adea673ad675a9482f928b0322ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56c9999a12981026f9cbc95dfb97a231959adea673ad675a9482f928b0322ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a80abc894d2528098ad940e015c466425e18336fb2ea94284dea9d3ede48ff80"
    sha256 cellar: :any_skip_relocation, ventura:       "a80abc894d2528098ad940e015c466425e18336fb2ea94284dea9d3ede48ff80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "116524e35197a776eb2788992c7f5b67582cd84e7f3cc9dec601ec0250f5690a"
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
