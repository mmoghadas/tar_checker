require 'colorize'
require 'fileutils'

class TarChecker

  attr_reader :file1, :file2

  FILE1 = ARGV[0]
  FILE2 = ARGV[1]

  def initialize
    @file1 = get_toc(FILE1)
    @file2 = get_toc(FILE2)

    tar_diff
    uniq_files
    compare_files
  end


  def compare_files
    tmp_root = "/tmp/tar_checker"
    %w(file1 file2).each do |file|
      tmp_dir = "#{tmp_root}/#{file}"
      FileUtils.rm_rf tmp_dir if File.exists? tmp_dir
      FileUtils.mkdir_p tmp_dir
    end

    run("tar zxvf #{FILE1} -C #{tmp_root}/file1")
    run("tar zxvf #{FILE2} -C #{tmp_root}/file2")

    file1.each do |x|
      file2.detect do |y|
        if x == y
          result = `diff #{tmp_root}/file1/#{x} #{tmp_root}/file2/#{y}`
          puts "content of #{tmp_root}/file1/#{x} and #{tmp_root}/file2/#{y} do not match".red if !result.empty?
        end
      end
    end
  end

  def uniq_files
    puts "missing files from #{FILE1}"
    puts "---------------------------"
    puts file2 - file1
    puts ""
    puts "missing files from #{FILE2}"
    puts "---------------------------"
    puts file1 - file2
  end

  def get_toc(file)
    run("tar tf #{file}").split("\n")
  end

  def tar_diff
    run("/usr/bin/diff #{FILE1} #{FILE2}").tap do |t|
      puts t.colorize(:yellow)
    end
  end

  def run(cmd)
    `#{cmd}`
  end
end

TarChecker.new