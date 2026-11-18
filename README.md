# GraphicsMagick Compatibility Receipt

This tiny pack renders a valid 1×1 PPM and writes a reproducibility receipt for
the GraphicsMagick runtime used by the release builder.

## Install

```sh
make install
```

The result is written below `output/`:

- `compatibility.txt` records package versions, resolved binary paths,
  SHA-256 digests, and ELF Build IDs.
- `sample.png` is the rendered 1×1 compatibility sample.

The install performs no network access and does not read user files.
