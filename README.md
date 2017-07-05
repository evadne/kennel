# Kennel

A simple Application showing how to run [Headless Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome) via [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) with [Hound](https://github.com/HashNuke/hound); further configuration and customisation may be required for you to adopt this application in your project.

## Overview

1.  Run Headless Chrome directly via [Exexec](https://github.com/antipax/exexec) (which wraps [Erlexec](https://github.com/saleyn/erlexec)).
2.  Run Chrome Driver directly via Exexec as well.
3.  Configure Chrome Driver to [talk with Headless Chrome directly](https://sites.google.com/a/chromium.org/chromedriver/help/operation-not-supported-when-using-remote-debugging) via Remote Debugging.
4.  Expose this via a custom Hound session builder so anything Hound does can be used.

This gives us much better control over what’s run, at what time, and under what terms, instead of ceding control over spawning of child OS processes to third-party dependencies. (For example, Chrome Driver is set to `detach` by default — see [Capabilities & Options](https://sites.google.com/a/chromium.org/chromedriver/capabilities) — yet when the `SIGTERM` signal is sent to BEAM, only Chrome and not Chrome Driver is terminated.)

## Running

Tested with: Elixir 1.4.4, Erlang/OTP 19, HomeBrew/macOS.

```
➜  evadne-kennel git:(master) iex -S mix
Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.4.4) - press Ctrl+C to exit (type h() ENTER for help)

iex(1)> Kennel.ChromeDriver.start_session
"93ed4f4cf6534b901b850bbaa99cc9ec"

iex(2)> Hound.current_session_id
"93ed4f4cf6534b901b850bbaa99cc9ec"
```

Then onwards with your desired [Hound](https://hexdocs.pm/hound/readme.html) interaction.

For example:

```
iex(3)> use Hound.Helpers        
Hound.Helpers

iex(4)> navigate_to "https://google.com"
nil

iex(5)> page_title()
"Google"
```

## Caution: Remote Debugging

Please note that Chrome Driver achieves certain behaviour via an “automation” extension which needs to be loaded as Chrome is started.

This should be doable via the `--load-extension` argument which is then passed to Chrome, but it is currently not in place and may [cause you issues](https://sites.google.com/a/chromium.org/chromedriver/help/operation-not-supported-when-using-remote-debugging) and the unpacked version of such extension is currently not easily located.

You may be tempted to modify `Kennel.chrome_command` and pass something like this,

```
--load-extension="/Users/evadne/Works/Code/bayandin-chromedriver/extension"
```

but it will not work, because Chrome Driver explicitly bails from `ChromeRemoteImpl::GetAsDesktop`, so any call going through `ChromeRemoteImpl::GetAsDesktop` will not work (and not even tried). Therefore, methods that have to do with screenshots and window sizes do not work at the moment.

ps. As a workaround, if you really want to make screenshots, you can make a `<canvas>`, draw into it, then use `Hound.ScriptExecution` to pass the results back, like what Panic’s [Coda Notes](https://panic.com/blog/coda-notes-previe/) did.

## License

This project is under the MIT license.

## Acknowledgements

-  Special thanks to Mr [Jim Gray](https://twitter.com/grayj_) for identifying the relevant [Hound issue](https://github.com/HashNuke/hound/issues/135#issuecomment-306702019) that allows it to work with Headless Chrome in the first place.
