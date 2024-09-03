function fish_right_prompt --description 'Write out the right-aligned prompt'
  set -l last_status $pipestatus
  set -l status_color brblack
  if test $last_status -ne 0
    set status_color red
  end

  echo -n -s \
    (set_color brblack) (string trim $VIRTUAL_ENV_PROMPT) \
    (set_color brblack) (fish_vcs_prompt) \
    (set_color $status_color) " $(date +%H:%M:%S)"
end
