# vimplates.vim

vim file templates (aka skeletons) using [Mako](http://www.makotemplates.org/) template engine

## Installation

Install to `~/.vim/plugins/` or if using [pathogen](https://github.com/tpope/vim-pathogen)

    git clone https://github.com/jabbas/vimplates bundle/vimplates

## Configuration

Default templates directory is `.vim/templates` or (if you use pathogen) `.vim/bundle/vimplates/templates` you can change it by adding this line to your `.vimrc`:

    let g:vimplates_templates_dirs = ['/path/to/templates', '/another/path/to/templates']

You can configure some special variables which will be used in templates:

- `g:vimplates_username` (default: `"John Doe"`),
- `g:vimplates_email` (default: `"john.doe@nothing.com"`),
- `g:vimplates_website` (default: `"http://nothing.com"`),
- `g:vimplates_license` (default: `"GPL-3"`)

## Templates

By default vimplates uses filetype set by vim as a name of the template, so for python it uses `python`, for perl `perl` etc...

### Special variables

There are some special variables you can use in the templates:

- `username` will put contents of `g:vimplates_username`,
- `email` will put contents of `g:vimplates_email`,
- `website` will put contents of `g:vimplates_website`,
- `vars` is an container for:
    - `vars.filename` - filename of the file you opened in current vim buffer,
    - `vars.filetype` - file type set by vim,
    - `vars.cwd` - current working directory,
    - ... and will be more in the future
- `vim` a reference to vim module (see `:help python-vim` or [vimdoc.sf.net](http://vimdoc.sourceforge.net/htmldoc/if_pyth.html#python-vim))

### How to write your own templates?

Basically, Mako uses python inside templates. See [Mako Documentation](http://docs.makotemplates.org/en/latest/) and/or `templates` directory for examples.

## TODO list

- improve cursor position (it's ugly and does not work in some cases)
- loadable per file,
- moar templates/examples
