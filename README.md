<div align="center">
  <h1>Tailor</h1>
  <br>
  <p>Set Gtk theme variants per window class.</p>
  <a href=https://github.com/paysonwallach/tailor/release/latest>
    <img src=https://img.shields.io/github/v/release/paysonwallach/tailor?style=flat-square>
  </a>
  <a href=https://github.com/paysonwallach/tailor/blob/master/LICENSE>
    <img src=https://img.shields.io/github/license/paysonwallach/tailor?style=flat-square>
  </a>
  <a href=https://buymeacoffee.com/paysonwallach>
    <img src=https://img.shields.io/badge/donate-Buy%20me%20a%20coffe-yellow?style=flat-square>
  </a>
  <br>
  <br>
</div>

[Tailor](https://github.com/paysonwallach/tailor) is a small service that lets you set Gtk theme variants on windows by their Xorg `WM_CLASS` properties.

## Installation

### From source using [`meson`](http://mesonbuild.com/)

Clone this repository or download the [latest release](https://github.com/paysonwallach/tailor/releases/latest).

```sh
git clone https://github.com/paysonwallach/tailor.git
```

Configure the build directory at the root of the project.

```sh
meson --prefix=/usr build
```

Install with `ninja`.

```sh
ninja -C build install
```

You'll probably want to set [Tailor](https://github.com/paysonwallach/tailor) to launch on login as well.

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## Code of Conduct

By participating in this project, you agree to abide by the terms of the [Code of Conduct](https://github.com/paysonwallach/tailor/blob/master/CODE_OF_CONDUCT.md).

## License

[Tailor](https://github.com/paysonwallach/tailor) is licensed under the [GNU Public License v3.0](https://github.com/paysonwallach/tailor/blob/master/LICENSE).
