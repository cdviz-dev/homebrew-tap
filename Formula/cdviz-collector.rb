class CdvizCollector < Formula
  desc "A service and CLI tool for collecting SDLC/CI/CD events and dispatching them as CDEvents"
  homepage "https://cdviz.dev"
  version "0.19.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.19.6/cdviz-collector-aarch64-apple-darwin.tar.xz"
    sha256 "723b7b43a9837513dcde7cf8be0109be81935919600c52b69a622fce031233b4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.19.6/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8c060b1e3994d908d2080c63434aafad231bd676de90bb5714d60fc83c911fb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.19.6/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bff9864bed040bcd82863949f46a99101e6a328289d1bc11676fb37266414a9a"
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
