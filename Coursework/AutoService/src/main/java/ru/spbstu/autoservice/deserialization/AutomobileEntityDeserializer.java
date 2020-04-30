package ru.spbstu.autoservice.deserialization;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import ru.spbstu.autoservice.model.AutomobileEntity;

import java.io.IOException;

public class AutomobileEntityDeserializer extends StdDeserializer<AutomobileEntity> {

    public AutomobileEntityDeserializer() {
        this(null);
    }

    public AutomobileEntityDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public AutomobileEntity deserialize(JsonParser jp, DeserializationContext dc) throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);
        var num = node.get("num").asText();
        var color = node.get("color").asText();
        var mark = node.get("mark").asText();
        var driverId = node.get("driver_id").asInt();
        return new AutomobileEntity(num, color, mark, driverId);
    }

}
