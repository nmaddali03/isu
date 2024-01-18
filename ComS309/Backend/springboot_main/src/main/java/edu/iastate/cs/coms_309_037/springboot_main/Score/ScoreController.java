package edu.iastate.cs.coms_309_037.springboot_main.Score;

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
import edu.iastate.cs.coms_309_037.springboot_main.User.User;
import edu.iastate.cs.coms_309_037.springboot_main.User.UserRepository;
import io.swagger.annotations.Api;

@Api(value = "UserRestController", description = "REST Apis related to Score Entity: written by David with small edits by Dawood")
@RestController
public class ScoreController {
    @Autowired
    ScoreRepository scoreRepository;
    
    @Autowired
    UserRepository userRepository;

    private String success = "{\"message\":\"success\"}";
    private String failure = "{\"message\":\"failure\"}";

    @GetMapping(path = "/score")
    List<Score> getAllScore(){
        return scoreRepository.findAll();
    }

    @GetMapping(path = "/score/{id}")
    Score getScoreById(@PathVariable int id){
        return scoreRepository.findById(id);
    }
    
    @GetMapping(path = "/leaderboard/total")
    List<Leaderboard> getLeaderboardTotal(){
        List<Score> scores = scoreRepository.findAll();
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
    
    @GetMapping(path = "/leaderboard/high")
    List<Leaderboard> getLeaderboardHigh(){
        List<Score> scores = scoreRepository.findAll();
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

    @PostMapping(path = "/score")
    String createScore(@RequestBody Score Score){
        if(Score == null){
            return failure;
        }
        scoreRepository.save(Score);
        return success;
    }

    /* Updates score */
    @PutMapping(path = "/score/{id}/{newScore}")
    String updateScore(@PathVariable int id, @PathVariable int newScore){
        User user = userRepository.findById(id);
    	Score score = user.getScore();
        user.addCurrency(newScore);
        if(score == null) {
            return failure;
        }
        score.newScore(newScore);
        scoreRepository.save(score);
        userRepository.save(user);
        return success;
    }

    @DeleteMapping(path = "/score/{id}")
    String deleteScore(@PathVariable int id){
        scoreRepository.deleteById(id);
        return success;
    }

}
