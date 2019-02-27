#########################################################################################################
# VARIABLES
#########################################################################################################

BANNER = """
=========================================================================================================
      ______ ____    ____   _______.    _______   ___________    ____  __  ___  __  .___________.
     /      |\\   \\  /   /  /       |   |       \\ |   ____\\   \\  /   / |  |/  / |  | |           |
    |  ,----' \\   \\/   /  |   (----`   |  .--.  ||  |__   \\   \\/   /  |  '  /  |  | `---|  |----`
    |  |       \\      /    \\   \\       |  |  |  ||   __|   \\      /   |    <   |  |     |  |
    |  `----.   \\    / .----)   |      |  '--'  ||  |____   \\    /    |  .  \\  |  |     |  |
     \\______|    \\__/  |_______/       |_______/ |_______|   \\__/     |__|\\__\\ |__|     |__|

=========================================================================================================
"""

RED              = "\033[0;31m"
YELLOW           = "\033[1;33m"
GREEN            = "\033[1;32m"
BLUE             = "\033[1;34m"
NC               = "\033[0m"

REPOSITORIES     = ["cvs-svc-defects",
                    "cvs-svc-test-stations",
                    "cvs-svc-technical-records",
                    "cvs-svc-test-types",
                    "cvs-svc-preparers",
                    "cvs-svc-test-results",
                    "cvs-svc-activities"]

SERVICE          = ["cvs-svc-defects",
                    "cvs-svc-test-stations",
                    "cvs-svc-technical-records",
                    "cvs-svc-test-types",
                    "cvs-svc-preparers",
                    "cvs-svc-activities",
                    "cvs-svc-test-results"]

  GIT              = "git@github.com:dvsa"
#########################################################################################################
# TASKS
#########################################################################################################

###################
# default
###################

task :default => :help

###################
# help
###################

task :help do

  print "#{BLUE}#{BANNER}#{NC}\n"

  print "rake #{RED}help#{NC}                      --  display help\n"
  print "rake #{RED}branch#{NC}                    --  display current branch of all repos\n"
  print "rake #{RED}clone#{NC}                     --  run 'git clone' on all repos\n"
  print "rake #{RED}pull#{NC}                      --  run 'git pull --rebase' on all repos\n"
  print "rake #{RED}create_branch 'BRANCH'#{NC}    --  run 'git checkout -b \"BRANCH\"' on all repos\n"
  print "rake #{RED}checkout_master#{NC}           --  run 'git checkout master' on all repos\n"
  print "rake #{RED}checkout_develop#{NC}          --  run 'git checkout develop' on all repos\n"

  print "rake #{RED}needs_commit#{NC}              --  checks if any of the repos need a commit\n\n"

  print "rake #{RED}install#{NC}                   --  run npm install in all repositories\n"
  print "rake #{RED}start#{NC}                     --  run npm start in all repositories\n\n"

end

###################
# branch
###################

task :branch do
    print "\nChecking branch in all repositories\n\n"
    REPOSITORIES.each { |repo|
        if directory_exists? repo
            dir = Dir.pwd + "/" + repo
            Dir.chdir(dir) do
                branch = `git rev-parse --abbrev-ref HEAD`
                print "Branch in #{YELLOW}#{repo} is #{BLUE}#{branch}#{NC}\n"
            end
        else
            print "#{RED}ERROR #{YELLOW}#{repo} #{NC}repository does not exist locally\n\n"
        end
    }
end

###################
# clone
###################

task :clone do
    REPOSITORIES.each { |repo|
        if directory_exists? repo
            print "#{RED}ERROR#{NC} Repository #{YELLOW}#{repo} #{NC}has already been cloned\n"
        else
            print "#{RED}Cloning #{YELLOW}#{repo} #{NC}"
            sh "git clone --quiet #{GIT}/#{repo}.git"
            print "#{GREEN}Cloned\n"
        end
    }
end

###################
# pull
###################

task :pull do
    REPOSITORIES.each { |repo|
        if directory_exists? repo
            print "#{RED}Pulling #{YELLOW}#{repo} #{NC}"
            sh "git --git-dir=#{repo}/.git pull --quiet --rebase --autostash"
            print "#{GREEN}Pulled\n"
        else
            print "#{RED}ERROR #{YELLOW}#{repo} #{NC}repository does not exist locally\n"
        end
    }
end

###################
# checkout
###################

