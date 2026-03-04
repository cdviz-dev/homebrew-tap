class CdvizCollector < Formula
  desc "A service and CLI tool for collecting SDLC/CI/CD events and dispatching them as CDEvents"
  homepage "https://cdviz.dev"
  version "0.26.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.26.0/cdviz-collector-aarch64-apple-darwin.tar.xz"
      sha256 "1eeb4a0d6d518b0de8d60076217492864f68fe9c1f0cb22a0c169205b549c04e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.26.0/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "71712c11564b308807ad028b19de9213aa8f64b6c6a19a1a650a445a242e0238"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.26.0/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d617054f8509782102fc279ef50536862ce4d7729deed874393bd6e6e9c67037"
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
