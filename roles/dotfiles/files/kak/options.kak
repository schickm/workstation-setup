#
# These options are used by commands in github.kak and jenkins.kak
# 
# They build up elaborate process of getting the actual url and remote branch name
# 

declare-option -hidden str git_upstream_cmd \
	"git status --branch --porcelain=v2 | grep -m 1 '^# branch.upstream ' | cut -d ' ' -f 3"
declare-option -hidden str git_remote_name_cmd \
	"%opt{git_upstream_cmd} | cut -d '/' -f 1"
declare-option -hidden str git_remote_branch_cmd \
	"%opt{git_upstream_cmd} | cut -d '/' -f 2"
declare-option -hidden str git_remote_url_cmd \
	"NAME=$(%opt{git_remote_name_cmd}) && git remote get-url $NAME | sed 's|^git@github.com:|https://github.com/|; s|\.git$||'"
