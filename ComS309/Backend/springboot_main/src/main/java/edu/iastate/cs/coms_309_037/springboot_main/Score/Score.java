package edu.iastate.cs.coms_309_037.springboot_main.Score;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.iastate.cs.coms_309_037.springboot_main.User.User;

@Entity
public class Score {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private int low;
    private int high;
    private int total;
    private int recent;

    @OneToOne
    @JsonIgnore
    private User user;

    public Score() {
        this.recent = 0;
        this.low = 0;
        this.high = 0;
        this.total = 0;
    }

    public int getLow() {
        return low;
    }

    public void setLow(int low) {
        this.low = low;
    }

    public int getHigh() {
        return high;
    }

    public void setHigh(int high) {
        this.high = high;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public void incrementTotal(int score) {
        this.total += score;
    }

    public int getRecent() {
        return recent;
    }

    public void setRecent(int recent) {
        this.recent = recent;
    }


    public void newScore(int recent){
        this.recent = recent;
        if(recent>high) {
            high = recent;
        }
        total += recent;
    }

    /*
    public void incrementTotal(int score){
        total += score;
    }
     */

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}
