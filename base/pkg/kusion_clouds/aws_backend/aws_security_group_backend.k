import base.pkg.kusion_models.commons
import .aws_config
import base.pkg.kusion_clouds.aws

schema SecurityGroupRender[inputData: aws.AWSSecurityGroup]: 
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = aws_config.awsSecurityGroupMeta.type
        name = inputData.name
        provider = aws_config.awsProvider
        providerMeta = aws_config.awsProviderMeta
        providerAttr = inputData
    }
    