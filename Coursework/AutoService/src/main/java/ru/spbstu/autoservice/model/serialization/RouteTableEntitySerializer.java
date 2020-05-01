package ru.spbstu.autoservice.model.serialization;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import ru.spbstu.autoservice.model.RouteTableEntity;

import java.io.IOException;

public class RouteTableEntitySerializer extends StdSerializer<RouteTableEntity> {

    public RouteTableEntitySerializer() {
        this(null);
    }

    public RouteTableEntitySerializer(Class<RouteTableEntity> t) {
        super(t);
    }

    @Override
    public void serialize(
            RouteTableEntity routeTableEntity,
            JsonGenerator jsonGenerator,
            SerializerProvider provider
    ) throws IOException {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeNumberField("id", routeTableEntity.getId());
        jsonGenerator.writeStringField("name", routeTableEntity.getName());
        jsonGenerator.writeFieldName("journal_record_ids");
        jsonGenerator.writeStartArray();
            routeTableEntity.getJournalTableEntities().forEach(j -> {
                try {
                    jsonGenerator.writeNumber(j.getId());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        jsonGenerator.writeEndArray();
        jsonGenerator.writeEndObject();
    }

}
