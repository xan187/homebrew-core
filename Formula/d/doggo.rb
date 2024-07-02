class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3358c6017d3f3220e84ed86b7a67bdf15a079e4052eb85f51e87b16b6d2961c2"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bb46b4e3376a0990e0d34c788931153a6b55a357a456ba969673ea6c21010b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cd40e5cb34f19a73d7483602c897988761a88daa3536be49cfa6de90f6d95f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ced6713b0465fea2582757afa4773101d1a5f0d86582dd497f95eef34fdee76d"
    sha256 cellar: :any_skip_relocation, sonoma:         "06b3594b2eb05e656f295e85ac4f2bc9d41ad83f6d6fa075a5c2150d9f5d0093"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3579ace8912596588e837de62e38d5bef20c99d3e1d5f85fe224e980281d71"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6d918c75dfff6b9a3c6e93ac502fab10ca3bb5e1bbffac6a8a74df857dbffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba67bf20855259609c27eda9612bd0ea4f72f490e5469ce384597a549f9ca86"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
