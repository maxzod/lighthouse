# 0.0.7

- enhancements 💡 ::
  - `lh assets:make`
    - skips hidden files (#11) (@mo-ah-dawood)
  - `lh tr:make`
    - performance improvements (remove unnecessary loops)
    - add nations default values to the `Tr` class (#8)
    - validates all errors then report all failures not just first one
    - will validates nested objects (#10)
    - update nations assets to `0.0.4`
    - more tests , converge up to `45%`
- NEW 🎁::
  - `lh assets:add` to add assets to `pubspec.yaml`
  - `lh tr:validate` to validate the assets without generating the `Tr` class
