package kth.chem.brother_label_printer;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "file_receiver");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//        int width = 200;
//        int height = 50;
//        Bitmap cMap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
//        Canvas canvas = new Canvas(cMap);
//        Paint paint = drawHelloRectangle(canvas, 10, 10, 200, 75);
        Log.d("log", "onMethodCall: called");
//        new Brother().sendFile(cMap,this);

//        void printJob(String filePath) {
//            MethodChannel methodChannel = const MethodChannel("file_receiver");
//            methodChannel
//                    .invokeMethod("method", {'file_path': filePath})
//        .then((value) => print)
//        .catchError((e) => print);
//        }
//        val options = BitmapFactory.Options().apply {
//            inPreferredConfig = Bitmap.Config.ARGB_8888
//            inPremultiplied = false
//        }
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inPreferredConfig = Bitmap.Config.ARGB_8888;
        options.inPremultiplied = false;

        Bitmap bitmap = BitmapFactory.decodeFile(call.argument("file_path"), options);
        Log.d("log", call.argument("file_path"));
//        {'file_path': filePath, 'roll_index': selectedPrinterIndex})
//        System.out.println(bitmap.getByteCount());
        Brother brother = new Brother();
        brother.sendFile(this, bitmap, call.argument("roll_index"));
//        try {
//            new BluetoothSocketUtils().init(this);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
    }


    private Paint drawHelloRectangle(Canvas c, int topLeftX, int topLeftY, int width, int height) {
        Paint mPaint = new Paint();
        // height of 'Hello World'; height*0.7 looks good
        int fontHeight = (int) (height * 0.7);

        mPaint.setColor(Color.BLACK);
        mPaint.setStyle(Paint.Style.FILL);
        c.drawRect(topLeftX, topLeftY, topLeftX + width, topLeftY + height, mPaint);

        mPaint.setTextSize(fontHeight);
        mPaint.setColor(Color.WHITE);
        mPaint.setTextAlign(Paint.Align.CENTER);
        String textToDraw = "FOLLOW BY HEART <3!";
        Rect bounds = new Rect();
        mPaint.setTextSize(14.f);
        mPaint.getTextBounds(textToDraw, 0, textToDraw.length(), bounds);
        c.drawText(textToDraw, topLeftX + width / 2, topLeftY + height / 2 + (bounds.bottom - bounds.top) / 2, mPaint);

        return mPaint;
    }


    public String callMethod(int methodIndex) {
        if ((methodIndex < 1) || (methodIndex > 7))
            throw new IndexOutOfBoundsException("value range error");

        String[] methodsCall = {
                "print_pdf",
                "print_image",
        };

        return methodsCall[methodIndex];
    }
}
