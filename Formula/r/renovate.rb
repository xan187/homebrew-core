class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.60.0.tgz"
  sha256 "2ab452e98c8e82dce1b4538383f6057dd2ddf59c98c10599e976198f22057659"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dcb273c951e6b86241fed86fc29da97a766b8f8a6285933028cca647f4d5013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a103d0b6f6475d7b299a6a9d7de7eebf0e66fd47b3e72aea143e6e9bb84470d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8dbbb18ab36a640060a2c639888da847cf275312ba929961642c12d39e3cd53"
    sha256 cellar: :any_skip_relocation, sonoma:        "d66e5b933f4c8bb56d8fc0a5d9b1768455f840fcd237ee874fd21487d4e6dd49"
    sha256 cellar: :any_skip_relocation, ventura:       "2216d01d99cf0e05cf1ccebdef4d4af7bc5c06b3de1464fae9df082748905b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2ac27b28ec4b1e44bb8b2836895c0bb882d35562a08dedbeb1832b6b62dfe2"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
