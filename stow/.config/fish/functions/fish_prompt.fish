function fish_prompt --description "Write out the prompt"
  set -l color_host $fish_color_host
  if set -q SSH_CLIENT
    set color_host $fish_color_host_remote
  end

  set -l color_cwd $fish_color_cwd
  if functions -q fish_is_root_user; and fish_is_root_user
    set color_cwd $fish_color_cwd_root
  end

  echo -n -s \
    (set_color $color_host) $USER \
    (set_color brblack) " @ " \
    (set_color $color_cwd) (prompt_pwd) \
    (set_color brblack) " $prompt_suffix "
end
