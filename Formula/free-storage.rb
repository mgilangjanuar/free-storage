class FreeStorage < Formula
  desc "Free regenerable disk space: build outputs, package caches, stale git worktrees"
  homepage "https://github.com/mgilangjanuar/free-storage"
  url "https://github.com/mgilangjanuar/free-storage/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0bfda9488a6b99dc8bcfdb96d8b3c613ccb4dcc2dfdee0e36e4f86ade245e6b9"
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
