if !has('python')
    echo "Error: vim needs to be compiled with +python to run vimplates"
    finish
endif
let s:vimhome = expand("<sfile>:p:h:h")

function! vimplates#Load()
python << EOF
import vim
from mako.lookup import TemplateLookup

filetype = vim.eval("&filetype")
template_dir = "%s/templates/" % vim.eval('s:vimhome')

lookup = TemplateLookup(directories=[template_dir])
template = lookup.get_template(filetype)
contents = template.render(author="Jabbas")

# vim.current.buffer.append have problems with utf-8
vim.command("call append(line('0'), split('%s', '\n'))" % contents)
EOF
endfunction

"call LoadTemplate()
autocmd BufNewFile * call vimplates#Load()
