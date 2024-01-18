package edu.iastate.cs.coms_309_037.springboot_main.Team;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import edu.iastate.cs.coms_309_037.springboot_main.User.User;

@Entity
public class Team {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String teamName;
    private int leaderId;
    private int hr;
    private int min;
    
    @OneToMany
    private List<User> users;


    public Team(String teamName, int leaderId, int hr, int min) {
    	this.teamName = teamName;
    	this.leaderId = leaderId;
    	this.hr = hr;
    	this.min = min;
    	users = new ArrayList<>();
    }
    
    public Team(String teamName, int leaderId) {
    	this.teamName = teamName;
    	this.leaderId = leaderId;
    	hr=-1;
    	min=-1;
    	users = new ArrayList<>();
    }
    
    public Team() {
    	users = new ArrayList<>();
    }
    
    public String getTeamName(){
        return teamName;
    }

    public void setTeamName(String teamName){
        this.teamName = teamName;
    }
    
    public int getId(){
        return id;
    }

    public void setId(int id){
        this.id = id;
    }
    
    public int getHr(){
        return hr;
    }

    public void setHr(int hr){
        this.hr = hr;
    }
    
    public int getMin(){
        return min;
    }

    public void setMin(int min){
        this.min = min;
    }
    
    public int getLeaderId(){
        return leaderId;
    }

    public void setLeaderId(int id){
        this.leaderId = id;
    }
    
    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }

    public void addUser(User user){
        this.users.add(user);
    }

}
