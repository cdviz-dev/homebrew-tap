class CdvizCollector < Formula
  desc "A service and CLI tool for collecting SDLC/CI/CD events and dispatching them as CDEvents"
  homepage "https://cdviz.dev"
  version "0.30.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.30.0/cdviz-collector-aarch64-apple-darwin.tar.xz"
      sha256 "57062a6542e6c9506b25fd8bff2af211f132de8c42d3d358aeaa578e35e5c873"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.30.0/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b47974af4bf1317f1b45dcbee5a91b4da49627a3b0293c319751e5fd3a5929e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.30.0/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "590972c29d1470f5785c51fba26bb741a93f4f0ddf11840078fb62fa46f65ad0"
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
