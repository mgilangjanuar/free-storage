class FreeStorage < Formula
  desc "Free regenerable disk space: build outputs, package and app caches, logs"
  homepage "https://github.com/mgilangjanuar/free-storage"
  url "https://github.com/mgilangjanuar/free-storage/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "392aaedd6bd16d5572428ab0f5132f4fc09e29c1a190719575e975a07c1f3d24"
  license "MIT"

  depends_on :macos

  def install
    bin.install "bin/free-storage"
  end

  test do
    assert_match "free-storage #{version}", shell_output("#{bin}/free-storage --version")
    assert_match "refusing to scan", shell_output("#{bin}/free-storage --root / 2>&1", 2)
  end
end
