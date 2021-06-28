class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.3.2.tar.xz"
  sha256 "46e4e64f1dd0233cbc0934b9f1c0da676008cad34725113fb7f802cfa84ccddb"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/FFmpeg/FFmpeg.git"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://kobiton-devvn.s3-ap-southeast-1.amazonaws.com/downloads/ffmpeg/4.3.2_4"
    sha256 arm64_big_sur: "549f899dadc339af7069355aa3a34591f536843efc431b2541693bc806ca5048"
    sha256 big_sur:       "5275547e1b3dba43749ce3d91ddd92120ccc6d5f98090dd01dba2a2e615d8166"
    sha256 catalina:      "5584b6d04f9d24a3bae17c6ebd640a7023e063b5c879b9a1cfb584dc51e6a527"
    sha256 mojave:        "39af46559faf9aeb3aefa10c60aefd1563815518fdab86a1fa44ec11e886da1a"
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "kobiton/core/aom"
  depends_on "kobiton/core/dav1d"
  depends_on "kobiton/core/fontconfig"
  depends_on "kobiton/core/freetype"
  depends_on "kobiton/core/frei0r"
  depends_on "kobiton/core/gnutls"
  depends_on "kobiton/core/lame"
  depends_on "kobiton/core/libass"
  depends_on "kobiton/core/libbluray"
  depends_on "kobiton/core/libsoxr"
  depends_on "kobiton/core/libvidstab"
  depends_on "kobiton/core/libvorbis"
  depends_on "kobiton/core/libvpx"
  depends_on "kobiton/core/opencore-amr"
  depends_on "kobiton/core/openjpeg"
  depends_on "kobiton/core/opus"
  depends_on "kobiton/core/rav1e"
  depends_on "kobiton/core/rubberband"
  depends_on "kobiton/core/sdl2"
  depends_on "kobiton/core/snappy"
  depends_on "kobiton/core/speex"
  depends_on "kobiton/core/srt"
  depends_on "kobiton/core/tesseract"
  depends_on "kobiton/core/theora"
  depends_on "kobiton/core/webp"
  depends_on "kobiton/core/x264"
  depends_on "kobiton/core/x265"
  depends_on "kobiton/core/xvid"
  depends_on "kobiton/core/xz"
  depends_on "kobiton/core/zeromq"
  depends_on "kobiton/core/zimg"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxv"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-libdav1d
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libtesseract
      --enable-libtheora
      --enable-libvidstab
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-libspeex
      --enable-libsoxr
      --enable-libzmq
      --enable-libzimg
      --disable-libjack
      --disable-indev=jack
    ]

    on_macos do
      # Needs corefoundation, coremedia, corevideo
      args << "--enable-videotoolbox"
    end

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
