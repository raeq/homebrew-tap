class Ibook2epub < Formula
  include Language::Python::Virtualenv

  desc "Convert Apple Books epub package directories into spec-valid epub files"
  homepage "https://github.com/raeq/ibook2epub"
  url "https://files.pythonhosted.org/packages/33/0e/c45de97584b46bf59bd16d728b58f2873697525c3fa0aff0daa63c7a71a6/ibook2epub-2.2.0.tar.gz"
  sha256 "a3c050d1b007ce9c8989a794c9f37a4974231e45d158329200b86914c9cb9fc4"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ibook2epub --version")

    # A source directory that is not there has its own exit code, which is the
    # contract a scheduled run reads. 4 is NO_SOURCE.
    output = shell_output("#{bin}/ibook2epub -s #{testpath}/absent -o #{testpath}/out -q", 4)
    assert_empty output

    # An end-to-end conversion: an unpacked package directory in, a zipped epub
    # out, recognised as a real book on the way through.
    package = testpath/"lib/Book.epub"
    (package/"META-INF").mkpath
    (package/"OEBPS").mkpath
    (package/"mimetype").write "application/epub+zip"
    (package/"META-INF/container.xml").write <<~XML
      <container xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
        <rootfiles><rootfile full-path="OEBPS/content.opf"/></rootfiles>
      </container>
    XML
    (package/"OEBPS/content.opf").write <<~XML
      <package xmlns="http://www.idpf.org/2007/opf" version="3.0">
        <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
          <dc:title>A Wizard of Earthsea</dc:title>
        </metadata>
        <manifest>
          <item id="t" href="text.xhtml" media-type="application/xhtml+xml"/>
        </manifest>
        <spine><itemref idref="t"/></spine>
      </package>
    XML
    (package/"OEBPS/text.xhtml").write "<html><body>Ged</body></html>"

    system bin/"ibook2epub", "-s", testpath/"lib", "-o", testpath/"out", "-m", "0", "-q"
    assert_path_exists testpath/"out/Book.epub"

    # And the archive it wrote passes its own verifier.
    system bin/"ibook2epub", "-o", testpath/"out", "--verify", "-q"
  end
end
