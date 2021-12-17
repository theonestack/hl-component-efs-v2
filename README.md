# efs-v2 CfHighlander component
## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | string
| EnvironmentType | Tagging | development | true | string | ['development','production']
| VPCId | VPC ID to connect to | None | false | AWS::EC2::VPC::Id
| SubnetIds | SubnetIDs to provision ENIs to | None | false | string
| AvailabilityZones | Number of AZs to be available in | None | true | string
| KmsKeyId | KMS key ID to use to encrypt data | None | false | string

## Outputs/Exports

| Name | Value | Exported |
| ---- | ----- | -------- |
| FileSystem | file system ID | true
| EFSSecurityGroup | EFS Security group ID | true
| {ap_name}AccessPoint | AccessPoint name

## Included Components
[lib-ec2](https://github.com/theonestack/hl-component-lib-ec2)

## Example Configuration
### Highlander
```
  Component name: 'efsv2', template: 'efs-v2' do
    parameter name: 'VPCId', value: cfout('vpcv2', 'VPCId')
    parameter name: 'SubnetIds', value: cfout('vpcv2', 'PersistenceSubnets')
    parameter name: 'AvailabilityZones', value: '2'
    parameter name: 'VPCCidr', value: cfout('vpcv2', 'VPCCidr')
  end
```
### EFS Configuration
```
encrypt: true

access_points:
  -
    name: AppData
    root_directory:
      CreationInfo:
        OwnerGid: '33'
        OwnerUid: '33'
        Permissions: '774'
      Path: /app_data
  -
    name: AppLogs
    root_directory:
      CreationInfo:
        OwnerGid: '33'
        OwnerUid: '33'
        Permissions: '774'
      Path: /app_logs


security_group_rules:
  -
    protocol: tcp
    from: 2049
    to: 2049
    ip: ${VPCCidr}
  -
    protocol: tcp
    from: 2049
    to: 2049
    ip_blocks:
      - company_office
      - company_client_vpn
```

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

## Cfhighlander Setup

install cfhighlander [gem](https://github.com/theonestack/cfhighlander)

```bash
gem install cfhighlander
```

or via docker

```bash
docker pull theonestack/cfhighlander
```
## Testing Components

Running the tests

```bash
cfhighlander cftest efs-v2
```