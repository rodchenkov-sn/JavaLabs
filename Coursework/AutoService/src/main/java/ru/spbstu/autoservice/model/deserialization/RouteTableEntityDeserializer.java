package ru.spbstu.autoservice.model.deserialization;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import ru.spbstu.autoservice.model.RouteTableEntity;

import java.io.IOException;

public class RouteTableEntityDeserializer extends StdDeserializer<RouteTableEntity> {

    public RouteTableEntityDeserializer() {
        this(null);
    }

    public RouteTableEntityDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public RouteTableEntity deserialize(JsonParser jp, DeserializationContext dc) throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);
        var name = node.get("name").asText();
        var route = new RouteTableEntity();
        route.setName(name);
        return route;
    }

}
