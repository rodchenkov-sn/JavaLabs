package ru.spbstu.autoservice.model.deserialization;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import ru.spbstu.autoservice.model.PersonnelTableEntity;

import java.io.IOException;

public class PersonnelTableEntityDeserializer extends StdDeserializer<PersonnelTableEntity> {

    public PersonnelTableEntityDeserializer() {
        this(null);
    }

    public PersonnelTableEntityDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public PersonnelTableEntity deserialize(JsonParser jp, DeserializationContext dc) throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);
        String firstName = node.get("first_name").asText();
        String lastName = node.get("last_name").asText();
        var personnelTableEntity = new PersonnelTableEntity();
        personnelTableEntity.setFirstName(firstName);
        personnelTableEntity.setLastName(lastName);
        if (node.has("father_name")) {
            personnelTableEntity.setFatherName(node.get("father_name").asText());
        }
        return personnelTableEntity;
    }

}
