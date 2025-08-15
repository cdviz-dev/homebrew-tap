class CdvizCollector < Formula
  desc "A service & cli to collect SDLC/CI/CD events and to dispatch as cdevents."
  homepage "https://cdviz.dev"
  version "0.11.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.11.1/cdviz-collector-aarch64-apple-darwin.tar.xz"
    sha256 "d975dde5ddf535faed5a67481fa546614c81c81843fbe647e5a4acf75e4b2bf8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.11.1/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6264c5ded09dcb2e8dc0f5aef9835828c324d1226119934e0ae29783443d8081"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.11.1/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d0dea0439206e370aa9ca1d1dcb77eb9ea51809a1ee1d2db30b4490de71f4868"
    end
  end
  license "AGPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
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
