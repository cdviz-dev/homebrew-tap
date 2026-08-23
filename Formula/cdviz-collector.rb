class CdvizCollector < Formula
  desc "A service and CLI tool for collecting SDLC/CI/CD events and dispatching them as CDEvents"
  homepage "https://cdviz.dev"
  version "0.49.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.49.0/cdviz-collector-aarch64-apple-darwin.tar.xz"
    sha256 "c7e260830f3c901b8d14376d25163d621f8f4fa11fad4e8a5950f35aff7fdcb4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.49.0/cdviz-collector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d8a772f657b0819460f15d7f72704208fdc268a7cdd191720f6404c2ef24fa4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cdviz-dev/cdviz-collector/releases/download/0.49.0/cdviz-collector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c11955dcd76ce1d8ed45cb75890a8b93fc10f483bb878f217930e4df053753bc"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
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
