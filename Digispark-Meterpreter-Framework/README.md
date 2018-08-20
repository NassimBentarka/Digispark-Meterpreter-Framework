# Digispark-Meterpreter-Framework
A ruby framework which writes the Digispark arduino code for you by specifying a metasploit payload, beneficial for time saving, efficient when implemented to Kali Linux (for fast shells lovers).
## Getting Started
### Features
1. Generate a shellcode based on the chosen payload.
2. Generate a powershell script containing the payload.
3. Generate a ready Digispark arduino code (Currently support Azerty/Qwerty Windows targets, more operating systems will be supported in the future).
4. Option to self-host the powershell script on the go using a ruby server.
### Prerequisites and Dependencies
- Kali Linux distribution or any distro running these tools:
  MsfVenom
  and
  Metasploit.
  (Note that Kali Linux includes everything required for this framework to run).
- Ruby
### How to use
Run: (Tested on KALI Linux)
```
git clone https://github.com/nassimosaz/Digispark-Meterpreter-Framework.git && cd Digispark-Meterpreter-Framework/
sudo ruby main.rb
```
## Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.
## Authors
* **James Cook** - *Initial work* - [jamesbcook](https://github.com/jamesbcook)
* **Nassim Bentarka** - *Developer and adapter* - [nassimosaz](https://github.com/nassimosaz)
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
