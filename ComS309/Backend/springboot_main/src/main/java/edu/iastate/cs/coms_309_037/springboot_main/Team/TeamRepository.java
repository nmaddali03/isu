package edu.iastate.cs.coms_309_037.springboot_main.Team;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

public interface TeamRepository extends JpaRepository<Team, Long> {
    Team findById(int id);

    @Transactional
    void deleteById(int id);
}