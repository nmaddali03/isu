package edu.iastate.cs.coms_309_037.springboot_main.User;

import java.sql.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnore;

import edu.iastate.cs.coms_309_037.springboot_main.Team.Team;
import edu.iastate.cs.coms_309_037.springboot_main.Score.Score;

@Entity
@Table(name="users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;
    @Column(unique=true)
    private String userName;
    private String email;
    private String password;
    private boolean admin;
    private boolean ban;
    private boolean suspend;
    private Date suspendDate;
    private int currency;
    private boolean leader;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "score_id")
    private Score score;

    @ManyToOne
    @JoinColumn(name = "team_id")
    @JsonIgnore
    private Team team;

    @ManyToMany(cascade={CascadeType.ALL})
	@JoinTable(name="friends_with",
	joinColumns={@JoinColumn(name="user_id")},
	inverseJoinColumns={@JoinColumn(name="friend_id")})
    @JsonIgnore
	private Set<User> friends = new HashSet<User>();
	
	@ManyToMany(mappedBy="friends")
    @JsonIgnore
	private Set<User> friendsOf = new HashSet<User>();


    public User(String userName, String password){
        this.userName = userName;
        this.password = password;
        name = "";
        email = "";
        team = null;
        admin = false;
        leader = false;
        ban = false;
        suspend = false;
    	suspendDate = null;
        currency = 0;
    }
    public User(String userName, String email, String password){
        this.userName = userName;
        this.email = email;
        this.password = password;
        name = "";
        team = null;
        admin = false;
        leader = false;
        ban = false;
        suspend = false;
    	suspendDate = null;
        currency = 0;
    }
    public User(int id,String userName, String password, String email){
        this.id = id;
    	this.userName = userName;
        this.email = email;
        this.password = password;
        name = "";
        team = null;
        admin = false;
        leader = false;
        ban = false;
        suspend = false;
    	suspendDate = null;
        currency = 0;
    }
    public User(String userName, String email, String password, String name){
        this.userName = userName;
        this.email = email;
        this.password = password;
        this.name = name;
        team = null;
        admin = false;
        leader = false;
        ban = false;
        suspend = false;
    	suspendDate = null;
        currency = 0;
    }

    public User(){
    	team = null;
    }


    public String getUserName(){
        return userName;
    }

    public String getPassword(){
        return password;
    }

    public void setUserName(String userName){
        this.userName = userName;
    }

    public void setPassword(String password){
        this.password = password;
    }

    public void setScore(Score score){
        this.score = score;
    }

    public Score getScore(){
        return score;
    }

    public void setName(String name){
        this.name = name;
    }

    public String getName(){
        return name;
    }

    public void setBan(boolean ban){
        this.ban = ban;
    }

    public boolean getBan(){
        return ban;
    }

	public void setSuspend(boolean suspend){
        this.suspend = suspend;
        long millis=System.currentTimeMillis();
        suspendDate = new Date(millis+7200000);
    }

    public boolean getSuspend(){
        if(suspend && new Date(System.currentTimeMillis()).after(suspendDate)) {
        	suspend=false;
        	suspendDate = null;
        }
    	return suspend;
    }

    public void setSuspendDate(Date suspendDate){
        this.suspendDate = suspendDate;
    }

    public Date getSuspendDate(){
        return suspendDate;
    }

    public void setEmail(String email){
        this.email = email;
    }

    public String getEmail(){
        return email;
    }

    public void setAdmin(boolean admin){
        this.admin = admin;
    }

    public boolean getAdmin(){
        return admin;
    }

    public void setLeader(boolean leader){
        this.leader = leader;
    }

    public boolean getLeader(){
        return leader;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Team getTeam() {
        return team;
    }

    public void setTeam(Team team) {
        this.team = team;
    }

    public Set<User> getFriends() {
        return friends;
    }

    public void setFriends(Set<User> friends) {
        this.friends = friends;
    }

    public void addFriend(User friend) {
        this.friends.add(friend);
    }

    public Set<User> getFriendsOf() {
        return friendsOf;
    }

    public void setFriendsOf(Set<User> friendsOf) {
        this.friendsOf = friendsOf;
    }

    public void addFriendOf(User friend) {
        this.friendsOf.add(friend);
    }

    public int getCurrency() {
        return currency;
    }

    public void setCurrency(int currency) {
        this.currency = currency;
    }

    public void addCurrency(int currency) {
        this.currency += currency;
    }

    public void subCurrency(int currency) {
        this.currency -= currency;
    }
}
