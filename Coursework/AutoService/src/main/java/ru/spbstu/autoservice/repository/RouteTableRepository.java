package ru.spbstu.autoservice.repository;

import org.springframework.data.repository.PagingAndSortingRepository;
import ru.spbstu.autoservice.model.RouteTableEntity;

public interface RouteTableRepository extends PagingAndSortingRepository<RouteTableEntity, Integer> {
}
