package com.reactnativecardscanner;

import android.graphics.Color;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

public class CardScannerViewManager extends SimpleViewManager<ScannerView> implements LifecycleEventListener {
  public static final String REACT_CLASS = "CardScannerView";
  public final int COMMAND_TOGGLE_FLASH = 1;
  public final int COMMAND_RESET_RESULT = 2;
  ReactApplicationContext reactContext;
  ScannerView mScannerView;

  public CardScannerViewManager(ReactApplicationContext reactContext) {
    this.reactContext = reactContext;
  }

  @Override
  @NonNull
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  @NonNull
  public ScannerView createViewInstance(@NonNull ThemedReactContext reactContext) {
    mScannerView = new ScannerView(reactContext);
    reactContext.addLifecycleEventListener(this);
    return mScannerView;
  }

  @ReactProp(name = "frameColor")
  public void setFrameColor(ScannerView view, String color) {
    int parsedColor = Color.parseColor(color);
    if (parsedColor == 0) {
      view.resetFrameColor();
    } else {
      view.setFrameColor(parsedColor);
    }
  }

  /**
   * Map command to an integer
   */
  @Nullable
  @Override
  public Map<String, Integer> getCommandsMap() {
    return MapBuilder.of(
      "toggleFlash", COMMAND_TOGGLE_FLASH,
      "resetResult", COMMAND_RESET_RESULT
    );
  }

  /**
   * Handle command (called from JS)
   */
  @Override
  public void receiveCommand(
    @NonNull ScannerView view,
    String commandId,
    @Nullable ReadableArray args
  ) {
    super.receiveCommand(view, commandId, args);
    int commandIdInt = Integer.parseInt(commandId);

    switch (commandIdInt) {
      case COMMAND_TOGGLE_FLASH:
        view.toggleFlash();
        break;
      case COMMAND_RESET_RESULT:
        view.resetResult();
        break;
      default:
        throw new IllegalArgumentException(
          String.format("Unsupported command %d received by %s.", commandIdInt, getClass().getSimpleName()));
    }
  }

  @Override
  public void onHostResume() {
    if (mScannerView != null) mScannerView.onResume();
  }

  @Override
  public void onHostPause() {
    if (mScannerView != null) mScannerView.onPause();
  }

  @Override
  public void onHostDestroy() {
  }


  public Map getExportedCustomBubblingEventTypeConstants() {
    return MapBuilder.builder().put(
      "onDidScanCard",
      MapBuilder.of(
        "phasedRegistrationNames",
        MapBuilder.of("bubbled", "onDidScanCard")
      )
    ).build();
  }

  @Nullable
  @Override
  public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
    return super.getExportedCustomDirectEventTypeConstants();
  }

}
