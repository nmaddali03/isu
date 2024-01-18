package edu.iastate.cs.coms_309_037.springboot_main.Team;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TeamService {

	@Autowired
	private TeamRepository repo;

	public Team findByID(int id) {
		return repo.findById(id);
	}

	public List<Team> getTeamList() {
		return repo.findAll();
	}

}