task :checkout, [:branch] do |task, args|
    print "\nChecking out branch #{RED}#{args.branch}#{NC} in all repositories\n\n"
    REPOSITORIES.each { |repo|
        if directory_exists? repo
            dir = Dir.pwd + "/" + repo
            Dir.chdir(dir) do
                print "Checking out #{YELLOW}#{repo} #{NC}"
                sh "git checkout --quiet #{args.branch}"
                print "#{GREEN}Done#{NC}\n"
            end
        else
            print "#{RED}ERROR #{YELLOW}#{repo} #{NC}repository does not exist locally\n"
        end
    }
end

###################
# checkout_master
###################

task :checkout_master do
    Rake::Task["checkout"].invoke("master")
end

###################
# checkout_develop
###################

task :checkout_develop do
    Rake::Task["checkout"].invoke("develop")
end


###################
# create_branch
###################

task :create_branch do
    ARGV.each { |a| task a.to_sym do ; end }
    create_git_branch ARGV[1]
end


###################
# needs_commit
###################

task :needs_commit do
    hasChanged = false
    REPOSITORIES.each { |repo|
        if directory_exists? repo
            dir = Dir.pwd + "/" + repo
            if !needs_commit? dir
              hasChanged =true
            end
        else
            print "#{RED}ERROR #{YELLOW}#{repo} #{NC}repository does not exist locally\n"
        end
    }
    if !hasChanged
      print "#{GREEN}No unstaged files#{NC}\n"
    end
end

###################
# install
###################

task :install do
    SERVICE.each { |service|
        if directory_exists? service
            dir = Dir.pwd + "/" + service
            Dir.chdir(dir) do
                print "#{RED}Installing #{YELLOW}#{service} #{NC}"
                sh "npm install"
                print "#{GREEN}Done#{NC}\n"
            end
        else
            print "#{RED}ERROR#{NC} Node modules for #{YELLOW}#{service} #{NC}has already been installed\n"
        end
    }
end

###################
# start
###################

task :start do
    Rake::Task["stop"].invoke()
    SERVICE.each { |service|
        if directory_exists? service
            dir = Dir.pwd + "/" + service
            Dir.chdir(dir) do
                print "#{RED}Starting #{YELLOW}#{service} #{NC}"
                sh "npm run start &"
                print "#{GREEN}Done#{NC}\n"
            end
        else
            print "#{RED}ERROR#{NC} #{YELLOW}#{service} #{NC}has already been started\n"
        end
    }
end

###################
# stop
###################

task :stop do
    kill_port 3000
    kill_port 3001
    kill_port 3002
    kill_port 3003
    kill_port 3004
    kill_port 3005
    kill_port 3006
    kill_port 3007
    kill_port 3008
    kill_port 3009
    kill_port 8000
    kill_port 8001
    kill_port 8002
    kill_port 8003
    kill_port 8004
    kill_port 8005
    kill_port 8006
    kill_port 8007
    kill_port 8008
    kill_port 8009
    end
#########################################################################################################
# HELPERS
#########################################################################################################

def directory_exists?(directory_name)
  File.directory?(directory_name)
end

def needs_commit?(dir = Dir.pwd, file = nil)
  rval = false
  Dir.chdir(dir) do
    status = %x{git status}
    if file.nil?
      rval = true unless status =~ /nothing to commit \(working directory clean\)|nothing added to commit but untracked files present/
      if status =~ /nothing added to commit but untracked files present/
        puts "#{YELLOW}WARNING#{NC}: untracked files present in #{dir}"
        untracked_files = `git ls-files --others --exclude-standard`
        show_changed_files(untracked_files)
      end
    else
      rval = true if status =~ /^#\t.*modified:   #{file}/
    end
  end
  rval
end

def show_changed_files(status)
  status.each_line do |line|
      puts "#{BLUE}=====>> #{line}"
  end
end

def create_git_branch(branch)
    print "\nChecking out branch #{RED}#{branch}#{NC} in all repositories\n\n"
    REPOSITORIES.each { |repo|
        if directory_exists? repo
            dir = Dir.pwd + "/" + repo
            Dir.chdir(dir) do
                if !check_branch_exist? branch
                    print "Checking out #{YELLOW}#{repo} #{NC}"
                    sh "git checkout --quiet -b #{branch}"
                    print "#{GREEN}Done#{NC}\n"
                else
                    print "#{RED}ERROR#{NC} in repository #{YELLOW}#{repo} #{NC}branch already exists locally\n"
                end
            end
        else
            print "#{RED}ERROR #{YELLOW}#{repo} #{NC}repository does not exist locally\n"
        end
    }
end

def check_branch_exist?(branch)
   system("git rev-parse --quiet --verify #{branch} > /dev/null")
end

def kill_port(port)
    sh "lsof -i tcp:#{port} | awk 'NR!=1 {print $2}' | xargs kill || true"
end
