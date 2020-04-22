CfhighlanderTemplate do

  DependsOn 'lib-ec2@0.1.0'

  Parameters do
    # Must define parameters
    ComponentParam 'EnvironmentName', 'dev', isGlobal: true
    ComponentParam 'EnvironmentType', 'development', isGlobal: true
    ComponentParam 'VPCId', type: 'AWS::EC2::VPC::Id'
    ComponentParam 'SubnetIds', type: 'List<AWS::EC2::Subnet::Id>'
    ComponentParam 'AvailabilityZones', isGlobal: true

    # Optional based on config file
    ComponentParam 'KmsKeyId' if defined? kms
  end

end
