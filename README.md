# DEPRECATION WARNING
This library was originally written for the old Azure portal, which was
retired in 2018. Please do not use this library.

This repository has been archived.

## Description
A library for gathering Azure profile information.

## Prerequisites
* openssl
* json
* nokogiri

## Installation
`gem install azure-profile`

## Synopsis
```ruby
require 'azure/profile'

# Assumes ~/.azure/azureProfile.json exists
prof = Azure::Profile.new

# Uses an existing publish settings file
prof = Azure::Profile.new(:settings_file => '/path/to/publishsettingsfile')

# Or the content of a settings file
prof = Azure::Profile.new(:content => IO.read('/path/to/settingsfile'))

p prof.subscriptions
p prof.default_subscription

# Using azure-profile in conjunction with the azure gem
require 'azure'
require 'azure/profile'

prof = Azure::Profile.new
dsub = prof.default.subscription

# The azure gem currently demands a file
pem_file = File.expand_path("~/.azure/azure.pem")

unless File.exists?(pem_file)
  File.open(pem_file, 'w'){ |fh| fh.write dsub.management_certificate }
end

Azure.configure do |config|
  config.management_certificate = pem_file
  config.subscription_id = dsub.subscription_id
  config.management_endpoint = dsub.management_endpoint
end
```

## Details
The azure-profile gem gathers and wraps your Azure subscription information.
Specifically, it will parse information out of your azureProfile.json file
if present. Alternatively, you can have it use a publishsettings file instead.

With that information you can pass the credentials of the subscription of
your choice to whatever Azure interface you're using, such as the azure gem.

## Getting a publishsettings file
If you want to download a publishsettings file, point your browser at:

https://manage.windowsazure.com/publishsettings/index

Login if you're not already logged in, and it should start a file download.
I recommend putting that file in $HOME/.azure and naming it
"azure.publishsettings" for future convenience.

If you're a powershell user, you can do Get-AzurePublishSettingsFile instead.

A publishsettings file is a simple XML file, so feel free to inspect it
at your convenience.

## Getting an azureProfile.json file
If you've installed and used the cross-platform command line interface, then
you should already have this file. If not, the best way to get one is to install
and login using the command line interface.

http://azure.microsoft.com/en-us/documentation/articles/xplat-cli/

## Future Plans (obsolete)
Allow the option to specify a username and password to automatically
retrieve a publishsettings file if one isn't found.

## Acknowledgements
This library possible courtesy of Red Hat, Inc.

## License
Apache-2.0

## Warranty
This library is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantability and fitness for a particular purpose.

## Authors
* Daniel Berger
* Bronagh Sorota
