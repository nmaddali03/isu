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

import edu.iastate.cs.coms_309_037.springboot_main.Score.*;

public class TestScoreService {

	@InjectMocks
	ScoreService scoreService;

	@Mock
	ScoreRepository repo;

	@SuppressWarnings("deprecation")
	@Before
	public void init() {
		MockitoAnnotations.initMocks(this);
	}

	@Test
	public void getScoreByIdTest() {
		when(repo.findById(1)).thenReturn(new Score());

		Score score = scoreService.findByID(1);
		score.newScore(15);
		score.newScore(10);
		score.newScore(5);
		assertEquals(30, score.getTotal());
		assertEquals(10, score.getHigh());
		assertEquals(5, score.getRecent());
	}

	@Test
	public void getAllScoresTest() {
		List<Score> list = new ArrayList<Score>();
		Score scoreOne = new Score();
		Score scoreTwo = new Score();
		Score scoreThree = new Score();

		scoreOne.newScore(15);
		scoreTwo.newScore(10);
		scoreThree.newScore(5);
		
		list.add(scoreOne);
		list.add(scoreTwo);
		list.add(scoreThree);

		when(repo.findAll()).thenReturn(list);

		List<Score> scoreList = scoreService.getScoreList();

		assertEquals(3, scoreList.size());
		verify(repo, times(1)).findAll();
	}

}