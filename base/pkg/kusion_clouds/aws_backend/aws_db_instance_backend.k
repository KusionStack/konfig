import base.pkg.kusion_models.commons
import .aws_config
import base.pkg.kusion_clouds.aws

schema DBInstanceRender[inputData: aws.AWSDBInstance]: 
    assert inputData, "inputData must be specified and can't be empty or None or Undefined"
    provider: commons.ResourceBuilder = {
        type = aws_config.awsDBInstanceMeta.type
        name = inputData.identifier
        provider = aws_config.awsProvider
        providerMeta = aws_config.awsProviderMeta
        providerAttr = inputData
    }
