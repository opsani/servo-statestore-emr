# Optune Servo with Statestore (adjust) and EMR (measure) drivers

## Build servo container and push to docker registry
```
make container push
```

This will build an image named `opsani/servo-statestore-emr` and push it to Docker Hub.
If you want to build the container under a different name and/or push to private registry:
```
IMG_NAME=my-registry.com/opsani/servo-statestore-emr make container push

```

## Run Servo (as a docker container)
```
docker run -d --network host --name opsani-servo \
    -v /path/to/optune_auth_token:/opt/optune/auth_token \
    -v /path/to/properties_template.json:/servo/properties_template.json
    -v /path/to/config.yaml:/servo/config.yaml \
    opsani/servo-statestore-emr --auth-token /opt/optune/auth_token --account my_account my_app
```


Where:
 * `/path/to/optune_auth_token` - file containing the authentication token for the Optune backend service
 * `/path/to/config.yaml` - config file containing the configuration for the [statestore](https://github.com/opsani/servo-statestore) driver (see links for details on how to configure each).
 * `/path/to/properties_template.json` - template for properties file.
 * `my_account` - your Optune account name
 * `my_app` - the application name

There may be additional files required or supported by the drivers that may need to be mounted in the container, refer to the driver documentation for details.



# Sample Config (includes config for both Statestore and EMR drivers)

```
emr:
  aws_region: us-east-1
  cluster_base_name: my-cluster

  cluster_deploy_cmd: "sh create_cluster.sh {cluster_name}"
  cluster_destroy_cmd: "sh destroy_cluster.sh {cluster_name}"

  pre_steps: # Optional
  - Name: Pre1
    ActionOnFailure: CONTINUE
    HadoopJarStep:
      Jar: command-runner.jar
      Args: ['/bin/bash','-c',"sleep 150"]
  - Name: Pre2
    ActionOnFailure: CONTINUE
    HadoopJarStep:
      Jar: command-runner.jar
      Args: ['/bin/bash','-c',"some command"]

  measure_steps:
  - Name: Measure1
    ActionOnFailure: CONTINUE
    HadoopJarStep:
      Jar: command-runner.jar
      Args: ['/bin/bash','-c',"sleep 30"]
  - Name: Measure2
    ActionOnFailure: CONTINUE
    HadoopJarStep:
      Jar: command-runner.jar
      Args: ['/bin/bash','-c',"sleep 20"]

  post_steps:  # Optional
  - Name: Post1
    ActionOnFailure: CONTINUE
    HadoopJarStep:
      Jar: command-runner.jar
      Args: ['/bin/bash','-c',"sleep 120"]

  # Map between component settings and path in the JSON properties file
  settings_map:
    master:
      inst_type: "$.EMR[*].MasterInstanceType"
    core:
      inst_type: "$.EMR[*].CoreInstanceType"
      replicas: "$.EMR[*].CoreInstanceCount"


  components:
    master:
      settings:
        inst_type:
          type: enum
          value: r5.xlarge
          step: 1
    core:
      settings:
        inst_type:
          type: enum
          value: r5.xlarge
          step: 1
        replicas:
          type: range
          value: 2
          step: 1

```
