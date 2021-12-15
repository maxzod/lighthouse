## 0.0.5-beta.2

- enhancements 🎁 ::
  - `lh assets:make`
    - skips hidden files (#11) (@mo-ah-dawood)
  - `lh tr:make`
    - performance improvements (remove unnecessary loops)
    - adds nations default values to the `Tr` class (#8)
    - validates all errors then report all failures not just first one
    - will validates nested objects (#10)
    - update nations assets to `0.0.3`
    - more tests
- NEW 🔥::
  - `lh assets:add` to add assets to `pubspec.yaml`
  - `lh tr:validate` to validate the assets without generating the `Tr` class
