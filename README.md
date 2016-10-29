# vim-halo

Make the current line blink in a given interval using timers.

Works with Neovim and Vim with the `+timers` feature compiled in. Neovim.

## To be done

- [ ] Add more shapes

## Usage

```
:call halo#run()
:call halo#run({'hlgroup': 'IncSearch'})
:call halo#run({'intervals': [100, 300, 600, 300, 100]})
:call halo#run({'intervals': [100, 300, 600, 300, 100], 'hlgroup': 'IncSearch'})
```

It provides **dynamically created headers or footers** and uses configurable
lists to show **recently used or bookmarked files** and **persistent sessions**.
All of this can be accessed in a **simple to use menu** that even allows to
**open multiple entries** at once.

Startify doesn't get in your way and works out-of-the-box, but provides many
options for fine-grained customization.

---

- [Installation & Documentation](#installation-and-documentation)
- [Plugin features in detail](https://github.com/mhinz/vim-startify/wiki/Plugin-features-in-detail)
- [Screenshot](#screenshot)
- [Author & Feedback](#author-and-feedback)

---

## Installation and Documentation

Use your favorite plugin manager.

Using [vim-plug](https://github.com/junegunn/vim-plug):

    Plug 'mhinz/vim-startify'

It works without any configuration, but you might want to look into the
documentation for further customization:

    :h startify
    :h startify-faq

## Screenshot

![Startify in action!](https://github.com/mhinz/vim-startify/blob/master/pictures/startify-menu.png)
That's it. A fancy start screen for Vim.  _(almost all visible features enabled - freely customizable)_

## Author and Feedback

If you like my plugins, please star them on Github. It's a great way of getting
feedback. Same goes for issues reports or feature requests.

Contact: [Twitter](https://twitter.com/_mhinz_)

_Get your Vim on!_
