#!/usr/bin/env ruby

class MovingTestFile
  attr_reader :repo

  def initialize(repo)
    @repo = repo
  end

  def lab_name
    repo.split("/").last
  end

  def path_to_labs_dir
    "/path/to/temp/labs/dir"
  end

  def move_test_directory
    clone_repo
    change_to_repo_dir
    return unless test_dir_exists?
    update_and_push('master')
    return unless solution_branch_exits?
    return unless test_dir_exists?
    update_and_push('solution')
  end

  def update_and_push(branch)
    rename_test_dir
    commit_changes
    push_changes(branch)
  end

  def change_to_repo_dir
    Dir.chdir "#{path_to_labs_dir}/#{lab_name}"
  end

  def clone_repo
    system("git clone git@github.com:#{repo}.git #{path_to_labs_dir}/#{lab_name}")
  end

  def test_dir_exists?
    !Dir["./test/*"].empty?
  end

  def rename_test_dir
    system("mv ./{test,future_tests}")
  end

  def commit_changes
    system("git add .")
    system("git commit -m 'rename test dir -> future_tests'")
  end

  def push_changes(branch)
    system("git push origin #{branch}")
  end

  def solution_branch_exits?
    system('git checkout solution')
  end
end

completed = [
  'learn-co-curriculum/python-variables-lab',
  'learn-co-curriculum/python-lists-lab',
  'learn-co-curriculum/py-lists-with-maps'
]

# each lab should be a string that looks like: 'learn-co-curriculum/python-variables-readme'
labs = [
]

labs.each do | repo_name |
  puts "============================"
  puts "for #{repo_name}"
  mtf = MovingTestFile.new(repo_name)
  mtf.move_test_directory
  puts "----------------------------"
end
