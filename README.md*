# BlueSim

Bluetooth low energy (LE) is an exciting new technology for creating connected devices and application but up to now the main barrier to entry was you had to buy or create a device to be able to start developing any BLE applications.

The simulator uses unique features in your iPhone 4S or newer or iPad 3 to simulate a client device that you can connect to from your application running on an Android, Windows, Mac or second iOS device with Bluetooth 4 support.

## Details 
 
The simulator supports four common Bluetooth devices services each with it's own user interface to tweak and adjust the simulation as well as a custom battery level service:
 
 * **Heart Rate** with a fluctuating rate around a configurable point and sensor location pick list.
 * **Time** as well as notifications for updates and zone changes.
 * **Blood Pressure** including measurement units, three independent rates and optional pulse reading.
 * **Health Thermometer** with a slider for temperature, Fahrenheit and Celsius units and location pick list.
 * **Battery Level** as a percentage with a currently charging indicator.
 
## Getting started
The project is a starting point for your own device simulations and is open source under the Apache 2 license.
 
We recommend first forking the project on GitHub then checking your fork out to your local machine and deploying it to your device via Xcode.
 
From within the app navigate to one of the device pages and then toggle the device on. It should instantly start advertising the service to other interested Bluetooth devices and applications. Apple’s sample Bluetooth code for Mac OS X has a Health Thermometer and Heart Rate Monitor that works great with the simulator.
 
Now you’ll want to add your own device to the application. There are a few important steps:
 
### A user interface

Start by copying one of the existing device UIs from the storyboard, modifying it to provide the inputs your device simulation requires. Then set the Custom Class for your screen to your own view controller.
 
### A device class

Feel free to start with one of the existing classes. This class represents the device being simulated. The primary changes are making sure you register the various services you wish to expose and then responding to requests for those services by responding with the data packets.
 
### A view controller

The easiest way is again to copy an existing class. This takes care of keeping the device and user interface in step with each other. The UpdateUI method updates the screen with changes from the device while various messages from the UI controls set the inputs on your device.
 
### Integration

Finally to integrate your new device and UI with the app you need to:

1. Add an extra line to the BLEDeviceSimulator class to allocate and initialize your device 
2. Control-drag from the Devices screen to your new screen to create a push segue with a name that matches the name property on your device class
 
If you create a device that might be useful to other people or have any improvements or additional features feel free to contribute back to the project by sending us a pull request from your forked version.
