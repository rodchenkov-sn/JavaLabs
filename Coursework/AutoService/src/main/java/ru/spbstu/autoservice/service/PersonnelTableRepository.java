package ru.spbstu.autoservice.service;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.PersonnelTableEntity;

public interface PersonnelTableRepository extends CrudRepository<PersonnelTableEntity, Integer> {
}
