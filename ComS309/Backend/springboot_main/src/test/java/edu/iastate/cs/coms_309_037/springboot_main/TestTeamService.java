package edu.iastate.cs.coms_309_037.springboot_main;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import edu.iastate.cs.coms_309_037.springboot_main.Team.*;

public class TestTeamService {

	@InjectMocks
	TeamService teamService;

	@Mock
	TeamRepository repo;

	@SuppressWarnings("deprecation")
	@Before
	public void init() {
		MockitoAnnotations.initMocks(this);
	}

	@Test
	public void getTeamByIdTest() {
		when(repo.findById(1)).thenReturn(new Team("TestTeam",1,8,0));

		Team team = teamService.findByID(1);

		assertEquals("TestTeam", team.getTeamName());
		assertEquals(1, team.getLeaderId());
		assertEquals(8, team.getHr());
		assertEquals(0, team.getMin());
	}

	@Test
	public void getAllTeamsTest() {
		List<Team> list = new ArrayList<Team>();
		Team teamOne = new Team("Team1",1);
		Team teamTwo = new Team("Team2",2);
		Team teamThree = new Team("Team3",3);

		list.add(teamOne);
		list.add(teamTwo);
		list.add(teamThree);

		when(repo.findAll()).thenReturn(list);

		List<Team> teamList = teamService.getTeamList();

		assertEquals(3, teamList.size());
		verify(repo, times(1)).findAll();
	}

}