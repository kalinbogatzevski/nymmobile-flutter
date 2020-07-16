package nym.mobile;

public class MainActivity {

    static {
        System.loadLibrary("nym_mobile")
    }

    public static native void init(String id);

    public static native void run(String id, String host);



}
// run