class FreeStorage < Formula
  desc "Free regenerable disk space: build outputs, package and app caches, logs"
  homepage "https://github.com/mgilangjanuar/free-storage"
  url "https://github.com/mgilangjanuar/free-storage/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "45944881f66eacbbb4db87715e20d1f8569af5fcdd8b8faf735f8a4f5683ce68"
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
