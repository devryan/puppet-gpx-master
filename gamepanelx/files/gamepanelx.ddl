module MCollective
  module Agent
    class Gamepanelx<RPC::Agent

      action 'install' do
        Package.do_pkg_action(request[:package], :install, reply, request[:version])
      end

      action 'update' do
        Package.do_pkg_action(request[:package], :update, reply)
      end

      action 'uninstall' do
        Package.do_pkg_action(request[:package], :uninstall, reply)
      end


