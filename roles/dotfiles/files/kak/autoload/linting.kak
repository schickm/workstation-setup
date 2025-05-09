# available vars for running linting
#
# kak_buffile     - origional name of file that had the code to be linted
#
# The best way to deal with setting this is to use direnv
#
# Examples for future implementations
#
# Prereq:
#   npm install -g eslint-formatter-kakoune
#
# Kakoune puts the text in a temp file, but eslint needs the original file in order to understand how
# to apply lint rules.  So this function uses eslint's stdin method instead so it can specify the
# filename 
# 	run() { cat "$1" | npx --quiet eslint --format=$(npm root -g)/eslint-formatter-kakoune --stdin-filename ${kak_buffile} --stdin; } && run

# working on getting the logic below to live in it's own hook.
hook -once global WinSetOption filetype=(javascript|typescript) %{ evaluate-commands %sh{

    # lintcmd='cat ${lint_file_in} | npx --quiet eslint --config .eslintrc.yml --format=$(npm root -g)/eslint-formatter-kakoune --stdin-filename ${kak_buffile} --output-file ${lint_file_out} --stdin || true'
    if [ "$kak_javascript_lintcmd" ]; then
        lintcmd="$kak_javascript_lintcmd"
        printf "
        echo -debug 'got lint cmd $lintcmd'
    		enable-lint '$lintcmd' javascript-lint-hooks

            hook global WinSetOption filetype=(javascript|typescript) %%{
				enable-lint '$lintcmd' javascript-lint-hooks
                hook -once -always window WinSetOption filetype=.* %%{ remove-hooks window javascript-lint-hooks }
            }
        "
    fi
} }

hook global WinSetOption filetype=yaml %{
	set-option window lintcmd %{
		run() {
			yamllint -f parsable "$1" | sed 's/ \[\(.*\)\] / \1: /'
		} && run }

    hook window BufWritePost .* lint
}

hook global WinSetOption filetype=sh %{
	enable-lint-on-change sh-lint-hooks
}
