
# reverse engineering the Avi-on Android apps

## jadx
https://www.pentestpartners.com/security-blog/reverse-engineering-ble-from-android-apps-with-frida/

Used to decompile the app in order to inspect relevant logic

### com.avion.nodeble.DataBlockGenerator.generateMessage
Contains the logic for constructing the various outgoing payloads

### com.avion.app.ble.Bridge.BLEBridge.decryptMessages
Contains the logic that initially handles incoming payloads

### com.avion.app.ble.gateway.csr.command.CSRMessageManager.createResponse
Contains the logic for handling incoming payloads with respect to specific verbs and nouns

## Frida
https://www.pentestpartners.com/security-blog/reverse-engineering-ble-from-android-apps-with-frida/

Used to hook interesting methods and print out the arguments being passed within the app.
```js
function encodeHex(bytes) {
    var hexArray = [];
    for (var i = 0; i < bytes.length; ++i) {
        var hex = (bytes[i] & 0xff).toString(16);
        hex = hex.length === 1 ? '0' + hex : hex;
        hexArray.push(hex);
    }
    return hexArray.join('');
}

function hookIt() {
    let m = Java.use("com.csr.internal.mesh_le.m");

    // B calls D via y
    m["B"].implementation = function (bArr) {
        console.log(`m.B is called: bArr=${encodeHex(bArr)}`);
        this["B"](bArr);
    };

    let BLEBridge = Java.use("com.avion.app.ble.Bridge.BLEBridge");
    BLEBridge["decryptMessages"].implementation = function (bArr, bArr2, str) {
        console.log(`BLEBridge.decryptMessages is called: bArr=${bArr}, bArr2=${bArr2}, str=${str}`);
        this["decryptMessages"](bArr, bArr2, str);
    };

    let CSRMessageManager = Java.use("com.avion.app.ble.gateway.csr.command.CSRMessageManager");
    CSRMessageManager["processResponse"].implementation = function (j6, bArr) {
        console.log(`CSRMessageManager.processResponse is called: j6=${j6}, bArr=${encodeHex(bArr)}`);
        this["processResponse"](j6, bArr);
    };

    CSRMessageManager["createResponse"].implementation = function (j6, bArr) {
        console.log(`CSRMessageManager.createResponse is called: j6=${j6}, bArr=${bArr}`);
        let result = this["createResponse"](j6, bArr);
        console.log(`CSRMessageManager.createResponse result=${result}`);
        return result;
    };

    let DataBlockGenerator = Java.use("com.avion.nodeble.DataBlockGenerator");
    DataBlockGenerator["convertToDataBlock"].implementation = function (str, str2) {
        console.log(`DataBlockGenerator.convertToDataBlock is called: str=${str}, str2=${str2}`);
        let result = this["convertToDataBlock"](str, str2);
        console.log(`DataBlockGenerator.convertToDataBlock result=${result}`);
        return result;
    };

    let AviOnLogger = Java.use("com.avion.app.logger.AviOnLogger");
    AviOnLogger["v"].implementation = function (str, str2) {
        console.log(`AviOnLogger.v is called: str=${str}, str2=${str2}`);
        this["v"](str, str2);
    };

    AviOnLogger["i"].overload('java.lang.String', 'java.lang.String').implementation = function (str, str2) {
        console.log(`AviOnLogger.i is called: str=${str}, str2=${str2}`);
        this["i"](str, str2);
    };

}
```

# subscribing to GATT charactheristics and decoding them

```py
import csrmesh
import asyncio
from bleak import BleakClient, BleakScanner

CHARACTERISTIC_LOW = "c4edc000-9daf-11e3-8003-00025b000b00"
CHARACTERISTIC_HIGH = "c4edc000-9daf-11e3-8004-00025b000b00"

passphrase = "*****"
friendly_mac_address = "aa:bb:cc:dd::ee::ff"
key = csrmesh.crypto.generate_key(passphrase.encode("ascii") + b"\x00\x4d\x43\x50")

async def main():
    mac_address = format_mac_address(friendly_mac_address)
    async with BleakClient(mac_address) as mesh_connection:

        async def cb(charactheristic: BleakGATTCharacteristic, data: bytearray):
            if charactheristic.uuid == CHARACTERISTIC_LOW:
                mesh.low_bytes = data
            elif charactheristic.uuid == CHARACTERISTIC_HIGH:
                encrypted = bytes([*mesh.low_bytes, *data])
                print(csrmesh.crypto.decrypt_packet(key, encrypted))

        await mesh.start_notify(CHARACTERISTIC_LOW, cb)
        await mesh.start_notify(CHARACTERISTIC_HIGH, cb)
        ....


asyncio.run(main())


```

# understanding Avi-on's data model and web api

## documentation
https://avi-on.com/wp-content/uploads/pdf/install-guides/Cloud-Public-API.pdf

This is pretty old and not for the current v3

## interactive exploration of their API's
https://documenter.getpostman.com/view/6065583/RzfmEmUY

Mix of v2 and v3 examples, not all methods are set up correctly.