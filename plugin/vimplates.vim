if !has('python')
    echo "Error: vim needs to be compiled with +python to run vimplates"
    finish
endif

if !exists('g:vimplates_username')
    let g:vimplates_username = 'John Doe'
endif

if !exists('g:vimplates_email')
    let g:vimplates_email = 'john.doe@nothing.com'
endif

if !exists('g:vimplates_website')
    let g:vimplates_website = 'http://nothing.com'
endif

if !exists('g:vimplates_license')
    let g:vimplates_license = 'GPL-3'
endif

if !exists('g:vimplates_templates_dir')
    let g:vimplates_templates_dirs = []
endif

let g:vimplates_default_dir = expand("<sfile>:p:h:h") . '/templates/'
function! vimplates#Load()

python << EOF
import vim
from mako.lookup import TemplateLookup
from mako.exceptions import TopLevelLookupException

filetype = vim.eval("&filetype")

class variables(object):
    filetype    = filetype
    filename    = vim.current.buffer.name
    cwd         = vim.eval("getcwd()")

template_dirs = [vim.eval('g:vimplates_default_dir')]
template_dirs.extend(vim.eval('g:vimplates_templates_dirs'))
template_dirs = list(set(template_dirs))
lookup = TemplateLookup(directories=template_dirs)

try:
    template = lookup.get_template(filetype)
    contents = template.render(
                    vim         = vim,
                    vars        = variables,
                    username    = vim.eval('g:vimplates_username'),
                    email       = vim.eval('g:vimplates_email'),
                    website     = vim.eval('g:vimplates_website'),
                )
except TopLevelLookupException:
    contents = str()
    print "WARNING: Template for filetype '%s' not found in (%s)" % (filetype, ", ".join(template_dirs))

# vim.current.buffer.append have problems with utf-8
vim.command("call append(line('0'), split('%s', '\n'))" % contents)
EOF
endfunction

autocmd BufNewFile * call vimplates#Load()
