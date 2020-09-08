package com.example.flutterwhatsapp;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import nym.mobile.NativeClientFacade;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

//        String homeDirectory = getApplicationContext().getFilesDir().getAbsolutePath();
        new RunServerTask().execute();

    }

    static class RunServerTask extends android.os.AsyncTask {

        public RunServerTask() {

        }

        @Override
        protected Object doInBackground(Object[] objects) {
            String id = "bob";
            NativeClientFacade.init(id);
            NativeClientFacade.run(id);
            return null;
        }
    }
}
