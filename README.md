# Digispark-Meterpreter-Framework
A framework which writes your Digispark arduino code for a specific metasploit payload
## Getting Started
### Features
1. Generate a shellcode based on the chosen payload.
2. Generate a powershell script containing the payload.
3. Generate a ready Digispark arduino code.
4. Option to self-host the powershell script on the go using a ruby server.
### Prerequisites
- Kali Linux distribution or any distro running these tools:
  MsfVenom
  and
  Metasploit.
  (Note that Kali Linux includes everything required for this framework to run).
- Ruby
### How to use
Run:
```
sudo ruby main.rb
```
## Contributing
Please read [CONTRIBUTING.md](https://github.com/nassimosaz/Digispark-Meterpreter-Framework/blob/master/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.
## Authors
* **James Cook** - *Initial work* - [jamesbcook](https://github.com/jamesbcook)
* **Nassim Bentarka** - *Developer and adapter* - [nassimosaz](https://github.com/nassimosaz)
## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
