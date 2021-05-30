# AWS Credential setter


- run the script to source your aws credentials into the current shell like below.
```shell
. ./credentials.sh -s

```

- expected output

```shell
. ../credentials.sh -s 
please enter your aws access key id here: aaa
please enter your aws secret access key here: aaa
setting up aws access keys.....
```

- double-check the variable to make sure it is set correctly
```shell
env | grep AWS
AWS_SECRET_ACCESS_KEY=aaa
AWS_ACCESS_KEY_ID=aaa
```

test that your credentials work properly

```shell
. ./credentials.sh -t
```
