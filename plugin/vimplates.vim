if !has('python')
    echo "Error: vim needs to be compiled with +python to run vimplates"
    finish
endif
let s:vimhome = expand("<sfile>:p:h:h")

if !exists('g:vimplates_username')
    let g:vimplates_username = 'John Doe'
endif

if !exists('g:vimplates_email')
    let g:vimplates_email = 'john.doe@nothing.com'
endif

"TODO cursor position
"TODO loadable per file
"TODO configurable templates dir

function! vimplates#Load()
python << EOF
import vim
from mako.lookup import TemplateLookup

filetype = vim.eval("&filetype")
template_dir = "%s/templates/" % vim.eval('s:vimhome')

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
            )

# vim.current.buffer.append have problems with utf-8
vim.command("call append(line('0'), split('%s', '\n'))" % contents)
EOF
endfunction

"call LoadTemplate()
autocmd BufNewFile * call vimplates#Load()
