const wd = require('webdriverio');
const { execSync } = require('child_process');

async function runTest() {

  const driver = await wd.remote({
    hostname: '127.0.0.1',
    port: 4723,
    path: '/',
    capabilities: {
      platformName: 'Android',
      'appium:automationName': 'UiAutomator2',
      'appium:deviceName': 'Android',
      'appium:udid': '10.255.38.7:36035',
      'appium:noReset': false,

      'appium:appPackage':
        'com.posternova.posternova',

      'appium:appActivity':
        'com.posternova.posternova.MainActivity',

      'appium:newCommandTimeout': 300,
      'appium:adbExecTimeout': 120000
    }
  });

  try {

    console.log('🚀 App Opened');

    // splash wait
    await driver.pause(7000);

    // ==================================
    // Agree screen (ADB tap)
    // ==================================
    execSync(
      'adb -s 10.255.38.7:36035 shell input tap 550 2050'
    );

    console.log('✅ Agree clicked');

    // wait login screen
    await driver.pause(4000);

    // ==================================
    // Mobile field
    // ==================================
    const mobileField =
      await driver.$('~mobileField');

    await mobileField.waitForDisplayed({
      timeout: 10000
    });

    await mobileField.click();

    await mobileField.setValue(
      '9849008143'
    );

    console.log('✅ Mobile entered');

    // ==================================
    // Continue button
    // ==================================
    const continueBtn =
      await driver.$(
        '~continueButton'
      );

    await continueBtn.click();

    console.log('✅ Continue clicked');

    // wait OTP screen
    await driver.pause(4000);

    // ==================================
    // OTP field
    // ==================================
    const otpField =
      await driver.$('~otpField');

    await otpField.waitForDisplayed({
      timeout: 10000
    });

    await otpField.click();

    await otpField.setValue(
      '1234'
    );

    console.log('✅ OTP entered');

    // ==================================
    // Verify OTP button
    // ==================================
    const verifyBtn =
      await driver.$(
        '~verifyOtpButton'
      );

    await verifyBtn.click();

    console.log(
      '🎉 Login Success'
    );

    // wait for home screen
    await driver.pause(8000);

  } catch (error) {

    console.log(
      '❌ Error:',
      error.message
    );

  } finally {

    await driver.deleteSession();

    console.log(
      '🛑 Session Ended'
    );
  }
}

runTest();