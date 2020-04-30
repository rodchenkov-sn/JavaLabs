package ru.spbstu.autoservice.service;

import org.springframework.stereotype.Service;
import ru.spbstu.autoservice.model.*;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class AutomobileDataBaseService {

    private final AutomobileTableRepository automobileTableRepository;
    private final JournalTableRepository journalTableRepository;
    private final PersonnelTableRepository personnelTableRepository;
    private final RouteTableRepository routeTableRepository;

    public AutomobileDataBaseService(
            AutomobileTableRepository automobileTableRepository,
            JournalTableRepository journalTableRepository,
            PersonnelTableRepository personnelTableRepository,
            RouteTableRepository routeTableRepository
    ) {
        this.automobileTableRepository = automobileTableRepository;
        this.journalTableRepository = journalTableRepository;
        this.personnelTableRepository = personnelTableRepository;
        this.routeTableRepository = routeTableRepository;
    }

    //
    //  personnel
    //

    public List<PersonnelTableEntity> getAllPersonnel() {
        var personnel = new ArrayList<PersonnelTableEntity>();
        personnelTableRepository.findAll().forEach(personnel::add);
        return personnel;
    }

    public Optional<PersonnelTableEntity> getPersonnelById(int id) {
        return personnelTableRepository.findById(id);
    }

    public void addPersonnel(PersonnelTableEntity personnelTableEntity) {
        personnelTableRepository.save(personnelTableEntity);
    }

    //
    //  automobiles
    //

    public List<AutomobileTableEntity> getAllAutomobiles() {
        var automobiles = new ArrayList<AutomobileTableEntity>();
        automobileTableRepository.findAll().forEach(automobiles::add);
        return automobiles;
    }

    public Optional<AutomobileTableEntity> getAutomobileById(int id) {
        return automobileTableRepository.findById(id);
    }

    public boolean addAutomobile(AutomobileEntity automobileEntity) {
        var optionalPersonnelTableEntity = personnelTableRepository.findById(automobileEntity.getDriverId());
        if (optionalPersonnelTableEntity.isPresent()) {
            var driver = optionalPersonnelTableEntity.get();
            var automobile = new AutomobileTableEntity();
            automobile.setProperties(automobileEntity);
            driver.bindCar(automobile);
            automobileTableRepository.save(automobile);
            return true;
        } else {
            return false;
        }
    }

    //
    //  routes
    //

    public List<RouteTableEntity> getAllRoutes() {
        var routes = new ArrayList<RouteTableEntity>();
        routeTableRepository.findAll().forEach(routes::add);
        return routes;
    }

    public Optional<RouteTableEntity> getRouteById(int id) {
        return routeTableRepository.findById(id);
    }

    public void addRoute(RouteTableEntity routeTableEntity) {
        routeTableRepository.save(routeTableEntity);
    }

    //
    //  journal
    //

    public List<JournalTableEntity> getAllJournal() {
        var journal = new ArrayList<JournalTableEntity>();
        journalTableRepository.findAll().forEach(journal::add);
        return journal;
    }

    public Optional<JournalTableEntity> getJournalById(int id) {
        return journalTableRepository.findById(id);
    }

    public boolean addJournal(JournalEntity journalEntity) {
        var optionalAutomobileTableEntity = automobileTableRepository.findById(journalEntity.getAutomobileId());
        var optionalRouteTableEntity = routeTableRepository.findById(journalEntity.getRouteId());
        if (optionalAutomobileTableEntity.isPresent() && optionalRouteTableEntity.isPresent()) {
            var automobile = optionalAutomobileTableEntity.get();
            var route = optionalRouteTableEntity.get();
            var journalTableEntity = new JournalTableEntity();
            journalTableEntity.setProperties(journalEntity);
            automobile.bindJournal(journalTableEntity);
            route.bindJournal(journalTableEntity);
            journalTableRepository.save(journalTableEntity);
            return true;
        } else {
            return false;
        }
    }

}
