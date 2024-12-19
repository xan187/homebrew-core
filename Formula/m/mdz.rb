class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://github.com/LerianStudio/midaz/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "d42eceebbad944b6cd0debc7499360373ade37e99c342e7c78c094b97dc00399"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a62b43f7f89ea0f4af2cc8a3ac1287c98ae1d82b0d74090325e68fa5f47ed3fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a62b43f7f89ea0f4af2cc8a3ac1287c98ae1d82b0d74090325e68fa5f47ed3fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a62b43f7f89ea0f4af2cc8a3ac1287c98ae1d82b0d74090325e68fa5f47ed3fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7577a8bd19623091e266698015267c605d28a14be1d40522926399b1c6482b9d"
    sha256 cellar: :any_skip_relocation, ventura:       "7577a8bd19623091e266698015267c605d28a14be1d40522926399b1c6482b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d4df80471b67b46225a210a5c3dec4297ed9c2731400c8bfd0af432ebbb549"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http://127.0.0.1:8080"
    url_api_ledger = "http://127.0.0.1:3000"

    output = shell_output("#{bin}/mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output
  end
end
