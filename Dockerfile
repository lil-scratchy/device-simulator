FROM ballerina/ballerina
COPY ballerina.conf /home/ballerina
COPY sender.bal /home/ballerina
ENTRYPOINT [ "ballerina","run","sender.bal" ]