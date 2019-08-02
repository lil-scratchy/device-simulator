import ballerina/http;
import ballerina/io;
import ballerina/runtime;
import ballerina/math;
import ballerina/config;

http:Client clientEndpoint = new(config:getAsString("apiUrl", defaultValue = ""));
string[] sensorNames = ["light", "o2", "temp", "pres", "humi", "co2", "tvoc", "mc25"];

public function main() {
    while (true) {
        foreach string sensorName in sensorNames {
            float sensorValue = getValue(sensorName);
            json sensorData = {
                name: sensorName,
                value: sensorValue
            };
            http:Request req = new;
            req.setPayload(sensorData);
            var response = clientEndpoint->post("/", req);
            handleResponse(response);
            runtime:sleep(500);
        }
        runtime:sleep(1000);
    }
}

function getValue(string name) returns (float) {
    match name {
        "light" => return <float> math:randomInRange(250000, 350000);
        "o2" => return <float> math:randomInRange(1000, 2000);
        "temp" => return <float> 10 * math:randomInRange(2000, 3500);
        "pres" => return <float> math:randomInRange(75000, 150000);
        "humi" => return <float> math:randomInRange(25, 75);
        "mc25" => return <float> math:randomInRange(10, 30);
        "tvoc" => return <float> math:randomInRange(30, 50);
        "co2" => return <float> math:randomInRange(400, 1500);
    }
    return 0.0;
}

function handleResponse(http:Response | error response) {
    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {
            io:println("success");
        } else {
            io:println("Invalid payload received:", msg.reason());
        }
    } else {
        io:println("Error when calling the backend: ", response.reason());
    }
}
