module MCollective
module Agent
class Gamepanelx<RPC::Agent

$queuepath="/usr/local/gpx/queue"
$queuelog="/usr/local/gpx/logs/queue.log"
$tmp_dir="/usr/local/gpx/tmp"
$tmp_dir = "/usr/local/gpx/tmp"

action 'adduser' do
	logger.info("adduser: Starting ...")

	if ! File.exists?("/usr/local/gpx/bin/Restart")
	    reply[:result] = "FAIL"
	end

	in_pass = request[:pass]
	in_user = request[:user]

	logger.info("adduser: Adding user #{in_user} ...")

	run("if [ ! -d /usr/local/gpx/users/#{in_user} ]; then useradd -m -p \"#{in_pass}\" -d /usr/local/gpx/users/#{in_user} -s /bin/bash -c \"GamePanelX User\" gpx#{in_user}; fi")
	run("gpasswd -a gpx#{in_user} #{in_user}")
	run("gpasswd -d gpx#{in_user} wheel 2>&1 >> /dev/null")

	logger.info("adduser: Completed adding #{in_user}.")
end

action 'changepass' do
        logger.info("changepass: Starting ...")

	in_user = request[:user]
	in_pass = request[:pass]

	run("cat #{$tmp_dir}/#{in_user} | chpasswd -e")
	run("rm -f #{$tmp_dir}/#{in_user}")
end

end
end
end
