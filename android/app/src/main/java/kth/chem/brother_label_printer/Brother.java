package kth.chem.brother_label_printer;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.Log;

import com.brother.ptouch.sdk.LabelInfo;
import com.brother.ptouch.sdk.Printer;
import com.brother.ptouch.sdk.PrinterInfo;
import com.brother.ptouch.sdk.PrinterStatus;
import com.brother.ptouch.sdk.TimeoutSetting;
import com.brother.sdk.lmprinter.Channel;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;


public class Brother {
    Brother() {
        Log.v("app", "Instantiating Brother Printer");
    }

    /**
     * Launch the thread to print
     */
    public void sendFile(Context context, Bitmap bitmap, int label) {
        Log.v("app", "Prepping to send file to printer");
        // Setup the printer

////        just for bluetooth
        BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
        Printer printer = new Printer();
        PrinterInfo printerInfo = printer.getPrinterInfo();

        System.out.println("//////////////////////");
        System.out.println(printerInfo.printerModel.name());
//        System.out.println(printer.getPrinterStatus().toString());
//        System.out.println(printer.getMediaVersion());
        System.out.println("//////////////////////");

//        Channel channel = Channel.newWifiChannel("192.168.118.1");
//        channel.getChannelInfo();
        // Ensure your printer is connected to the same wi-fi used by your device
//        printerInfo.ipAddress = "192.168.118.1";
        printerInfo.printerModel = PrinterInfo.Model.QL_820NWB;
        // just for bluetooth
        printerInfo.port = PrinterInfo.Port.BLUETOOTH;
        if (label == 0) {
            printerInfo.labelNameIndex = LabelInfo.QL700.W29.ordinal();
//            printerInfo.banishMargin = true;
            printerInfo.printMode = PrinterInfo.PrintMode.FIT_TO_PAPER;
        } else {
            printerInfo.labelNameIndex = LabelInfo.QL700.W62RB.ordinal();
            printerInfo.printMode = PrinterInfo.PrintMode.FIT_TO_PAGE;
        }
//        printerInfo.port = PrinterInfo.Port.NET;
//        printerInfo.timeout = new TimeoutSetting();
//        printerInfo.labelNameIndex = LabelInfo.QL700.W62RB.ordinal();
        printerInfo.isAutoCut = true;
        printerInfo.mirrorPrint = false;
//        printerInfo.setCustomPaperInfo(CustomPaperInfo.newCustomRollPaper(PrinterInfo.Model.QL_820NWB, Unit.Mm, 10, 10, 2, 1));
//        printerInfo.printMode = PrinterInfo.PrintMode.FIT_TO_PAPER;

        printerInfo.workPath = context.getCacheDir().getAbsolutePath();
        printer.setPrinterInfo(printerInfo);
        printer.setBluetooth(adapter);

//        https://www.youtube.com/watch?v=4sssbVT5nfk
//        if (file == null)
        new Thread(() -> printBitmap(bitmap, printer)).start();
//        if (file != null) {
//        System.out.println("file printer is called");
//        new Thread(() -> printFile(file, printer)).start();
//        }
    }

    private void printBitmap(Bitmap bitmap, Printer printer) {
        if (printer.startCommunication()) {

//            PrinterStatus status = printer.printPdfFile("/storage/emulated/0/Android/data/kth.chem.brother_label_printer/files/pdf/example.pdf", 1);
//            PrinterStatus status = printer.printPdfFile("/storage/emulated/0/printer/API-book-by-Ei-Maung.pdf", 1);
//            PrinterStatus status = printer.sendBinary(text.getBytes());
            PrinterStatus status = printer.printImage(bitmap);
            // check error
//            if (pdfStatus.errorCode != PrinterInfo.ErrorCode.ERROR_NONE) {
//                Log.e("app", "Brother Printer returned an error message: " + status.errorCode.toString());
//            }
            if (status.errorCode != PrinterInfo.ErrorCode.ERROR_NONE) {
                Log.e("app", "Brother Printer returned an error message: " + status.errorCode.toString());
            }

            printer.endCommunication();
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
}
