tunnelbroker
============
[![Build Status](https://img.shields.io/travis/theckman/tunnelbroker/master.svg)](https://travis-ci.org/theckman/tunnelbroker)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![Coveralls Coverage](https://img.shields.io/coveralls/theckman/tunnelbroker/master.svg)](https://coveralls.io/r/theckman/tunnelbroker)
[![Code Climate](https://img.shields.io/codeclimate/github/theckman/tunnelbroker.svg)](https://codeclimate.com/github/theckman/tunnelbroker)
[![Gemnasium](https://img.shields.io/gemnasium/theckman/tunnelbroker.svg)](https://gemnasium.com/theckman/tunnelbroker)

Ruby TunnelBroker API client

LICENSE
-------
[tunnelbroker](https://github.com/theckman/tunnelbroker) is released under
the [MIT](http://opensource.org/licenses/MIT) license. The full license has
been provided in the
[LICENSE](https://github.com/theckman/tunnelbroker/blob/master/LICENSE) file.

CONTRIBUTING
------------
See [CONTRIBUTION.md](https://github.com/theckman/tunnelbroker/blob/master/CONTRIBUTING.md)
for information on contributing back to this project.

INSTALLATION
------------
To install on the commandline using `gem`:

```Bash
gem install tunnelbroker
```

If you are including this in your project's `Gemfile`:

```Ruby
gem 'tunnelbroker'
```

USAGE
-----
### Nitty-gritty overview
```Ruby
# require the gem
require 'tunnelbroker'
 => true

# instantiate a new client
client = TunnelBroker::Client.new
 => #<TunnelBroker::Client:0x007fa2fbaac5d0>

# configure the client
client.configure do |c|
  c.tunnelid = 42
  c.username = 'theckman'
  c.update_key = 'YourUpdateKey'
end

# check your config options
client.config.username
 => "theckman"

# update the API, assign the response object
response = client.submit_update
 => #<TunnelBroker::APIResponse:0x007fa2fba20e40 @success=true, @changed=false, @response={:msg=>"nochg", :data=>{:ip=>"50.161.84.35"}}>

# was it successful?
response.success?
 => true

# did the IP address change?
response.changed?
 => false

# configure the client, specifying an ip4addr this time
client.configure do |c|
  c.ip4addr = '127.0.0.1'
end

# update the API, assign the response object
response = client.submit_update
 => #<TunnelBroker::APIResponse:0x007fa2fb9d9c98 @success=true, @changed=true, @response={:msg=>"good", :data=>{:ip=>"127.0.0.1"}}>

# was it successful?
response.success?
 => true

# did the IP address change?
response.changed?
 => true
```

### Configuration
The configuration of the client is done by sending a Ruby block to the client's
`configure` method:

```Ruby
# henceforth, any refences to client will be this:
client = TunnelBroker::Client.new

client.configure do |cfg|
  cfg.username = 'theckman'
end
```

Here are the available configuration items:

| Option       | Explanation |
| ------------ | ----------- |
| `ip4addr`    | Specify the ipv4 address that will connect to the tunnel. If not specified, the IP address of which the request came from is specified. |
| `username`   | This is your [tunnelbroker.net](https://www.tunnelbroker.net/) username                                                                                                  |
| `update_key` | This is the update_key for your tunnel, you can set this on the 'Advanced' tab for your tunnel.                                         |
| `tunnelid`   | The tunnelid from the 'IPv6 Tunnel' tab of your tunnel.                                                                                 |
| `url`        | If you want to use a custom endpoint URL, you can specify it here. Defaults to the TunnelBroker API endpoint.                           |

### Updating the API
There is a simple method to update the API. It returns a `TunnelBroker::APIResponse` object.
```Ruby
client.submit_update
```

### Checking the response object
The response object has two primary methods for telling what happened:

* `.success?` - returns true/false as to whether this was successful or not
* `.changed?` - returns true/false as to whether IP had changed.
* `.response` - Hash containing the response from the server split in to sections.
