class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.1.2/nrpe-4.1.2.tar.gz"
  sha256 "366cd5de9953872ed78e1a5e8fe36c8c86839a5fbf8b894f38211c915a83434a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "9757e99a6d68e0cb29764dc471a70e497cac3b9ac912f63b47c127fcf6dda953"
    sha256 cellar: :any, arm64_sonoma:  "cd3f7b4476cd1d4c24eb407f6f362f987f67f458148c352b9113a0b2f1d64a3f"
    sha256 cellar: :any, arm64_ventura: "38f2a9a252fc2f9b126492b4e91bfb97511d9df998eb4fc885c2b05c5fe88aad"
    sha256 cellar: :any, sonoma:        "ec4aeee705ce21e4919645033daf725311d42b4e1c0b6e645338e770bc6a45a7"
    sha256 cellar: :any, ventura:       "729cd5449d1aa362aace8ced5b52e6c54f09c91acdea8cd63fc6c2f6c31edb1a"
  end

  depends_on "nagios-plugins"
  depends_on "openssl@3"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--with-piddir=#{var}/run",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl@3"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile" do |s|
      s.gsub! "$(LIBEXECDIR)", "$(SBINDIR)"
      s.gsub! "$(DESTDIR)#{HOMEBREW_PREFIX}/sbin", "$(SBINDIR)"
    end

    system "make", "all"
    system "make", "install", "install-config"
  end

  def post_install
    (var/"run").mkpath
  end

  service do
    run [opt_bin/"nrpe", "-c", etc/"nrpe.cfg", "-d"]
  end

  test do
    pid = spawn bin/"nrpe", "-n", "-c", "#{etc}/nrpe.cfg", "-d"
    sleep 2
    sleep 10 if Hardware::CPU.intel?

    begin
      output = shell_output("netstat -an")
      assert_match(/.*\*\.5666.*LISTEN/, output, "nrpe did not start")
      pid_nrpe = shell_output("pgrep nrpe").to_i
    ensure
      Process.kill("SIGINT", pid_nrpe)
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
