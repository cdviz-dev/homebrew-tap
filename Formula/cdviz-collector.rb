class CdvizCollector < Formula
  desc "A service & cli to collect SDLC/CI/CD events and to dispatch as cdevents."
  homepage "https://cdviz.dev"
  version "0.3.0"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.3.0/cdviz-collector-aarch64-unknown-linux-musl.tar.xz"
      sha256 "1b5eb8f59b8e7ef444edb3a42f5ab0888bc5277d41828b2bae24c7c2abba8f69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.3.0/cdviz-collector-x86_64-unknown-linux-musl.tar.xz"
      sha256 "8160180a7f6f85634ef8d946b22940cf0ede097beca1ae7d7470bab4c528014c"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
