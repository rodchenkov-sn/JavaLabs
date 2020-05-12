package ru.spbstu.autoservice.repository;

import org.springframework.data.repository.PagingAndSortingRepository;
import ru.spbstu.autoservice.model.PersonnelTableEntity;

public interface PersonnelTableRepository extends PagingAndSortingRepository<PersonnelTableEntity, Integer> {
}
