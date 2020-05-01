package ru.spbstu.autoservice.model.serialization;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import ru.spbstu.autoservice.model.PersonnelTableEntity;

import java.io.IOException;

public class PersonnelTableEntitySerializer extends StdSerializer<PersonnelTableEntity> {

    public PersonnelTableEntitySerializer() {
        this(null);
    }

    public PersonnelTableEntitySerializer(Class<PersonnelTableEntity> t) {
        super(t);
    }

    @Override
    public void serialize(
            PersonnelTableEntity personnelTableEntity,
            JsonGenerator jsonGenerator,
            SerializerProvider provider
    ) throws IOException {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeNumberField("id", personnelTableEntity.getId());
        jsonGenerator.writeStringField("first_name", personnelTableEntity.getFirstName());
        jsonGenerator.writeStringField("last_name", personnelTableEntity.getLastName());
        jsonGenerator.writeStringField("father_name", personnelTableEntity.getFatherName());
        jsonGenerator.writeFieldName("automobile_ids");
        jsonGenerator.writeStartArray();
            personnelTableEntity.getAutomobileTableEntities().forEach(a -> {
                try {
                    jsonGenerator.writeNumber(a.getId());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        jsonGenerator.writeEndArray();
        jsonGenerator.writeEndObject();
    }

}
