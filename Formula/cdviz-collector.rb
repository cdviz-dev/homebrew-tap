class CdvizCollector < Formula
  desc "A service & cli to collect SDLC/CI/CD events and to dispatch as cdevents."
  homepage "https://cdviz.dev"
  version "0.6.3"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.6.3/cdviz-collector-aarch64-unknown-linux-musl.tar.xz"
      sha256 "342e588d4422082f6cf21978b788a0cc3eb23b1f704f463c2259cfb592321ee9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.6.3/cdviz-collector-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4f4ab00950fffb083aa5f526932e31aa154178067a44b965890acd4d5ccbcf68"
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
