package nym.mobile;

public class NativeClientFacade {

    static {
        System.loadLibrary("nym_mobile");
    }

    public static native void init(String id);

    public static native void run(String id);

}
