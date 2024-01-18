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

import edu.iastate.cs.coms_309_037.springboot_main.User.User;
import edu.iastate.cs.coms_309_037.springboot_main.User.UserRepository;
import edu.iastate.cs.coms_309_037.springboot_main.User.UserService;

public class TestUserService {

	@InjectMocks
	UserService userService;

	@Mock
	UserRepository repo;

	@SuppressWarnings("deprecation")
	@Before
	public void init() {
		MockitoAnnotations.initMocks(this);
	}

	@Test
	public void getUserByIdTest() {
		when(repo.findById(1)).thenReturn(new User(1, "jDoe", "123456", "jDoe@gmail.com"));

		User user = userService.findByID(1);

		assertEquals("jDoe", user.getName());
		assertEquals("123456", user.getPassword());
		assertEquals("jDoe@gmail.com", user.getEmail());
	}

	@Test
	public void getAllUsersTest() {
		List<User> list = new ArrayList<User>();
		User userOne = new User(1, "John", "1234", "john@gmail.com");
		User userTwo = new User(2, "Alex", "abcd", "alex@yahoo.com");
		User userThree = new User(3, "Steve", "efgh", "steve@gmail.com");

		list.add(userOne);
		list.add(userTwo);
		list.add(userThree);

		when(repo.findAll()).thenReturn(list);

		List<User> userList = userService.getUserList();

		assertEquals(3, userList.size());
		verify(repo, times(1)).findAll();
	}

}

