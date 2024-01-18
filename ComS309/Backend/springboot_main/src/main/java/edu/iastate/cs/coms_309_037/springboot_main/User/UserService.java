package edu.iastate.cs.coms_309_037.springboot_main.User;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

	@Autowired
	private UserRepository repo;

	public User findByID(int id) {
		return repo.findById(id);
	}

	public List<User> getUserList() {
		return repo.findAll();
	}

}

