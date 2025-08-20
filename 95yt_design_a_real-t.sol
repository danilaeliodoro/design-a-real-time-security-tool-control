pragma solidity ^0.8.0;

contract RealTimeSecurityToolController {
    struct SensorData {
        uint id;
        string location;
        uint sensorType; // 0: temperature, 1: humidity, 2: motion
        uint value;
        uint timeStamp;
    }

    struct Alert {
        uint id;
        uint sensorId;
        uint threshold;
        string message;
        bool isActive;
    }

    mapping(uint => SensorData) public sensorData;
    mapping(uint => Alert) public alerts;
    uint public sensorCount;
    uint public alertCount;

    function addSensorData(uint _id, string memory _location, uint _sensorType, uint _value) public {
        sensorData[sensorCount] = SensorData(_id, _location, _sensorType, _value, block.timestamp);
        sensorCount++;
    }

    function addAlert(uint _id, uint _sensorId, uint _threshold, string memory _message) public {
        alerts[alertCount] = Alert(_id, _sensorId, _threshold, _message, true);
        alertCount++;
    }

    function checkAlerts() public {
        for (uint i = 0; i < alertCount; i++) {
            if (alerts[i].isActive) {
                SensorData storage sensor = sensorData[alerts[i].sensorId];
                if (sensor.value > alerts[i].threshold) {
                    // trigger alert
                    emit AlertTriggered(alerts[i].id, alerts[i].message);
                }
            }
        }
    }

    event AlertTriggered(uint alertId, string message);
}