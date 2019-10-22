# KioskLock

KioskLock provides the ability to lock down a rails application to only a specified whitelist of endpoints during a session. The kiosk can be quickly and easily unlocked by passing a kiosk code.

The motivating user scenario for this is a mobile, tablet, or kiosk device where data input must be received from an untrusted user while the device is mainly used by a privileged user (such as a cashier in a POS system). With KioskLock, the device can be safely passed to the end customer to input his/her own information without fear of accidently or malicously utilizing the main user's elevated privileges. 

After the form has been successfully submitted, a simple friendly unlock screen is provided for the privileged user to quickly unlock the kiosk and continue the workflow. 

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'kiosk_lock'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install kiosk_lock
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
