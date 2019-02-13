# vim-halo

Highlight the cursor by putting blinking shapes around it.

By default it puts a halo around the cursor and blinks three times. This can be
used to quickly find the cursor after switching buffers etc. Moving the cursor
will stop the blinking immediately.

## Usage

There is only one function `halo#run()`, which takes one optional argument, a
dictionary.

The dictionary takes up to 3 keys:

- **hlgroup**: Highlight group as *string*. Default is `Halo` which is provided
  by the plugin itself.
- **shape**: Shape as a *string*. Can by any of `halo1`, `halo2`, `cross1`,
  `cross2`, `cross2halo1`, `rectangle2`, or `line`. Default is `halo1`.
- **intervals**: A *list of numbers*. Calling `halo#run()` immediately shows a
  visual highlight. The numbers denote the alternating times visual highlights
  are shown and hidden. Thus an odd number of elements is sensible. Given an
  even number, the last element is ignored. Default is `[100,100,100,100,100]`.

```
:call halo#run()
:call halo#run({'shape': 'cross2halo1'})
:call halo#run({'intervals': [100, 300, 600, 300, 100]})
:call halo#run({'intervals': [200,200,200], 'hlgroup': 'IncSearch'})
```

## Examples

Every time you change buffers:

```vim
autocmd BufEnter * call halo#run()
```

When navigating the quickfix or location list:

```vim
nnoremap [q  :cprevious \| call halo#run()<cr>
nnoremap ]q  :cnext \| call halo#run()<cr>
nnoremap [Q  :cfirst \| call halo#run()<cr>
nnoremap ]Q  :clast \| call halo#run()<cr>

nnoremap [l  :lprevious \| call halo#run()<cr>
nnoremap ]l  :lnext \| call halo#run()<cr>
nnoremap [L  :lfirst \| call halo#run()<cr>
nnoremap ]L  :llast \| call halo#run()<cr>
```

## Disclaimer

Only the `line` shape works works with wrapped lines!
