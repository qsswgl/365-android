package net.qsgl365;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.util.Size;
import android.view.OrientationEventListener;
import android.widget.Toast;

import androidx.annotation.OptIn;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.AspectRatio;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ExperimentalGetImage;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageProxy;
import androidx.camera.core.Preview;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.common.util.concurrent.ListenableFuture;
import com.google.mlkit.vision.barcode.BarcodeScanner;
import com.google.mlkit.vision.barcode.BarcodeScannerOptions;
import com.google.mlkit.vision.barcode.BarcodeScanning;
import com.google.mlkit.vision.common.InputImage;

import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * ML Kit 二维码扫描 Activity
 * 
 * 使用 CameraX 和 ML Kit Barcode Scanner 进行二维码扫描
 * 支持二维码、条形码等多种条码格式
 */
public class BarcodeScannerActivity extends AppCompatActivity {
    
    private static final String TAG = "BarcodeScannerActivity";
    private static final int CAMERA_PERMISSION_REQUEST_CODE = 100;
    
    private PreviewView previewView;
    private BarcodeScanner barcodeScanner;
    private ProcessCameraProvider cameraProvider;
    private ExecutorService cameraExecutor;
    
    // 防止多次回调
    private boolean isScanning = false;
    private boolean hasResult = false;
    
