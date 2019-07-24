FROM python:3.6-slim

WORKDIR /servo

# Install dependencies
RUN pip3 install jsonpath_ng requests PyYAML boto3 awscli && \
    apt update && apt install -y jq && apt clean -y


# Install servo
ADD https://raw.githubusercontent.com/opsani/servo-statestore/master/adjust \
    https://raw.githubusercontent.com/opsani/servo/master/measure.py \
    https://raw.githubusercontent.com/opsani/servo/master/state_store.py \
    https://raw.githubusercontent.com/opsani/servo/master/adjust.py \
    https://raw.githubusercontent.com/opsani/servo/master/servo \
    measure \
    /servo/

RUN chmod a+rwx /servo/adjust /servo/measure /servo/servo

ENV PYTHONUNBUFFERED=1

ENTRYPOINT [ "python3", "servo" ]
