package com.reactnativecardscanner;

import static cards.pay.paycardsrecognizer.sdk.ndk.RecognitionConstants.RECOGNIZER_MODE_DATE;
import static cards.pay.paycardsrecognizer.sdk.ndk.RecognitionConstants.RECOGNIZER_MODE_NAME;
import static cards.pay.paycardsrecognizer.sdk.ndk.RecognitionConstants.RECOGNIZER_MODE_NUMBER;

import android.content.Context;
import android.graphics.Bitmap;
import android.hardware.Camera;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import cards.pay.paycardsrecognizer.sdk.camera.ScanManager;
import cards.pay.paycardsrecognizer.sdk.camera.widget.CameraPreviewLayout;
import cards.pay.paycardsrecognizer.sdk.ndk.RecognitionResult;

public class ScannerView extends FrameLayout {
  CallbackBridge mCallbacks;
  ScanManager mScanManager;
  ThemedReactContext reactContext;

  public ScannerView(@NonNull ThemedReactContext context) {
    super(context);
    this.reactContext = context;
    mCallbacks = new CallbackBridge();
    LayoutInflater inflater = LayoutInflater.from(context);
    FrameLayout root = (FrameLayout) inflater.inflate(R.layout.wocr_fragment_scan_card, (ViewGroup) null);
    CameraPreviewLayout mCameraPreviewLayout = root.findViewById(R.id.wocr_card_recognition_view);
    final int DEFAULT_RECOGNITION_MODE = RECOGNIZER_MODE_NUMBER | RECOGNIZER_MODE_DATE | RECOGNIZER_MODE_NAME;
    mScanManager = new ScanManager(DEFAULT_RECOGNITION_MODE, context, mCameraPreviewLayout, mCallbacks);
    this.addView(root);
  }

  public ScannerView(@NonNull Context context, @Nullable AttributeSet attrs) {
    super(context, attrs);
  }

  public ScannerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
  }

  public void onResume() {
    mScanManager.onResume();
  }

  public void onPause() {
    mScanManager.onPause();
  }

  public void unfreezeCameraPreview() {
    mScanManager.unfreezeCameraPreview();
  }

  public void freezeCameraPreview() {
    mScanManager.freezeCameraPreview();
  }

  public void toggleFlash() {
    mScanManager.toggleFlash();
  }

  public void resetResult() {
    mScanManager.resetResult();
  }

  public void setFrameColor(int color) {
    mScanManager.setFrameColor(color);
  }

  public void resetFrameColor() {
    mScanManager.resetFrameColor();
  }

  private class CallbackBridge implements ScanManager.Callbacks {
    @Override
    public void onCameraOpened(Camera.Parameters cameraParameters) {

    }

    @Override
    public void onOpenCameraError(Exception exception) {

    }

    @Override
    public void onRecognitionComplete(RecognitionResult result) {
      if (result.isFirst()) {
        if (mScanManager != null) mScanManager.freezeCameraPreview();
      }
      if (result.isFinal()) {
        WritableMap data = Arguments.createMap();
        data.putString("cardNumber", result.getNumber());
        data.putString("holderName", result.getName());
        if (result.getDate() != null && !TextUtils.isEmpty(result.getDate())) {
          String month = result.getDate().substring(0, 2);
          String year = result.getDate().substring(2);
          data.putString("expiryMonth", month);
          data.putString("expiryYear", year);
        }
        reactContext
          .getJSModule(RCTEventEmitter.class)
          .receiveEvent(getId(), "onDidScanCard", data);
      }
    }

    @Override
    public void onCardImageReceived(Bitmap cardImage) {
    }

    @Override
    public void onFpsReport(String report) {
    }

    @Override
    public void onAutoFocusMoving(boolean start, String cameraFocusMode) {
    }

    @Override
    public void onAutoFocusComplete(boolean success, String cameraFocusMode) {
    }
  }

}
