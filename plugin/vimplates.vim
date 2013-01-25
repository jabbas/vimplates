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

if !exists('g:vimplates_templates_dir')
    let g:vimplates_templates_dir = expand("<sfile>:p:h:h") . '/templates/'
endif

function! vimplates#Load()
python << EOF
import vim
from mako.lookup import TemplateLookup

filetype = vim.eval("&filetype")
template_dir = vim.eval('g:vimplates_templates_dir')

class variables(object):
    filetype    = filetype
    filename    = vim.current.buffer.name
    cwd         = vim.eval("getcwd()")

lookup = TemplateLookup(directories=[template_dir])
template = lookup.get_template(filetype)
contents = template.render(
                vim = vim,
                vars = variables,
                username    = vim.eval('g:vimplates_username'),
                email       = vim.eval('g:vimplates_email'),
                website     = vim.eval('g:vimplates_website'),
            )

# vim.current.buffer.append have problems with utf-8
vim.command("call append(line('0'), split('%s', '\n'))" % contents)
EOF
endfunction

"call LoadTemplate()
autocmd BufNewFile * call vimplates#Load()
