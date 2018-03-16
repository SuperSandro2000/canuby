
task default: :thirdparty

ENV['vcvars'] ||= '"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"'

desc 'Prepare 3rdparty dependencies'
task thirdparty: 'thirdparty:googletest'

namespace :thirdparty do
  def base_dir
    '3rdparty'
  end

  def stage_dir
    File.join(base_dir, 'lib')
  end

  task :init do
    mkdir_p base_dir unless Dir.exist?(base_dir)
  end

  desc 'Prepare googletest'
  task googletest: 'googletest:staged'

  namespace :googletest do
    def project_dir
      File.join(base_dir, 'googletest')
    end

    def outputs
      ['gtest.lib', 'gtest_main.lib']
    end

    def build_outputs
      output_dir = File.join(project_dir, 'build', 'googlemock', 'gtest', 'RelWithDebInfo')
      outputs.collect { |f| File.join(output_dir, f) }
    end

    def stage_outputs
      outputs.collect { |f| File.join(stage_dir, f) }
    end

    def clean_stage
      stage_outputs.each { |f| rm f if File.exist?(f) }
    end

    def do_clone
      puts 'Cloning googletest...'
      sh 'git clone https://github.com/google/googletest.git #{project_dir}'
    end

    def do_build
      puts 'Building googletest...'
      clean_stage
      build_dir = File.join(project_dir, 'build')
      mkdir_p build_dir
      Dir.chdir(build_dir) do
        sh "call #{ENV['vcvars']} && cmake .. && msbuild googletest-distribution.sln /p:Configuration=RelWithDebInfo /p:Platform=Win32 /v:m"
      end
    end

    def do_stage
      puts 'Staging googletest...'
      mkdir_p stage_dir
      cp build_outputs, stage_dir
    end

    task cloned: :init do
      do_clone unless File.exist?(project_dir)
    end

    task built: :cloned do
      do_build unless build_outputs.all? { |f| File.exist?(f) }
    end

    task staged: :built do
      do_stage unless stage_outputs.all? { |f| File.exist?(f) }
    end

    desc 'Pull upstream googletest changes'
    task :pull do
      Dir.chdir(project_dir) do
        sh 'git pull'
      end
    end

    desc 'Build and stage googletest'
    task build_stage: :cloned do
      do_build
      do_stage
    end

    desc 'Pull, build and stage googletest'
    task update: [:pull, :build_stage]
  end
end
