package edu.iastate.cs.coms_309_037.springboot_main.Score;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

public interface ScoreRepository extends JpaRepository<Score, Long> {
    Score findById(int id);

    @Transactional
    void deleteById(int id);
}
