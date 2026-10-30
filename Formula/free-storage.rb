class FreeStorage < Formula
  desc "Free regenerable disk space: build outputs, package and app caches, logs"
  homepage "https://github.com/mgilangjanuar/free-storage"
  url "https://github.com/mgilangjanuar/free-storage/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "188b2d0838de23863d048bab50d96575dccbb9bcfa432441fd5893d969254954"
  license "MIT"

  def install
    bin.install "bin/free-storage"
  end

  test do
    assert_match "free-storage #{version}", shell_output("#{bin}/free-storage --version")
    assert_match "refusing to scan", shell_output("#{bin}/free-storage --root / 2>&1", 2)
  end
end
