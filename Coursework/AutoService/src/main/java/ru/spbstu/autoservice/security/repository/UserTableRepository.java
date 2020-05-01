package ru.spbstu.autoservice.security.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.spbstu.autoservice.security.model.UserTableEntity;

public interface UserTableRepository extends JpaRepository<UserTableEntity, Integer> {

    UserTableEntity findByUsername(String username);

}
