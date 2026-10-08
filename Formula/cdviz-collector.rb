class CdvizCollector < Formula
  desc "A service and CLI tool for collecting SDLC/CI/CD events and dispatching them as CDEvents"
  homepage "https://cdviz.dev"
  version "0.53.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.53.1/cdviz-collector-aarch64-apple-darwin.tar.xz"
      sha256 "cf793661a52e40f28874586b9909f5528dd7064a3b096e89f19bfff339f904f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.53.1/cdviz-collector-x86_64-apple-darwin.tar.xz"
      sha256 "b5fbf2bf9ea654d78de7bad3a1c85c2f93bd7e5d0774d24227c618ffa109f044"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.53.1/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f61d7a4ac783abf6d2a6f3840a6d9b66556259fc70d10a62490f216da12bd003"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.53.1/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8287ae0491589bd1c410a8517853ada81fb4e03ff8ae8220186e873bd2470e65"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cdviz-collector"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cdviz-collector"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cdviz-collector"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cdviz-collector"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
