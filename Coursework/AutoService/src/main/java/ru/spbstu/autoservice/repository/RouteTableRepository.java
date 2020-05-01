package ru.spbstu.autoservice.repository;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.RouteTableEntity;

public interface RouteTableRepository extends CrudRepository<RouteTableEntity, Integer> {
}
