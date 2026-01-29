package xyz.duncanruns.jingle.util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

import java.io.FileWriter;
import java.nio.charset.StandardCharsets;  // 让读写文件指定utf8编码
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public final class FileUtil {
    private static final Gson GSON = new Gson();

    private FileUtil() {
    }

    public static void writeString(Path path, String string) throws IOException {
        // 指定 StandardCharsets.UTF_8 确保编码统一
        Files.write(path, string.getBytes(StandardCharsets.UTF_8));
    }

    public static String readString(Path path) throws IOException {
        // 然后通过 String 构造函数指定 UTF-8 编码
        byte[] bytes = Files.readAllBytes(path);
        return new String(bytes, StandardCharsets.UTF_8);
    }

    public static JsonObject readJson(Path path) throws IOException, JsonSyntaxException {
        return readJson(path, JsonObject.class);
    }

    public static <T> T readJson(Path path, Class<T> clazz, Gson gson) throws IOException {
        return gson.fromJson(readString(path), clazz);
    }

    public static <T> T readJson(Path path, Class<T> clazz) throws IOException {
        return readJson(path, clazz, GSON);
    }
}
