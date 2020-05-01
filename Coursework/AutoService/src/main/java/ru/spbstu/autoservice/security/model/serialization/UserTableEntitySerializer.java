package ru.spbstu.autoservice.security.model.serialization;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import ru.spbstu.autoservice.security.model.UserTableEntity;

import java.io.IOException;

public class UserTableEntitySerializer extends StdSerializer<UserTableEntity> {

    public UserTableEntitySerializer() {
        this(null);
    }

    public UserTableEntitySerializer(Class<UserTableEntity> t) {
        super(t);
    }

    @Override
    public void serialize(
            UserTableEntity userTableEntity,
            JsonGenerator jsonGenerator,
            SerializerProvider serializerProvider
    ) throws IOException {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeNumberField("id", userTableEntity.getId());
        jsonGenerator.writeStringField("username", userTableEntity.getUsername());
        jsonGenerator.writeEndObject();
    }
}
