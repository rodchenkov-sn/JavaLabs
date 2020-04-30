package ru.spbstu.autoservice.service;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.AutomobileTableEntity;

public interface AutomobileTableRepository extends CrudRepository<AutomobileTableEntity, Integer> {
}
