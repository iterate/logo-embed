use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set cookie: :"$CM[FBr09|)7z_g$pOxEN}T}*y(b8}V)jee.vJQezhNo4KN}g2?=jWM:E_qexjO?"
end

environment :prod do
  set cookie: :"$CM[FBr09|)7z_g$pOxEN}T}*y(b8}V)jee.vJQezhNo4KN}g2?=jWM:E_qexjO?"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :hello_network do
  set version: current_version(:hello_network)
  plugin Shoehorn
  plugin Nerves
end
