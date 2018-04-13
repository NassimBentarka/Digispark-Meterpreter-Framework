# Digispark-Meterpreter-Framework
A framework which writes your Digispark arduino code for a specific metasploit payload
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
Run: (on KALI Linux)
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
