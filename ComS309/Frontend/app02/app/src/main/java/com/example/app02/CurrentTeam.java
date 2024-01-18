package com.example.app02;

import java.util.List;

public class CurrentTeam {

    private static int id;
    private static String teamName;
    private static int leaderId;
    private static int hour;
    private static int minute;
    private static List<CurrentUser> users;


    public CurrentTeam (int id, String teamName, int leaderId, int hour, int minute, List users) {
        this.id = id;
        this.teamName = teamName;
        this.leaderId = leaderId;
        this.hour = hour;
        this.minute = minute;
        this.users = users;
    }

    public static int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTeamName(String name) { teamName = name; }

    public static String teamName() {
        return teamName;
    }

    public static int getLeaderId() {
        return leaderId;
    }

    public void setHour(int hourPlay) { hour = hourPlay; }

    public static int getHour() {
        return hour;
    }

    public void setMinute(int minutePlay) { minute = minutePlay; }

    public static int getMinute() {
        return minute;
    }

    public void addMembers(List user) { users.add((CurrentUser) user); }

    public void removeMembers(List user) { users.remove((CurrentUser) user); }

    public static List getMembers() {
        return users;
    }

}
