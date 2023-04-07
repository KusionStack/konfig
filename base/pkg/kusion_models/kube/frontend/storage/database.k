schema DataBase: 
    """ DataBase is the schema of cloud database.
    Attributes
    ----------
    dataBaseType: Literal Type, cloud database type name, default is "aliyun_rds".
    dataBaseAttr: DBAttr, cloud database attribute, default is Undefined.
    
    Examples
    --------
    dataBaseType = "aliyun_rds"
    dataBaseAttr = DBAttr {
        databaseEngine = "MySQL"
        databaseEngineVersion = "5.7"
        cloudChargeType = "Serverless"
        databaseAccountName = "root"
        databaseAccountPassword = "Kusion123456"
        internetAccess = True
    }
    
    """
    dataBaseType: "aliyun_rds"
    dataBaseAttr: DBAttr

schema DBAttr: 
    """ DBAttr is the Attributes of cloud database.
    Attributes
    ----------
    databaseEngine: str, cloud database engine type, default is Undefined. 
    databaseEngineVersion: str, cloud database engine version, default is Undefined. 
    cloudChargeType: str, cloud database charge type, default is Undefined. 
    databaseAccountName: str, initialized account name of cloud database, default is Undefined. 
    databaseAccountPassWord: str, intitialized account password of cloud database, default is Undefined. 
    internetAccess: bool, decide whether the cloud database needs internet access. 
    
    """
    databaseEngine: str
    databaseEngineVersion: str
    cloudChargeType: str
    databaseAccountName: str
    databaseAccountPassword: str
    internetAccess: bool
    