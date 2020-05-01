package ru.spbstu.autoservice.model.serialization;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import ru.spbstu.autoservice.model.AutomobileTableEntity;

import java.io.IOException;

public class AutomobileTableEntitySerializer extends StdSerializer<AutomobileTableEntity> {

    public AutomobileTableEntitySerializer() {
        this(null);
    }

    public AutomobileTableEntitySerializer(Class<AutomobileTableEntity> t) {
        super(t);
    }

    @Override
    public void serialize(
            AutomobileTableEntity automobileTableEntity,
            JsonGenerator jsonGenerator,
            SerializerProvider provider
    ) throws IOException {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeNumberField("id", automobileTableEntity.getId());
        jsonGenerator.writeStringField("num", automobileTableEntity.getNum());
        jsonGenerator.writeStringField("color", automobileTableEntity.getColor());
        jsonGenerator.writeStringField("mark", automobileTableEntity.getMark());
        jsonGenerator.writeNumberField("driver_id", automobileTableEntity.getDriver().getId());
        jsonGenerator.writeEndObject();
    }

}
