if !has('python')
    echo "Error: vim needs to be compiled with +python to run vimplates"
    finish
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

# Defaults
default_vars = {
    'username': 'John Doe',
    'email':    'john.doe@nothing.com',
    'website':  'http://nothing.com',
    'license':  'GPL-3'
}

# Helper functions
def set_vimvar(name, value):
    command = "if !exists('g:vimplates_%(name)s') |let g:vimplates_%(name)s = '%(val)s' |endif"
    vim.command(command % {'name': name, 'val': value})
def get_vimvar(name):
    return vim.eval("g:vimplates_%s" % name)

# Set default variables
for varname, varvalue in default_vars.iteritems():
    set_vimvar(varname, varvalue)

#####

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
                    username    = get_vimvar('username'),
                    email       = get_vimvar('email'),
                    website     = get_vimvar('website'),
                )
except TopLevelLookupException:
    contents = str()
    print "WARNING: Template for filetype '%s' not found in (%s)" % (filetype, ", ".join(template_dirs))

# vim.current.buffer.append have problems with utf-8
vim.command("call append(line('0'), split('%s', '\n'))" % contents)
EOF
endfunction

autocmd BufNewFile * call vimplates#Load()
