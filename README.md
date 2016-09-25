
Module to install Go(lang) to run Go code or compile go code.

## Usage
```
class golang {
  version => '1.7.1',
  workdir => '/usr/src/go/'
  installdir => '/usr/local'
}
```
#### version
With this parameter you select the Go version you want to install

#### workdir
This is the directory to place your Go code in

#### installdir
The place where Go will be installed in. So '/usr/local' will install go in '/usr/local/go/'.



# Credits
This module is based on https://github.com/dcoxall/dcoxall-golang
