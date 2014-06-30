# rails-navigation

This package provides commands to navigate through rails files while keeping some context - for example, when you keep your cursor in an action method on the cursor and navigates to the view, the correct view file should be open. Same for tests
It is inspired on the great [vim-rails](https://github.com/tpope/vim-rails).

## What it does:
* Go to model
* Go to controller
* Go to helper
* Go to migration (the one that creates the record)
* Go to view file
* Go to test (rspec or test::unit)

## What it will do:

* Go to factory
* Go to partial
* Mailer support
* Open in the same tab option

## Keymaps

There is no keybinding defined for using without the [vim-mode](https://github.com/atom/vim-mode) package - please feel free to suggest.

On vim command mode, the keybindings are `g X`, where `X` is:

* `m` for model
* `c` for controller
* `v` for view
* `h` for helper
* `s` for test (spec - `g t` is already used on vim-mode)

## Bugs and contributions

are welcome. Thanks!

## Alternatives

* [atom-rails](https://github.com/tomkadwill/atom-rails): Aims to be a replacement for [vim-rails](https://github.com/tomkadwill/atom-rails), but currently support only navigational features.
* [rails-transporter](https://github.com/hmatsuda/rails-transporter): A cool alternative using finder to complete views instead of open the current context.
