package edu.iastate.cs.coms_309_037.springboot_main.Score;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ScoreService {

	@Autowired
	private ScoreRepository repo;

	public Score findByID(int id) {
		return repo.findById(id);
	}

	public List<Score> getScoreList() {
		return repo.findAll();
	}

}
