#!/usr/bin/env ruby
require_relative 'core'
module Menu
  def webhost_alert
    puts '*' * 50
    puts 'Setting up webserver to host the powershell script'
    puts '*' * 50
  end

  def msfhost_alert
    puts '*' * 30
    puts 'Setting up the MSF server & Generating the shellcode and the powershell script'
    puts '*' * 30
  end
  def intro_alert
    puts '-' * 10
    puts 'This script is designed to create a custom-made Digispark arduino code which is designed to open meterpreter shell on a Windows machine'
    puts 'It saves time by frameworking all the required settings to setup the shellcode, hosting the powershell invoking script locally on the spot, '
    puts 'then, generating the Digispark arduino code.'
    puts 'All you have to do after running the script is to flash the created code onto your Digispark and plug it on the target Windows machine..'
    puts 'NB: the Digispark will open the meterpreter session for you in 30 seconds at maximum, you can customize the Digispark code as you want'
    puts 'by editing the .ino codes located in "~/templates". Happy hunting! Hide your ass before plugging in the Digispark! '
    puts '-' * 10
    puts '@Developer: NBN '
    puts '@Github: https://github.com/nassimosaz'
    puts ''
  end
end
