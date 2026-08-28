# raeq/homebrew-tap

Homebrew formulae for tools that are not in homebrew-core.

```bash
brew install raeq/tap/ibook2epub
```

## ibook2epub

Converts Apple Books `*.epub/` package directories into spec-valid zipped
`.epub` files. Zero runtime dependencies, Python 3.10 or newer, MIT.

- Source: <https://github.com/raeq/ibook2epub>
- PyPI: <https://pypi.org/project/ibook2epub/>

## Updating a formula

Each release needs a new `url` and `sha256`. The `ibook2epub` release workflow
opens a pull request here after a successful upload to PyPI, so the formula
does not quietly fall a version behind.

To do it by hand:

```bash
VERSION=2.0.5
URL=$(curl -s "https://pypi.org/pypi/ibook2epub/$VERSION/json" \
      | python3 -c "import json,sys; print(next(u['url'] for u in json.load(sys.stdin)['urls'] if u['packagetype']=='sdist'))")
SHA=$(curl -s "https://pypi.org/pypi/ibook2epub/$VERSION/json" \
      | python3 -c "import json,sys; print(next(u['digests']['sha256'] for u in json.load(sys.stdin)['urls'] if u['packagetype']=='sdist'))")
```

Then check it the way Homebrew's own CI does, before pushing:

```bash
brew audit --new --formula raeq/tap/ibook2epub
brew install --build-from-source raeq/tap/ibook2epub
brew test raeq/tap/ibook2epub
```
