package ru.spbstu.autoservice.model.serialization;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import ru.spbstu.autoservice.model.JournalTableEntity;

import java.io.IOException;

public class JournalTableEntitySerializer extends StdSerializer<JournalTableEntity> {

    public JournalTableEntitySerializer() {
        this(null);
    }

    public JournalTableEntitySerializer(Class<JournalTableEntity> t) {
        super(t);
    }

    @Override
    public void serialize(
            JournalTableEntity journalTableEntity,
            JsonGenerator jsonGenerator,
            SerializerProvider provider
    ) throws IOException {
        jsonGenerator.writeStartObject();
        jsonGenerator.writeNumberField("id", journalTableEntity.getId());
        jsonGenerator.writeNumberField("time_out", journalTableEntity.getTimeOut().getTime());
        jsonGenerator.writeNumberField("time_in", journalTableEntity.getTimeIn().getTime());
        jsonGenerator.writeNumberField("route_id", journalTableEntity.getRoute().getId());
        jsonGenerator.writeNumberField("automobile_id",journalTableEntity.getAutomobile().getId());
        jsonGenerator.writeEndObject();
    }

}
