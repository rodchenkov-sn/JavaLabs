package ru.spbstu.autoservice.repository;

import org.springframework.data.repository.PagingAndSortingRepository;
import ru.spbstu.autoservice.model.AutomobileTableEntity;

import java.util.List;

public interface AutomobileTableRepository extends PagingAndSortingRepository<AutomobileTableEntity, Integer> {

    public List<AutomobileTableEntity> getAllByDriver_Id(int id);

}
