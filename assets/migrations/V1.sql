
    CREATE TABLE companies (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    );
    CREATE TABLE locations (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      parentId TEXT,
      companyId TEXT NOT NULL,
      FOREIGN KEY (companyId) REFERENCES companies(id) ON DELETE CASCADE
    );
    
    CREATE TABLE assets (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      sensorId TEXT,
      gatewayId TEXT,
      parentId TEXT,
      locationId TEXT,
      status TEXT,
      sensorType TEXT,
      companyId TEXT NOT NULL,
      FOREIGN KEY (companyId) REFERENCES companies(id) ON DELETE CASCADE,
      FOREIGN KEY (locationId) REFERENCES locations(id) ON DELETE SET NULL
    );
