# efs-v2 CfHighlander component

Component to provision Elastic File System

```bash
kurgan add efs-v2
```


## Requirements

## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | string
| EnvironmentType | Tagging | development | true | string | ['development','production']
| VPCId | VPC to launch in |None | false | AWS::EC2::VPC::Id
| SubnetIds | Subnet list to launch in |None | false | List<\/AWS::EC2::Subnet::Id>
| AvailabilityZones | Runtime param to set the az count for the stack |max_availability_zones | true | String
| KmsKeyId | KmsKeyArn if using CMK |None | false | String

## Configuration


**Extra Tags**
Optionally add extra tags from the config file.
```yaml
extra_tags:
    key: value
```

**Security Group**

You can optionally define ip_blocks for use with the security group, a hash of ip cidrs, referenced by key in security group rules

We use the helper function from this repo to generate ingresses:
https://github.com/theonestack/hl-component-lib-ec2/blob/master/ext/cfndsl/security_group.rb

```yaml
ip_blocks:
  local:
    - 127.0.0.1/32
    - 127.0.0.2/32
  public:
    - 0.0.0.0/0
```
```yaml
security_group_rules:
  -
    from: 2049
    ip_blocks:
      - public
    desc: access to efs from public ip set in ip_blocks
  -
    from: 2049
    protocol: tcp
    security_group_id: sg-fqerekjrhr
    desc: access to efs from external security group
  -
    from: 2049
    ip: 169.254.169.254/32
    desc: Singular IP access
```

**Encryption Enabled**

To enable encryption for the file system, set the following, omit the kms parameter if you want to use the default aws key. If using your own key, the kms parameter enables a runtime parameter, 'KmsKeyId' for you to populate with a desired KMS key arn.

```yaml
kms: true
encrypt: true
```

```ruby
parameter name: 'KmsKeyId', value: 'arn:aws:kms:myregion:myaccountid:key/mykeyid'
```

**Lifecycle Policies**

Optionally assign lifecycle policies, a list of values
```yaml
lifecycle_policies:
  - AFTER_14_DAYS
```

**Performance Mode**

Optionally set performance mode
```yaml
performance_mode: maxIO # generalPurpose | maxIO
```

**Throughput Mode**

Optionally set throughput mode
```yaml
throughput_mode: provisioned # bursting | provisioned
```

**Provisioned Throughput**

Optionally set provisioned throughput in mibps, cloudformation expects a double
```yaml
provisioned_throughput: 10.1
```


## Outputs
| Name | Value| Example
| ---- | --- |-------|
| FileSystem | file system ID | fs-12345678
| EFSSecurityGroup | EFS Security group ID | sg-ghrnsla