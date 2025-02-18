# Build up elaborate process of getting the actual url and remote branch name
declare-option -hidden str git_upstream_cmd \
	"git status --branch --porcelain=v2 | grep -m 1 '^# branch.upstream ' | cut -d ' ' -f 3"
declare-option -hidden str git_remote_name_cmd \
	"%opt{git_upstream_cmd} | cut -d '/' -f 1"
declare-option -hidden str git_remote_branch_cmd \
	"%opt{git_upstream_cmd} | cut -d '/' -f 2"
declare-option -hidden str git_remote_url_cmd \
	"NAME=$(%opt{git_remote_name_cmd}) && git remote get-url $NAME | sed 's|^git@github.com:|https://github.com/|; s|\.git$||'"

hook global BufOpenFile .* %{
	evaluate-commands %sh{
	    # first figure out the origin branch's remote
	    # TODO - update calls below to use commands declared in options in file above
	    remote_name=$(eval "$kak_opt_git_remote_name_cmd")
	    remote=$(git remote get-url "$remote_name")


	    case "$remote" in
	      git@github.com*)
			printf 'echo -debug remote_name %s\n' "$remote_name"
			printf 'echo -debug remote %s\n' "$remote"

			printf 'setup-github-mode'
		    ;;
	      *)
	      	printf 'echo "%s not supported remote"' "$remote"
	      	;;
	    esac
	}
}


define-command github-blame-url-for-selection \
	-params 1 \
	-docstring "github-blame-url-for-selection <open|copy>" \
	-override \
	%{
	nop %sh{
		repo_url=$(eval "$kak_opt_git_remote_url_cmd")
		branch=$(eval "$kak_opt_git_remote_branch_cmd")
		lines=$(echo "$kak_selection_desc" | sed -e 's/\([0-9]*\)\.[0-9]*/L\1/g' -e 's/,/-/')
		url="$repo_url/blob/$branch/$kak_bufname#$lines"

		case $1 in
			open)
				open "$url"
				;;
			copy)
				echo "$url" | pbcopy
				;;
			*)
				echo "Invalid option"
				exit 1
				;;
		esac
	 } 
}

# Wrapped in try so that entire file can be re-sourced without throwing an error
# due to there already being a usermode named github
try %{ declare-user-mode github } 
 
define-command setup-github-mode \
	-override \
	-docstring 'setup-github-mode <repo url> <remote branch name>' %{

	map buffer git g ': enter-user-mode github<ret>' -docstring 'Github related commands'

    map buffer github p ": async-command ""gh pr view -w""<ret>" \
    	-docstring 'Open this pull request'
    map buffer github u ": github-blame-url-for-selection copy<ret>" \
    	-docstring 'Copy file+line url to clipboard'
    map buffer github U ": github-blame-url-for-selection open<ret>" \
    	-docstring 'Open file in browser on Github'
}