    private int currentRotation = 0;
    private OrientationEventListener orientationEventListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_barcode_scanner);
        
        Log.d(TAG, "BarcodeScannerActivity created");
        Log.d(TAG, "开始初始化扫码 Activity");
        
        previewView = findViewById(R.id.previewView);
        cameraExecutor = Executors.newSingleThreadExecutor();
        
        // 初始化条码扫描器（支持所有条码格式）
        try {
            BarcodeScannerOptions options = new BarcodeScannerOptions.Builder()
                    .setBarcodeFormats(
                            1,      // FORMAT_QR_CODE
                            2,      // FORMAT_CODE_128
                            4,      // FORMAT_CODE_39
                            8,      // FORMAT_CODE_93
                            16,     // FORMAT_CODABAR
                            32,     // FORMAT_DATA_MATRIX
                            64,     // FORMAT_EAN_13
                            128,    // FORMAT_EAN_8
                            256,    // FORMAT_ITF
                            512,    // FORMAT_UPC_A
                            1024,   // FORMAT_UPC_E
                            2048,   // FORMAT_PDF417
                            4096    // FORMAT_AZTEC
                    )
                    .build();
            
            barcodeScanner = BarcodeScanning.getClient(options);
            Log.d(TAG, "条码扫描器初始化成功");
        } catch (Exception e) {
            Log.e(TAG, "条码扫描器初始化失败: " + e.getMessage(), e);
            Toast.makeText(this, "条码扫描器初始化失败", Toast.LENGTH_SHORT).show();
            finish();
            return;
        }
        
        // 初始化屏幕方向监听
        orientationEventListener = new OrientationEventListener(this) {
            @Override
            public void onOrientationChanged(int orientation) {
                currentRotation = orientation;
            }
        };
        
        // 检查摄像头权限
        Log.d(TAG, "检查摄像头权限");
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                == PackageManager.PERMISSION_GRANTED) {
            Log.d(TAG, "摄像头权限已授予，启动摄像头");
            startCamera();
        } else {
            Log.d(TAG, "摄像头权限未授予，请求权限");
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.CAMERA},
                    CAMERA_PERMISSION_REQUEST_CODE);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        
        Log.d(TAG, "权限请求结果回调: requestCode=" + requestCode);
        
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d(TAG, "✅ 摄像头权限已授予");
                startCamera();
            } else {
                Log.d(TAG, "❌ 摄像头权限被拒绝");
                Toast.makeText(this, "需要摄像头权限才能扫描二维码", Toast.LENGTH_SHORT).show();
                Log.d(TAG, "设置返回结果为 RESULT_CANCELED");
                setResult(RESULT_CANCELED);
                finish();
            }
        }
    }

    private void startCamera() {
        ListenableFuture<ProcessCameraProvider> cameraProviderFuture =
                ProcessCameraProvider.getInstance(this);

        cameraProviderFuture.addListener(() -> {
            try {
                cameraProvider = cameraProviderFuture.get();
                
                // 预览 use case
                Preview preview = new Preview.Builder()
                        .setTargetAspectRatio(AspectRatio.RATIO_4_3)
                        .build();

                preview.setSurfaceProvider(previewView.getSurfaceProvider());

                // 图像分析 use case（进行条码扫描）
                ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
                        .setTargetAspectRatio(AspectRatio.RATIO_4_3)
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                        .build();

                imageAnalysis.setAnalyzer(cameraExecutor, new ImageAnalysis.Analyzer() {
                    @OptIn(markerClass = ExperimentalGetImage.class)
                    @Override
                    public void analyze(ImageProxy imageProxy) {
                        // 防止多次调用
                        if (hasResult || !isScanning) {
                            imageProxy.close();
                            return;
                        }
                        
                        isScanning = true;
                        
                        try {
                            if (imageProxy.getImage() != null) {
                                InputImage inputImage = InputImage.fromMediaImage(
                                        imageProxy.getImage(),
                                        imageProxy.getImageInfo().getRotationDegrees()
                                );

                                barcodeScanner.process(inputImage)
                                        .addOnSuccessListener(barcodes -> {
                                            if (!barcodes.isEmpty() && !hasResult) {
                                                hasResult = true;
                                                Object barcodeObj = barcodes.get(0);
                                                
                                                try {
                                                    // 通过反射获取条码值和格式
                                                    String barcodeValue = (String) barcodeObj.getClass().getMethod("getRawValue").invoke(barcodeObj);
                                                    int barcodeFormat = (int) barcodeObj.getClass().getMethod("getFormat").invoke(barcodeObj);
                                                    
                                                    Log.d(TAG, "扫码成功: " + barcodeValue);
                                                    Log.d(TAG, "条码格式: " + getBarcodeFormatName(barcodeFormat));
                                                    
                                                    // 返回结果
                                                    Intent resultIntent = new Intent();
                                                    resultIntent.putExtra("barcode_value", barcodeValue);
                                                    resultIntent.putExtra("barcode_format", barcodeFormat);
                                                    resultIntent.putExtra("barcode_format_name", getBarcodeFormatName(barcodeFormat));
                                                    setResult(RESULT_OK, resultIntent);
                                                    
                                                    finish();
                                                } catch (Exception e) {
                                                    Log.e(TAG, "处理扫码结果异常: " + e.getMessage());
                                                }
                                            }
                                        })
                                        .addOnFailureListener(e -> {
                                            Log.e(TAG, "扫码失败: " + e.getMessage());
                                            isScanning = false;
                                        });
                            }
                        } finally {
                            imageProxy.close();
                            isScanning = false;
                        }
                    }
                });

                // 选择后置摄像头
                CameraSelector cameraSelector = new CameraSelector.Builder()
                        .requireLensFacing(CameraSelector.LENS_FACING_BACK)
                        .build();

                // 绑定到生命周期
                try {
                    cameraProvider.unbindAll();
                    cameraProvider.bindToLifecycle(
                            this,
                            cameraSelector,
                            preview,
                            imageAnalysis
                    );
                    Log.d(TAG, "摄像头已启动");
                } catch (Exception e) {
                    Log.e(TAG, "绑定摄像头失败: " + e.getMessage());
                    Toast.makeText(this, "启动摄像头失败", Toast.LENGTH_SHORT).show();
                    finish();
                }
            } catch (ExecutionException | InterruptedException e) {
                Log.e(TAG, "获取摄像头失败: " + e.getMessage());
                Toast.makeText(this, "获取摄像头失败", Toast.LENGTH_SHORT).show();
                finish();
            }
        }, ContextCompat.getMainExecutor(this));
    }

    /**
     * 获取条码格式名称
     */
    private String getBarcodeFormatName(int format) {
        switch (format) {
            case 1:  // Barcode.FORMAT_QR_CODE
                return "QR_CODE";
            case 2:  // Barcode.FORMAT_CODE_128
                return "CODE_128";
            case 4:  // Barcode.FORMAT_CODE_39
                return "CODE_39";
            case 8:  // Barcode.FORMAT_CODE_93
                return "CODE_93";
            case 16: // Barcode.FORMAT_CODABAR
                return "CODABAR";
            case 32: // Barcode.FORMAT_DATA_MATRIX
                return "DATA_MATRIX";
            case 64: // Barcode.FORMAT_EAN_13
                return "EAN_13";
            case 128: // Barcode.FORMAT_EAN_8
                return "EAN_8";
            case 256: // Barcode.FORMAT_ITF
                return "ITF";
            case 512: // Barcode.FORMAT_UPC_A
                return "UPC_A";
            case 1024: // Barcode.FORMAT_UPC_E
                return "UPC_E";
            case 2048: // Barcode.FORMAT_PDF417
                return "PDF417";
            case 4096: // Barcode.FORMAT_AZTEC
                return "AZTEC";
            default:
                return "UNKNOWN";
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        isScanning = true;
        if (orientationEventListener != null) {
            orientationEventListener.enable();
        }
    }

    @Override
    protected void onPause() {
        isScanning = false;
        if (orientationEventListener != null) {
            orientationEventListener.disable();
        }
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        cameraExecutor.shutdown();
        if (cameraProvider != null) {
            cameraProvider.unbindAll();
        }
        if (barcodeScanner != null) {
            barcodeScanner.close();
        }
        super.onDestroy();
    }
}
