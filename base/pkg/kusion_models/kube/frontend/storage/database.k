schema DataBase: 
    """ DataBase is the schema of cloud database.
    Attributes
    ----------
    dataBaseType: str, cloud database type name, default is Undefined.
    dataBaseAttr: DBAttr, cloud database attribute, default is Undefined.
    
    Examples
    --------
    
    """
    dataBaseType: str
    dataBaseAttr: DBAttr

schema DBAttr: 
    """ DBAttr is the Attributes of cloud database.
    Attributes
    ----------
    
    """
    databaseEngine: str
    databaseEngineVersion: str
    cloudChargeType: str
    databaseAccountName: str
    databaseAccountPassword: str
    internetAccess: bool
    