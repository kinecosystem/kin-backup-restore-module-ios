# Backup and Restore Standalone Module

This module is an optional way to back up and/or restore your account.
The module wraps the Kin SDK iOS import and export functionalities with a UI that includes two flows - backup and restore.
The UI uses a password to create a QR code, which is then used to back up the account and to restore it.

It is implemented as an iOS framework that can be incorporated into your code.
This framework is dependent on the kin-sdk framework, and we assume that whoever needs to use it is already familiar with the kin-sdk framework.  
For more details on Kin SDK, go to [kin-sdk on github](https://github.com/kinecosystem/kin-sdk-ios) and/or to our docs in the website - [kin-sdk docs](https://kinecosystem.github.io/kin-website-docs/docs/documentation/ios-sdk).

## Installation

The kin-backup-and-restore module for iOS is implemented as an iOS framework.
It can be included in your project with CocoaPods.

### CocoaPods

Add the following to your `Podfile`.

```
pod 'KinBackupRestoreModule'
```

For the latest release version, go to [https://github.com/kinecosystem/kin-sdk-ios/releases](https://github.com/kinecosystem/kin-sdk-ios/releases).

See the main repository at [github.com/kinecosystem/kin-sdk-ios](https://github.com/kinecosystem/kin-sdk-ios).


## Overview

Launching the Backup and Restore flows requires the following steps:

1. Creating the Backup and Restore manager
2. Adding protocol stubs
<!--3. Passing the result to the Backup and Restore module-->
<!--4. Backup or Restore-->

### Step 1 - Creating the Backup and Restore Manager

You need to create a `KinBackupRestoreManager` object and set its `delegate`.

###### Example of how to create this object:

```swift
let backupRestoreManager = KinBackupRestoreManager()
backupRestoreManager.delegate = self
```

### Step 2 - Adding Backup and Restore protocol stubs

- The did complete function is called when the operation has completed successfully. In the Restore callback, it has a `KinAccount` object, which is the restored account.  
- `onCancel` is called when the user leaves the backup or restore activity and returns to the previous activity.  
- `onFailure()` is called if there is an error in the backup or restore process.

###### Creating Backup callbacks

```swift
extension ViewController: KinBackupRestoreManagerDelegate {
    func kinBackupRestoreManagerDidComplete(_ manager: KinBackupRestoreManager, wasCancelled: Bool) {
    
    }

    func kinBackupRestoreManager(_ manager: KinBackupRestoreManager, error: Error) {

    }
}
```

###### Creating Restore callbacks

```java  
backupAndRestoreManager.registerRestoreCallback(new RestoreCallback() {
@Override
public void onSuccess(KinAccount kinAccount) {
// here you can handle the success.
}

@Override
public void onCancel() {
// here you can handle the cancellation.
}

@Override
public void onFailure(BackupException throwable) {
// here you can handle the failure.
}
});
```

NOTE:
Be sure to unregister from the module when it is no longer needed.
To unregister from the module and release all its resources, use this code:


```java 
backupAndRestoreManager.release();
``` 
You should register/unregister the callbacks in a way that will “survive” an activity restart or similar situations.
In order to achieve that you should register in `Activity.onCreate` and release in `Activity.onDestroy`.

#### Step 3 - Passing the Result to the Backup and Restore module

Since the module internally uses `startActivityForResult`, for it to work properly, you have to implement `onActivityResult` in your activity. In that method, you need to call
`backupAndRestoreManager.onActivityResult(...);`

For example:
```java 
@Override
protected void onActivityResult(int requestCode, int resultCode, Intent data) {
super.onActivityResult(requestCode, resultCode, data);
if (requestCode == REQ_CODE_BACKUP || requestCode == REQ_CODE_RESTORE) {
backupAndRestore.onActivityResult(requestCode, resultCode, data);
}
}
```

#### Step 4 - Backup or Restore
Before you start using the Backup and Restore flows, you need to create a kinClient object.
If you want to back up, you need the KinAccount object, which represents the account that you want to back up.
###### Example of how to create a kinClient object:

```java
kinClient = new KinClient(context, Environment.TEST, "1acd")
...
backupAndRestoreManager = new BackupAndRestoreManager(context);
```
For more details on KinClient and KinAccount, see [KinClient](https://kinecosystem.github.io/kin-website-docs/docs/documentation/android-sdk#accessing-the-kin-blockchain)
and [KinAccount](https://kinecosystem.github.io/kin-website-docs/docs/documentation/android-sdk#creating-and-retrieving-a-kin-account)

Now you can use the Backup and Restore flows by calling these functions:

- For backup:
```java 

backupAndRestoreManager.backup(kinClient, kinAccount);

```
- For restore:
```java 

backupAndRestoreManager.restore(kinClient)
```
### Error Handling

`onFailure(BackupAndRestoreException e)` can be called if an error has occured while trying to back up or restore.

### Testing

Both unit tests and instrumented tests are provided.
For a full list of tests, see

- https://github.com/kinecosystem/kin-sdk-android/tree/master/kin-backup-and-restore/kin-backup-and-restore/src/test
- https://github.com/kinecosystem/kin-sdk-android/tree/master/kin-backup-and-restore/kin-backup-and-restore/src/androidTest


#### Running Tests

For running both unit tests and instrumented tests and generating a code coverage report using Jacoco, use this script:
```bash
$ ./gradlew :kin-backup-and-restore:kin-backup-and-restore jacocoTestReport
```

Generated report can be found at:
kin-backup-and-restore/kin-backup-and-restore/build/reports/jacoco/jacocoTestReport/html/index.html.

### Building from Source

To build from source, clone the repo:

```bash
$ git clone https://github.com/kinecosystem/kin-sdk-android.git
```
Now you can build the library using gradle or open the project using Android Studio.

## Sample App Code

The `kin-backup-and-restore-sample` app covers the entire functionality of `kin-backup-and-restore` and serves as a detailed example of how to use the library.

The sample app source code can be found [here](https://github.com/kinecosystem/kin-sdk-android/tree/master/kin-backup-and-restore/kin-backup-and-restore-sample/).
