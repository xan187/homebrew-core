class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.12.1.tar.gz"
  sha256 "442024caa4be0b27ac679ac3d69ebf86631eb6899b88b0f430962f4b5ddecccd"
  license "MIT"
  version_scheme 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9af8d2e6c15e86848370bc0aea30760857c4ee0f946b5d2eb35f658bb7c71762"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8955d9bdc2701ad8d897dd3b413351a9c9c85919f85c1458bd0324a925e22eb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b0a34641fd57108590607d3f5d4af3d8a05d77cc85379e8314da076bdc8c21e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5d7979d7192300ae9ee08dd5958b2b3ea5e5ebbd2f79c080f5c91eea63ca171"
    sha256 cellar: :any_skip_relocation, ventura:        "57a42a3a3fb333cf72abc3a3e4b2d2e9e443287481712effc2b485b0e4ea2b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "99b581dec5d07242db564d9239f86bb2e2d589ba842cdbb6656c44d1de9e8971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed62b0365100b1e3a41fae2a984032c35ac8c13ac809dbd6edd16e928d42f239"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
