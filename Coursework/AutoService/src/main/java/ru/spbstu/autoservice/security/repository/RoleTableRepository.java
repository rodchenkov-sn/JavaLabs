package ru.spbstu.autoservice.security.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.spbstu.autoservice.security.model.RoleTableEntity;

public interface RoleTableRepository extends JpaRepository<RoleTableEntity, Integer> {

    RoleTableEntity findByName(String name);

}
