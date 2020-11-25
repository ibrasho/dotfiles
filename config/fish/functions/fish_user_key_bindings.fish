function fish_user_key_bindings
  bind \e\e 'thefuck-command-line'

  if functions -q _maybe-add-bundle-exec-and-execute
    bind \r _maybe-add-bundle-exec-and-execute
  end
end
