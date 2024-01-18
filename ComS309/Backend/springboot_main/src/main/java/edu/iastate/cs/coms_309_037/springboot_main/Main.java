package edu.iastate.cs.coms_309_037.springboot_main;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

import edu.iastate.cs.coms_309_037.springboot_main.Score.Score;
import edu.iastate.cs.coms_309_037.springboot_main.Score.ScoreRepository;
import edu.iastate.cs.coms_309_037.springboot_main.User.User;
import edu.iastate.cs.coms_309_037.springboot_main.User.UserRepository;
import edu.iastate.cs.coms_309_037.springboot_main.Team.Team;
import edu.iastate.cs.coms_309_037.springboot_main.Team.TeamRepository;
import edu.iastate.cs.coms_309_037.springboot_main.*;

@SpringBootApplication
@EnableJpaRepositories
class Main {

    public static void main(String[] args) {
        SpringApplication.run(Main.class, args);
    }

    /*@Bean
    CommandLineRunner initUser(UserRepository userRepository, ScoreRepository ScoreRepository) {
        return args -> {
            User user1 = new User("username", "password");
            User user2 = new User("admin", "admin");
            Score score1 = new Score();
            Score score2 = new Score();
            user1.setScore(score1);
            user2.setScore(score2);
            score1.setUser(user1);
            score2.setUser(user2);
            userRepository.save(user1);
            userRepository.save(user2);

        };
    }*/

}

// test
