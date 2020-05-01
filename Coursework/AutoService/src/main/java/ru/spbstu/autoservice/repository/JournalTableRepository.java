package ru.spbstu.autoservice.repository;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.JournalTableEntity;

import java.util.List;

public interface JournalTableRepository extends CrudRepository<JournalTableEntity, Integer> {

    public List<JournalTableEntity> findAllByAutomobile_Id(int id);
    public List<JournalTableEntity> findAllByRoute_Id(int id);

}
