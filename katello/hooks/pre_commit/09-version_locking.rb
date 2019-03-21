# evaluate version locking settings
cli_param = app_value(:lock_package_versions)
custom_config_value = get_custom_config(:lock_package_versions)
lock_versions = cli_param.nil? ? !!custom_config_value : cli_param

if lock_versions != custom_config_value
  store_custom_config(:lock_package_versions, lock_versions)
  kafo.config.configure_application
end

# unlock packages if locked
`command -v foreman-maintain`
if $?.success?
  `foreman-maintain installation is-locked --assumeyes`
  if $?.exitstatus == 1
    Kafo::Helpers.log_and_say :info, "Package versionss are locked. Continuing with unlock."
    Kafo::Helpers.execute('foreman-maintain installation unlock --assumeyes')
  end
end
nil
