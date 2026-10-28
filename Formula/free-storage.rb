class FreeStorage < Formula
  desc "Free regenerable disk space: build outputs, package and app caches, logs"
  homepage "https://github.com/mgilangjanuar/free-storage"
  url "https://github.com/mgilangjanuar/free-storage/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "123ab72b5bb83602a5f5b46a808c0ecded8ce982ba98aebf44b181e3657a9ccc"
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
