# config/initializers/rghost_patch.rb
unless defined?(PLATFORM)
  PLATFORM = RUBY_PLATFORM
end

unless defined?(RGhost::VERSION)
  module RGhost
    module VERSION
      STRING = '0.9.6'
    end
  end
end