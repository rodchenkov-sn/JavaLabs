package ru.spbstu.autoservice.service;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.JournalTableEntity;

public interface JournalTableRepository extends CrudRepository<JournalTableEntity, Integer> {
}
