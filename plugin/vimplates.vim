if !has('python')
    echo "Error: vim needs to be compiled with +python to run vimplates"
    finish
endif

if !exists('g:vimplates_templates_dir')
    let g:vimplates_templates_dirs = []
endif

let g:vimplates_default_dir = expand("<sfile>:p:h:h") . '/templates/'

function! vimplates#set_position()
    " TODO kinda ugly
    /VIMPLATES_CURSOR_POSITION
    s/VIMPLATES_CURSOR_POSITION//
endfunction

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
def vim_setvar(name, value):
    command = "if !exists('g:vimplates_%(name)s') |let g:vimplates_%(name)s = '%(val)s' |endif"
    vim.command(command % {'name': name, 'val': value})
def vim_getvar(name):
    return vim.eval("g:vimplates_%s" % name)

# Set default variables
for varname, varvalue in default_vars.iteritems():
    vim_setvar(varname, varvalue)

#####

filetype = vim.eval("&filetype")

class variables(object):
    filetype    = filetype
    filename    = vim.current.buffer.name
    cwd         = vim.eval("getcwd()")

template_dirs = [vim_getvar('default_dir')]
template_dirs.extend(vim_getvar('templates_dirs'))
template_dirs = list(set(template_dirs))
lookup = TemplateLookup(directories=template_dirs)

try:
    template = lookup.get_template(filetype)
    contents = template.render(
                    vim         = vim,
                    cursor      = 'VIMPLATES_CURSOR_POSITION',
                    vars        = variables,
                    username    = vim_getvar('username'),
                    email       = vim_getvar('email'),
                    website     = vim_getvar('website'),
                )
except TopLevelLookupException:
    contents = str()
    print "WARNING: Template for filetype '%s' not found in (%s)" % (filetype, ", ".join(template_dirs))

# vim.current.buffer.append have problems with utf-8
vim.command("call append(line('0'), split('%s', '\n'))" % contents)
EOF
    call vimplates#set_position()
endfunction

autocmd BufNewFile * call vimplates#Load()
