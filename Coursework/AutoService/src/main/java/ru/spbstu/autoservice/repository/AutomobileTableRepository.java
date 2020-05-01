package ru.spbstu.autoservice.repository;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.AutomobileTableEntity;

import java.util.List;

public interface AutomobileTableRepository extends CrudRepository<AutomobileTableEntity, Integer> {

    public List<AutomobileTableEntity> getAllByDriver_Id(int id);

}
