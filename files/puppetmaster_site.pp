# Gets rid of
#  Warning: The package type's allow_virtual parameter will be changing its default value from false to true in a future release. If you do not want to allow virtual packages, please explicitly set allow_virtual to false.
#   (at /usr/lib/ruby/site_ruby/1.8/puppet/type.rb:816:in `set_default')

Package{
  allow_virtual => true,
}

stage { 'last': }
Stage['main'] -> Stage['last']

hiera_include('classes')
