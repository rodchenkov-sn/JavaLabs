package ru.spbstu.autoservice.deserialization;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import ru.spbstu.autoservice.model.JournalEntity;

import java.io.IOException;
import java.sql.Timestamp;

public class JournalEntityDeserializer extends StdDeserializer<JournalEntity> {

    public JournalEntityDeserializer() {
        this(null);
    }

    public JournalEntityDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public JournalEntity deserialize(JsonParser jp, DeserializationContext dc) throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);
        var timeIn = new Timestamp(node.get("time_in").asLong());
        var timeOut = new Timestamp(node.get("time_out").asLong());
        var automobileId = node.get("automobile_id").asInt();
        var routeId = node.get("route_id").asInt();
        return new JournalEntity(timeIn, timeOut, automobileId, routeId);
    }

}
