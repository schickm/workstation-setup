
declare-option -docstring 'Url where Git repo can be viewed online' \
	str gitremoteurl

hook global BufOpenFile .* %{
	evaluate-commands %sh{
	    status=$(git status --branch --porcelain=v2)

	    # first figure out the origin branch's remote
	    upstream=$(echo "$status" | grep -m 1 "^# branch.upstream " | cut -d " " -f 3)
	    remote_name=$(echo "$upstream" | cut -d '/' -f 1)
	    remote_branch=$(echo "$upstream" | cut -d '/' -f 2-)
	    remote=$(git remote get-url "$remote_name")

		printf 'echo -debug upstream %s\n' "$upstream"
		printf 'echo -debug remote_name %s\n' "$remote_name"
		printf 'echo -debug remote_branch %s\n' "$remote_branch"
		printf 'echo -debug remote %s\n' "$remote"

	    case "$remote" in
	      git@gitlab.com*)
	        repo_url=$(echo "$remote" | sed 's|^git@gitlab.com:|https://gitlab.com/|; s|\.git$||')
	        printf 'echo -debug repo_url %s\n' "$repo_url"
			printf 'setup-gitlab-mode %s %s' "$repo_url" "$remote_branch"
		    ;;
	      *)
	      	printf 'echo "%s not supported remote"' "$remote"
	      	;;
	    esac
	}
}

declare-user-mode gitlab

define-command setup-gitlab-mode \
	-override \
	-docstring 'setup-gitlab-mode <repo url> <remote branch name>' \
	-params 2 %{

	map buffer git g ': enter-user-mode gitlab<ret>' -docstring 'Gitlab related commands'

    # The way to do multiline is like:
    #  $kak_selection_desc | sed -e 's/,/-/' -e 's/\.[0-9]//g'
	#  But the single line below would have to be converted to a function
	map buffer gitlab b ": open-url-in-safari ""%arg{1}/-/tree/%arg{2}?ref_type=heads""<ret>" \
		-docstring 'Open this branch'
    map buffer gitlab u ": nop %%sh{ echo ""%arg{1}/-/blob/%arg{2}/${kak_bufname}#L${kak_cursor_line}"" | pbcopy }<ret>" \
    	-docstring 'Copy file+line url to clipboard'

    map buffer gitlab p ": open-url-in-safari ""%arg{1}/-/pipelines""<ret>" \
    	-docstring 'Pipelines'
    map buffer gitlab m ": async-command ""glab mr view -w $(git branch --show-current)""<ret>" \
    	-docstring 'Open this merge request'
    map buffer gitlab M ": open-url-in-safari ""%arg{1}/-/merge_requests""<ret>" \
    	-docstring 'Merge Requests'
}
