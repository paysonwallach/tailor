project('com.paysonwallach.tailor', 'vala', 'c')

add_global_arguments('-DWNCK_I_KNOW_THIS_IS_UNSTABLE', language: 'c')

executable(
  meson.project_name (),
  'src/Main.vala',
  dependencies: [
    dependency('gdk-3.0'),
    dependency('gee-0.8'),
    dependency('libwnck-3.0')
  ],
  install: true
)

meson.add_install_script('meson/post_install.py')

subdir('data')
