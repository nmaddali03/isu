package com.example.app02;

public class CurrentUser {

    private static int id;
    //private int id;
    private static String name;
    private static String userName;
    private static String email;
    private static String password;
    private static boolean admin;
    private static int currency;
    private static int high;
    private static int low;
    private static int recent;
    private static int total;


    public CurrentUser (int id, String name, String userName, String email, String password, boolean admin, int currency, int high, int low, int recent, int total) {
        this.id = id;
        this.name = name;
        this.userName = userName;
        this.email = email;
        this.password = password;
        this.admin = admin;
        this.currency = currency;
        this.high = high;
        this.low = low;
        this.recent = recent;
        this.total = total;

    }


    public static String getName() {
        return name;
    }

    public static int getTotal() { return total; }

    public void setName(String name) { this.name = name; }

    public static String getUserName() {
        return userName;
    }

    public static void setUserName(String updatedUsername) {
        userName = updatedUsername;
    }

    public static String getEmail() {
        return email;
    }

    public static void setEmail(String updatedEmail) { email = updatedEmail; }

    public static String getPassword() {
        return password;
    }

    public static void setPassword(String updatedPassword) {
        password = updatedPassword;
    }

    public static boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public static int getCurrency() {
        return currency;
    }

    public static void setCurrency(int updatedCurrency) {
        currency = updatedCurrency;
    }

    public static int getHigh() {
        return high;
    }

    public static void setHigh(int highScore) {
        high = highScore;
    }

    public static int getLow() {
        return low;
    }

    public void setLow(int low) {
        this.low = low;
    }

    public static int getRecent() {
        return recent;
    }

    public static void setRecent(int recentScore) {
        recent = recentScore;
    }

    public static int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
