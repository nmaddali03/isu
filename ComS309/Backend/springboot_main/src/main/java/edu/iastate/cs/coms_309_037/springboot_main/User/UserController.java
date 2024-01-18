package edu.iastate.cs.coms_309_037.springboot_main.User;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import edu.iastate.cs.coms_309_037.springboot_main.Score.Score;
import edu.iastate.cs.coms_309_037.springboot_main.Score.ScoreRepository;
import io.swagger.annotations.Api;

@Api(value = "UserRestController", description = "REST Apis related to User Entity: written by David with small edits by Dawood")
@RestController
public class UserController {

    @Autowired
    UserRepository userRepository;

    @Autowired
    ScoreRepository scoreRepository;

    private String success = "{\"message\":\"success\"}";
    private String failure = "{\"message\":\"failure\"}";

    @GetMapping(path = "/users")
    List<User> getAllUsers(){
        return userRepository.findAll();
    }

    @GetMapping(path = "/users/{id}")
    User getUserById( @PathVariable int id){
        return userRepository.findById(id);
    }
    
    @GetMapping(path = "/user/{username}")
    User getUserByUsername( @PathVariable String username){
        return userRepository.findByUserName(username);
    }

    @GetMapping(path = "/admin/{id}")
    String setAdmin(@PathVariable int id){
    	User user=userRepository.findById(id);
    	user.setAdmin(true);
    	userRepository.save(user);
    	return success;
    }

    @GetMapping(path = "/users/{id}/money")
    int getMoney( @PathVariable int id){
        return userRepository.findById(id).getCurrency();
    }
    
    @GetMapping(path = "/users/{id}/ban")
    String ban( @PathVariable int id){
        User user=userRepository.findById(id);
        user.setBan(true);
        userRepository.save(user);
    	return success;
    }
    
    @GetMapping(path = "/users/{id}/unban")
    String unban( @PathVariable int id){
    	User user=userRepository.findById(id);
        user.setBan(false);
        userRepository.save(user);
    	return success;
    }
    
    @GetMapping(path = "/users/{id}/suspend")
    String suspend( @PathVariable int id){
    	User user=userRepository.findById(id);
        user.setSuspend(true);
        userRepository.save(user);
    	return success;
    }
    
    @GetMapping(path = "/users/{id}/money/add/{money}")
    String addMoney( @PathVariable int id, @PathVariable int money){
    	User user = userRepository.findById(id);
    	user.addCurrency(money);
        userRepository.save(user);
        return success;
    }
    
    @GetMapping(path = "/users/{id}/money/sub/{money}")
    String subMoney( @PathVariable int id, @PathVariable int money){
    	User user = userRepository.findById(id);
    	user.subCurrency(money);
        userRepository.save(user);
        return success;
    }
    
    @GetMapping(path = "/users/{id}/money/set/{money}")
    String setMoney( @PathVariable int id, @PathVariable int money){
    	User user = userRepository.findById(id);
    	user.setCurrency(money);
        userRepository.save(user);
        return success;
    }

    @PutMapping("/users/{id}")
    User updateUser(@PathVariable int id, @RequestBody User request){
        User user = userRepository.findById(id);
        if(user == null)
            return null;
        userRepository.save(request);
        return userRepository.findById(id);
    }

    @PutMapping("/users/{userId}/score/{scoreId}")
    String assignScoreToUser(@PathVariable int userId,@PathVariable int scoreId){
        User user = userRepository.findById(userId);
        Score score = scoreRepository.findById(scoreId);
        if(user == null || score == null)
            return failure;
        score.setUser(user);
        user.setScore(score);
        userRepository.save(user);
        return success;
    }

    @DeleteMapping(path = "/users/{id}")
    String deleteUser(@PathVariable int id){
        userRepository.deleteById(id);
        return success;
    }

    @PostMapping("/addFriend")
	public void addFriend(@RequestParam int id, @RequestParam int fid) {
		User user = userRepository.findById(id);
		User friend = userRepository.findById(fid);
		if(user!= null && friend != null) {
			user.getFriends().add(friend);
			friend.getFriendsOf().add(user);
			userRepository.save(user);
			userRepository.save(friend);
		}
	}
    
    @PostMapping("/getFriends")
	public Set<User> getFriends(@RequestParam int id) {
		User user = userRepository.findById(id);
		return user.getFriends();
	}
    
    @PostMapping("/createUser")
	public String createUser(@RequestParam String name, @RequestParam String email, @RequestParam String username, @RequestParam String password) {
		User user = new User(username, email, password, name);
		Score score = new Score();
		user.setScore(score);
		score.setUser(user);
		userRepository.save(user);
		scoreRepository.save(score);
		return success;
	}

}

