package edu.iastate.cs.coms_309_037.springboot_main.Leaderboard;

public class Leaderboard {
	private String username;
	private int score;
	
	public Leaderboard(String username, int score) {
		this.username=username;
		this.score=score;
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username=username;
	}
	
	public int getScore() {
		return score;
	}
	
	public void setScore(int score) {
		this.score=score;
	}
}