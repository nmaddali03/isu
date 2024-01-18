package com.example.app02;

public class CurrentUser {

    private static Integer id;
    //private int id;
    private static String name;
    private static String userName;
    private static String email;
    private static String password;
    private static Boolean admin;
    private static Boolean suspend;
    private static Integer currency;
    private static Boolean leader;
    private static Integer high;
    private static Integer low;
    private static Integer recent;
    private static Integer total;


    public CurrentUser (int id, String name, String userName, String email, String password, boolean admin, boolean suspend, int currency, boolean leader, int high, int low, int recent, int total) {
        this.id = id;
        this.name = name;
        this.userName = userName;
        this.email = email;
        this.password = password;
        this.admin = admin;
        this.suspend = suspend;
        this.currency = currency;
        this.leader = leader;
        this.high = high;
        this.low = low;
        this.recent = recent;
        this.total = total;

    }

    public static boolean isSuspend() {
        return suspend;
    }

    public static void setSuspend(boolean suspend) {
        CurrentUser.suspend = suspend;
    }

    public static void setTotal(int total) {
        CurrentUser.total = total;
    }

    public static String getName() {
        return name;
    }

    public static Integer getTotal() { return total; }

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

    public static Boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public static Boolean isSuspended() {
        return suspend;
    }

    public static void setSuspended(boolean updatedSuspend) { suspend = updatedSuspend; }

    public static Integer getCurrency() {
        return currency;
    }

    public static void setCurrency(int updatedCurrency) {
        currency = updatedCurrency;
    }

    public static Boolean isLeader() {
        return leader;
    }

    public static void setLeader(boolean updatedLeader) { leader = updatedLeader; }

    public static Integer getHigh() {
        return high;
    }

    public static void setHigh(int highScore) {
        high = highScore;
    }

    public static Integer getLow() {
        return low;
    }

    public void setLow(int low) {
        this.low = low;
    }

    public static Integer getRecent() {
        return recent;
    }

    public static void setRecent(int recentScore) {
        recent = recentScore;
    }

    public static Integer getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
