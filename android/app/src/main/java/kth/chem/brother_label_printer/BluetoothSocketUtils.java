package kth.chem.brother_label_printer;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.ParcelUuid;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Set;

class BluetoothSocketUtils {
    private OutputStream outputStream;
    private InputStream inStream;

    public void init(Context context) throws IOException {
        BluetoothAdapter blueAdapter = BluetoothAdapter.getDefaultAdapter();
        if (blueAdapter != null) {
            if (blueAdapter.isEnabled()) {
                if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
                    Set<BluetoothDevice> bondedDevices = blueAdapter.getBondedDevices();
                    if (bondedDevices.size() > 0) {
                        Object[] devices = bondedDevices.toArray();
                        BluetoothDevice device = (BluetoothDevice) devices[0];
                        Log.d("log", "init: " + device.getName());
                        ParcelUuid[] uuids = device.getUuids();
//                        BluetoothSocket socket = device.createInsecureRfcommSocketToServiceRecord(uuids[0].getUuid());
                        BluetoothSocket socket = device.createRfcommSocketToServiceRecord(uuids[0].getUuid());
                        socket.connect();
                        if (socket.isConnected()) {
                            outputStream = socket.getOutputStream();
                            inStream = socket.getInputStream();
//                            outputStream.write(text.getBytes());
//                            write();
                            new Thread(() -> {
                                try {
//                                    outputStream.flush();
                                    write();
                                    System.out.println("//////////////");
                                    System.out.println("/////called///");
                                    System.out.println("//////////////");
                                    socket.close();
                                    outputStream.close();
                                    inStream.close();
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }

                            }).start();

                        } else System.out.println("////////WTF///");
//                        write();
                    }

                    return;
                }
                Log.e("error", "No appropriate paired devices.");
            } else {
                Log.e("error", "Bluetooth is disabled.");
            }
        }
    }

    public void write() {
        Log.d("log", "write: called");
        printCustom("Fair Group BD", 2);
        printCustom("Pepperoni Foods Ltd.", 0);
        printCustom("H-123, R-123, Dhanmondi, Dhaka-1212", 0);
        printCustom("Hot Line: +88000 000000", 0);
        printCustom("Vat Reg : 0000000000,Mushak : 11", 0);
        printNewLine();
        printCustom("Thank you for coming & we look", 0);
        printCustom("forward to serve you again", 0);
        printNewLine();
        printNewLine();
        printNewLine();
        try {
            outputStream.flush();
            Log.d("log", "write: written");
        } catch (IOException e) {
            e.printStackTrace();
            Log.e("log", "write: ",e );
        }
    }

    //print custom
    private void printCustom(String msg, int size) {
        //Print config "mode"
        byte[] cc = new byte[]{0x1B, 0x21, 0x03};  // 0- normal size text
//        byte[] cc1 = new byte[]{0x1B,0x21,0x00};  // 0- normal size text
        byte[] bb = new byte[]{0x1B, 0x21, 0x08};  // 1- only bold text
        byte[] bb2 = new byte[]{0x1B, 0x21, 0x20}; // 2- bold with medium text
        byte[] bb3 = new byte[]{0x1B, 0x21, 0x10}; // 3- bold with large text
        try {
            switch (size) {
                case 0:
                    outputStream.write(cc);
                    break;
                case 1:
                    outputStream.write(bb);
                    break;
                case 2:
                    outputStream.write(bb2);
                    break;
                case 3:
                    outputStream.write(bb3);
                    break;
            }
//
            switch (1) {
                case 0:
                    //left align
                    outputStream.write(PrinterCommands.ESC_ALIGN_LEFT);
                    break;
                case 1:
                    //center align
                    outputStream.write(PrinterCommands.ESC_ALIGN_CENTER);
                    break;
                case 2:
                    //right align
                    outputStream.write(PrinterCommands.ESC_ALIGN_RIGHT);
                    break;
            }
            outputStream.write(msg.getBytes());
            outputStream.write(PrinterCommands.LF);
            //outputStream.write(cc);
            //printNewLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    //print new line
    private void printNewLine() {
        try {
            outputStream.write(PrinterCommands.FEED_LINE);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    String text = "ESC i a 00h\n" +
            "ESC @\n" +
            "ESC i L 01h\n" +
            "ESC ( C 02h 00h 10h 02h\n" +
            "ESC $ 96h 00h\n" +
            "ESC ( V 02h 00h FCh 00h\n" +
            "ESC k 0Bh\n" +
            "ESC X 00h 32h 00h\n" +
            "At your side\n" +
            "FF";

//    public void run() {
//        final int BUFFER_SIZE = 1024;
//        byte[] buffer = new byte[BUFFER_SIZE];
//        int bytes = 0;
//        int b = BUFFER_SIZE;
//
//        while (true) {
//            try {
//                bytes = inStream.read(buffer, bytes, BUFFER_SIZE - bytes);
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//    }


}


//
//import android.Manifest;
//import android.bluetooth.BluetoothAdapter;
//import android.bluetooth.BluetoothDevice;
//import android.bluetooth.BluetoothServerSocket;
//import android.bluetooth.BluetoothSocket;
//import android.content.Context;
//import android.content.pm.PackageManager;
//import android.os.Build;
//import android.util.Log;
//
//import androidx.annotation.RequiresApi;
//import androidx.core.app.ActivityCompat;
//
//import java.io.BufferedReader;
//import java.io.BufferedWriter;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.OutputStream;
//import java.io.OutputStreamWriter;
//import java.util.Set;
//import java.util.UUID;
//
//public class BluetoothSocketUtils {
//    public static final String error = "error_log";
//    public static final String debug = "error_log";
//
//    void getBluetoothDevices(Context context) {
//        BluetoothAdapter btAdapter = BluetoothAdapter.getDefaultAdapter();
//        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
//            Set<BluetoothDevice> connectedDevices = btAdapter.getBondedDevices();
//            for (BluetoothDevice device : connectedDevices) {
//                Log.d(debug, "getBluetoothDevices: " + device.getName());
//            }
//            BluetoothServerSocket socket = null;
//            UUID uuid = UUID.fromString("2783a76e-08d4-11ed-861d-0242ac120002");
//            try {
//                socket = btAdapter.listenUsingRfcommWithServiceRecord("appNameIs", uuid);
//            } catch (IOException e) {
//                e.printStackTrace();
//                Log.e(error, "socket listen : ", e);
//            }
//
//            OutputStream outputStream = null;
//
//
//            InputStream inStream = null;
//            try {
//                inStream = bluetoothSocket.getInputStream();
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//            byte[] toSend = "Hello World!".getBytes();
//            try {
//                outputStream.write(toSend);
//            } catch (IOException e) {
//                e.printStackTrace();
//                Log.e(error, "write error : ", e);
//            }
//            try {
//                outputStream.flush();
//            } catch (IOException e) {
//                e.printStackTrace();
//                Log.e(error, "flush error : ", e);
//            }
//
//        } else Log.e(error, "permission denied: ");
//    }
//}
