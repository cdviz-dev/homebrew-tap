class CdvizCollector < Formula
  desc "A service and CLI tool for collecting SDLC/CI/CD events and dispatching them as CDEvents"
  homepage "https://cdviz.dev"
  version "0.25.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.25.1/cdviz-collector-aarch64-apple-darwin.tar.xz"
      sha256 "36392f8ce36dba1841918675961992e4df7b859b1301bc39001be007b3db2304"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.25.1/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3980e393c95ec78d3562163fa75d0719baa28f2db837cd7c62184f24d6d2ce7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.25.1/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "412580a82cdf42ddbf1b66adf1509331d59a309b10afc5390826812ede0a5e89"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cdviz-collector" if OS.mac? && Hardware::CPU.arm?
    bin.install "cdviz-collector" if OS.linux? && Hardware::CPU.arm?
    bin.install "cdviz-collector" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
