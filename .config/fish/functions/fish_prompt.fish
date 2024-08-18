function fish_prompt
  set -l color_host $fish_color_host
  if set -q SSH_CLIENT
    set color_host $fish_color_host_remote
  end

  set -l color_cwd $fish_color_cwd
  set -l prefix
  set -l suffix '>'
  if contains -- $USER root toor
    if set -q fish_color_cwd_root
      set color_cwd $fish_color_cwd_root
    end
    set suffix '#'
  end

  printf '%s%s%s @ %s%s%s %s ' \
    (set_color $color_host) $USER (set_color brblack) \
    (set_color $color_cwd) (prompt_pwd) (set_color brblack) \
    $suffix
end
