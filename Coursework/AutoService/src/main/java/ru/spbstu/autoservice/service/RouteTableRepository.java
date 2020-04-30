package ru.spbstu.autoservice.service;

import org.springframework.data.repository.CrudRepository;
import ru.spbstu.autoservice.model.RouteTableEntity;

public interface RouteTableRepository extends CrudRepository<RouteTableEntity, Integer> {
}
