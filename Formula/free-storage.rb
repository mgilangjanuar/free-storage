class FreeStorage < Formula
  desc "Free regenerable disk space: build outputs, package and app caches, logs"
  homepage "https://github.com/mgilangjanuar/free-storage"
  url "https://github.com/mgilangjanuar/free-storage/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9972340693b978730ec8780509a5603d62ed8bcf4fec7575fe752ab165cd4b60"
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
