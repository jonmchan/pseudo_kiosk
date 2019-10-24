# PseudoKiosk

[![Build Status](https://travis-ci.org/jonmchan/pseudo_kiosk.svg?branch=master)

PseudoKiosk is a play on words in that its object is to turn a session into a fake kiosk while similarly working like the unix sudo command in switching users temporarily. Instead of granting elevated privileges, PseudoKiosk gives the ability to limit access to the application during workflows which involve physically passing a device with elevated permissions to an unknown or untrusted user. PseudoKiosk provides the ability to lock down a rails application to only a specified whitelist of endpoints during a session. The kiosk can be quickly and easily unlocked by passing a kiosk code.

The motivating user scenario for this is a mobile, tablet, or kiosk device where data input must be received from an untrusted user while the device is mainly used by a privileged user (such as a cashier in a POS system). With PseudoKiosk, the device can be safely passed to the end customer to input his/her own information without fear of accidently or malicously utilizing the main user's elevated privileges. 

After the form has been successfully submitted, a simple friendly unlock screen is provided for the privileged user to quickly unlock the kiosk and continue the workflow. 

## Usage

Add the PseudoKiosk::Engine to your `config/routes.rb`:

```
mount PseudoKiosk::Engine => "/pseudo_kiosk"
```

Add the before_action script to check all requests if it is in protected or not by putting it in your `app/controller/application_controller.rb` file:

```
before_action :secure_pseudo_kiosk
```

Create an initializer to configure pseudo_kiosk in `config/initializers/pseudo_kiosk.rb`:

```
PseudoKiosk::Config.configure! do |config|
  config.unlock_mechanism = "abc"
end
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pseudo_kiosk'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install pseudo_kiosk 
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
