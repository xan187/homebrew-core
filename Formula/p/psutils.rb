class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/96/19/711a118a9e14dc03ff0aa0e6611da630fcc90cdd9e7693a3fbd8dacb5884/psutils-3.3.7.tar.gz"
  sha256 "73a60d2e9e80713bfd5d1be6912e7d05bcb5362957b4b1e871bf7fc7d42dd874"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b07ff9edc2c67dd1451701d5d1d44cc95af9e6caa3895a711b347be99898b1c5"
  end

  depends_on "libpaper"
  depends_on "python@3.13"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/09/2d/40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954d/puremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/6b/9a/72d74f05f64895ebf1c7f6646cf7fe6dd124398c5c49240093f92d6f0fdd/pypdf-5.1.0.tar.gz"
    sha256 "425a129abb1614183fd1aca6982f650b47f8026867c0ce7c4b9f281c443d2740"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
