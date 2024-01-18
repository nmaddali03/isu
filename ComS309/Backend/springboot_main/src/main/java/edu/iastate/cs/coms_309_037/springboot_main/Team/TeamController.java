package edu.iastate.cs.coms_309_037.springboot_main.Team;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import edu.iastate.cs.coms_309_037.springboot_main.Leaderboard.Leaderboard;
import edu.iastate.cs.coms_309_037.springboot_main.Score.Score;
import edu.iastate.cs.coms_309_037.springboot_main.User.User;
import edu.iastate.cs.coms_309_037.springboot_main.User.UserRepository;
import io.swagger.annotations.Api;

@Api(value = "UserRestController", description = "REST Apis related to Team Entity: written by David")
@RestController
public class TeamController {
	@Autowired
    TeamRepository teamRepository;
	
	@Autowired
    UserRepository userRepository;
	
	private String success = "{\"message\":\"success\"}";
    private String failure = "{\"message\":\"failure\"}";
    
    @GetMapping(path = "/teams")
    List<Team> getAllTeams(){
        return teamRepository.findAll();
    }
    
    @GetMapping(path = "/team/{id}")
    Team getTeamById( @PathVariable int id){
        return teamRepository.findById(id);
    }
    
    @PostMapping(path = "/team/{name}/{lid}")
    String createTeam(@PathVariable String name, @PathVariable int lid){
        Team team = new Team(name,lid);
        User leader = userRepository.findById(lid);
        team.addUser(leader);
    	leader.setTeam(team);
    	leader.setLeader(true);
        teamRepository.save(team);
    	userRepository.save(leader);
        return success;
    }

    @PostMapping(path = "/team/add/{uid}/{gid}")
    String addUser(@PathVariable int uid,@PathVariable int gid){
    	Team team = teamRepository.findById(gid);
    	User user = userRepository.findById(uid);
    	team.addUser(user);
    	user.setTeam(team);
        teamRepository.save(team);
    	userRepository.save(user);
        return success;
    }
    
    @GetMapping(path = "/team/total/{id}")
    List<Leaderboard> getLeaderboardTotal(@PathVariable int id){
    	List<Score> scores = new ArrayList<Score>();
        Team t = userRepository.findById(id).getTeam();
        for(User u:t.getUsers()) {
        	scores.add(u.getScore());
        }
        scores.sort(Comparator.comparing(Score::getTotal).reversed());
        List<Leaderboard> leaders = new ArrayList<Leaderboard>();
        if(scores.size()<100) {
        	scores=scores.subList(0, scores.size());
        }
        else{
        	scores=scores.subList(0, 100);
        }
        for(Score s:scores) {
        	if(s.getUser()==null) {
        		continue;
        	}
        	leaders.add(new Leaderboard(s.getUser().getUserName(),s.getTotal()));
        }
        return leaders;
    }
    
    @GetMapping(path = "/team/high/{id}")
    List<Leaderboard> getLeaderboardHigh(@PathVariable int id){
        List<Score> scores = new ArrayList<Score>();
        Team t = userRepository.findById(id).getTeam();
        for(User u:t.getUsers()) {
        	scores.add(u.getScore());
        }
        scores.sort(Comparator.comparing(Score::getHigh).reversed());
        List<Leaderboard> leaders = new ArrayList<Leaderboard>();
        if(scores.size()<100) {
        	scores=scores.subList(0, scores.size());
        }
        else{
        	scores=scores.subList(0, 100);
        }
        for(Score s:scores) {
        	if(s.getUser()==null) {
        		continue;
        	}
        	leaders.add(new Leaderboard(s.getUser().getUserName(),s.getHigh()));
        }
        return leaders;
    }
    
    @GetMapping(path = "/team/recent/{id}")
    List<Leaderboard> getLeaderboardRecent(@PathVariable int id){
        List<Score> scores = new ArrayList<Score>();
        Team t = userRepository.findById(id).getTeam();
        for(User u:t.getUsers()) {
        	scores.add(u.getScore());
        }
        scores.sort(Comparator.comparing(Score::getRecent).reversed());
        List<Leaderboard> leaders = new ArrayList<Leaderboard>();
        if(scores.size()<100) {
        	scores=scores.subList(0, scores.size());
        }
        else{
        	scores=scores.subList(0, 100);
        }
        for(Score s:scores) {
        	if(s.getUser()==null) {
        		continue;
        	}
        	leaders.add(new Leaderboard(s.getUser().getUserName(),s.getRecent()));
        }
        return leaders;
    }
    
    @PutMapping("/team/{id}")
    Team updateTeam(@PathVariable int id, @RequestBody Team request){
        Team team = teamRepository.findById(id);
        if(team == null)
            return null;
        teamRepository.save(request);
        return teamRepository.findById(id);
    }

    @DeleteMapping(path = "/team/{id}")
    String deleteTeam(@PathVariable int id){
        teamRepository.deleteById(id);
        return success;
    }
}
