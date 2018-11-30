'''
Created on Dic 11, 2016

@author: juan felipe salazar
'''
from sqlalchemy import *
from sqlalchemy.orm import *
import sys,ConfigParser,os.path,hashlib,pprint,psycopg2,time,logging


class OperationDAO(object):
    '''
    classdocs
    '''
    
    logger = logging.getLogger("loggerApi")
    
    getSerialQuery = text('SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = :type AND value = :number')
    
    getMacQuery = text('SELECT value FROM unique_identifier WHERE unique_identifier_type = :type AND  equipment_id = :id')
    
    getFirmwarePathQuery = text('SELECT file_path FROM firmware WHERE name = :name')
    
    getConfigPathQuery = text('SELECT file_path FROM config WHERE name = :name')
    
    setConfigInfo = text('INSERT INTO soup_config_info (message,equipment_id,config_name) value (:parms)')
    
    setConfigInfoCount = text('SELECT COUNT(*) FROM  soup_config_info WHERE equipment_id =:equipment_id')
    
    getSerialbyMac = text("SELECT value FROM unique_identifier WHERE equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'MAC ADDRESS' AND value = :value) AND unique_identifier_type = 'SERIAL NUMBER'")
    
    getEsnbyMac = text("SELECT value FROM unique_identifier WHERE equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'MAC ADDRESS' AND value = :value) AND unique_identifier_type = 'ESN HEX'")

    disconnectPacket = text('select * from public.packet_of_disconnect(:id)')
    

    def __init__(self):
        '''
        Constructor
        '''

    @classmethod    
    def createOssDAO(self):
        
        try:
            #Config parser
            path = os.path.join(os.path.dirname(__file__), 'configDB.ini')
            config = ConfigParser.ConfigParser()
            file = open(path, "rb") 
            config.readfp(file) 
            file.close()
            
            #Database parameters 
            username = config.get('ossProductionDB','username')
            password = config.get('ossProductionDB','password')
            host = config.get('ossProductionDB','host')
            port = config.get('ossProductionDB','port')
            dbname = config.get('ossProductionDB','dbname')
            
            #SQLalchemist connection                
            engine = create_engine('postgresql://'+username+':'+password+'@'+host+':'+port+'/'+dbname)
            #engine = create_engine('mysql://'+username+':'+password+'@'+host+':'+port+'/'+dbname)  
            return engine
        except Exception as ex:
            print(str(ex))
            pass
    
    @classmethod    
    def createPortalDAO(self):
        
        try:
            #Config parser
            path = os.path.join(os.path.dirname(__file__), 'configDB.ini')
            config = ConfigParser.ConfigParser()
            file = open(path, "rb") 
            config.readfp(file) 
            file.close()
            
            #Database parameters 
            username = config.get('portalProductionDB','username')
            password = config.get('portalProductionDB','password')
            host = config.get('portalProductionDB','host')
            port = config.get('portalProductionDB','port')
            dbname = config.get('portalProductionDB','dbname')
            
            #SQLalchemist connection                
            engine = create_engine('postgresql://'+username+':'+password+'@'+host+':'+port+'/'+dbname)
            #engine = create_engine('mysql://'+username+':'+password+'@'+host+':'+port+'/'+dbname)            
            
            return engine
        except Exception as ex:
            print(str(ex))
    
    @classmethod    
    def createSoupDAO(self):
        
        try:
            #Config parser
            path = os.path.join(os.path.dirname(__file__), 'configDB.ini')
            config = ConfigParser.ConfigParser()
            file = open(path, "rb") 
            config.readfp(file) 
            file.close()
            
            #Database parameters time
            username = config.get('soupProductionDB','username')
            password = config.get('soupProductionDB','password')
            host = config.get('soupProductionDB','host')
            port = config.get('soupProductionDB','port')
            dbname = config.get('soupProductionDB','dbname')
            
            #SQLalchemist connection                
            #engine = create_engine('postgresql://'+username+':'+password+'@'+host+':'+port+'/'+dbname)
            engine = create_engine('mysql://'+username+':'+password+'@'+host+':'+port+'/'+dbname)            
            
            return engine
        except Exception as ex:
            print(str(ex))
    
    @classmethod
    def getMac(self,req):
        
        try:
            engine = self.createOssDAO()
            
            typeId = 'SERIAL NUMBER'
            typeId2 = 'MAC ADDRESS'
            numberId = req['sn']
            connection = engine.connect() 
            connection.begin()
        
            serial = connection.execute(self.getSerialQuery , type=typeId, number=numberId).fetchall()
            
            result = connection.execute(self.getMacQuery , type=typeId2, id=serial[0][0]).fetchall()
            
            connection.close()
        except Exception as ex:
            print(str(ex))
        
        return result
    
    @classmethod
    def getConfigPathAndDevice(self,req):
        
        try:
            engine = self.createOssDAO()
            
            path = req['configName']
            connection = engine.connect() 
            connection.begin()
            
            result = connection.execute(self.getConfigPathQuery, name=path).fetchall()
            
            connection.close()
        except Exception as ex:
            print(str(ex))
        
        return result
    
    @classmethod
    def getFirmwarePathAndDevice(self,req):
        
        try:
            engine = self.createOssDAO()
            
            path = req['configName']
            connection = engine.connect() 
            connection.begin()
            
            result = connection.execute(self.getFirmwarePathQuery, name=path).fetchall()
            
            connection.close()
            
        except Exception as ex:
            print(str(ex))
        
        return result   
    
    @classmethod
    def queryConfigInfo(self,req):
        
        try:
            engine = self.createOssDAO()
            
            mac = str("SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'MAC ADDRESS' AND value ILIKE '%%"+req['mac']+"'")
            connection = engine.connect()        
            connection.begin()
            
            equipment = connection.execute(mac) 
            
            id = 0
            for row in equipment:
                id = row[0]  
            
            connection.close()
        except Exception as ex:
            print(str(ex))
        
        return id 
    
    @classmethod
    def insertConfigInfo(self, id, req):
        
        try:
            engine = self.createOssDAO()
            
            connection = engine.connect() 
            connection.begin()
            
            count = connection.execute(self.setConfigInfoCount, equipment_id=id).fetchall()
            
            connection.close()
            
            # create a configured "Session" class
            Session = sessionmaker(bind=engine)
        
            # create a Session
            session = Session()
            
            message = req['message']
            name = req['configName']
            
            if (count[0][0] == 0):        
                session.execute("INSERT INTO soup_config_info (message,equipment_id,config_name) VALUES ('"+ "%s" %message+"',"+ "%s" %id+",'"+ "%s" %name+"')")
                 
                #session.execute(query)
                
            else:
                session.execute("UPDATE soup_config_info SET message = '"+ "%s" %message+"',config_name ='"+ "%s" %name+"' WHERE equipment_id = "+ "%s" %id)
                
            session.commit() 
            session.close()
        except Exception as ex:
            print(str(ex))
    
    @classmethod
    def insertDigiDevice(self, mac,model,serial,partNumber,lastIp):
        try:
            engine = self.createSoupDAO()
            now = int(time.time())
            
            # create a configured "Session" class
            Session = sessionmaker(bind=engine)
            
            # create a Session
            session = Session()
            
            did = session.execute("SELECT did FROM sdm.device WHERE eui = '"+"%s" %mac+"'").fetchall()
            if not did:
                session.execute("INSERT INTO sdm.device (create_date, timestamp, eui, model, serial_number, part_number, lastip) "
                                "VALUES ("+ "%d" %now+","+ "%d" %now+",'"+ "%s" %mac+"','"+ "%s" %model+"','"+ "%s" %serial+"','"+ "%s" %partNumber+"',"
                                "'"+ "%s" %lastIp+"')")
                did = session.execute("SELECT LAST_INSERT_ID()").fetchall() 
                did = did[0][0]      
            else:
                did = did[0][0]
                session.execute("UPDATE sdm.device "
                                "SET "
                                "timestamp = "+ "%d" %now+", "
                                "model = '"+ "%s" %model+"', "
                                "serial_number = '"+ "%s" %serial+"', "
                                "part_number = '"+ "%s" %partNumber+"', "
                                "lastip = '"+ "%s" %lastIp+"' "
                                "WHERE "
                                "did = "+ "%d" %did)
                
            session.commit() 
            session.close()
        except Exception as ex:
            print(str(ex))
        
        return did
    
    @classmethod
    def insertDigiDeviceStats(self, did, firmware,firmware_time,uptime):
        
        try:
            engine = self.createSoupDAO()
            now = int(time.time())
            
            # create a configured "Session" class
            Session = sessionmaker(bind=engine)
            
            # create a Session
            session = Session()
            
            session.execute("INSERT INTO sdm.device_stats "
                            "(did, timestamp, firmware, firmware_time, uptime, log_errors, log_warnings, pda_errors) "
                            "VALUES "
                            "("+ "%s" %did+","+ "%s" %now+",'"+"%s" %firmware+"',"+"%s" %firmware_time+","+"%s" %uptime+","
                            "0,0,0)")
            
            session.commit() 
            session.close()
        except Exception as ex:
            print(str(ex))
    
    @classmethod
    def insertDigiCellInfo(self, did, esn, imsi):
        
        try:
            engine = self.createSoupDAO()
            
            # create a configured "Session" class
            Session = sessionmaker(bind=engine)
            
            # create a Session
            session = Session()
            
            exist = session.execute("SELECT * FROM sdm.cellinfo WHERE did = "+"%d" %did).fetchall()
            
            if not exist:
                session.execute("INSERT INTO sdm.cellinfo (did,esn,imsi) VALUES "
                            "("+ "%d" %did+",'"+"%s" %esn+"','"+"%s" %imsi+"')")
            else:
                session.execute("UPDATE sdm.cellinfo SET esn = '"+"%s" %esn+"', imsi = '"+"%s" %imsi+"'  "
                            "WHERE did = "+ "%d" %did)
                
            session.commit() 
            session.close()
        except Exception as ex:
            print(str(ex))
        
    @classmethod
    def insertDigiCellSignal(self, esn,signal):
        
        try:
            engine = self.createSoupDAO()
            now = int(time.time())
            
            # create a configured "Session" class
            Session = sessionmaker(bind=engine)
            
            # create a Session
            session = Session()
            
            session.execute("INSERT INTO sdm.cellsignal (esn,cellsignal,timestamp) VALUES "
                            "('"+"%s" %esn+"','"+"%s" %signal+"',"+"%d" %now+")")
            
            session.commit() 
            session.close()
        except Exception as ex:
            print(str(ex))
        
    @classmethod
    def querySerialByMac(self, mac):
        
        try:
            engine = self.createOssDAO()
            
            
            connection = engine.connect() 
            connection.begin()
            
            result = connection.execute(self.getSerialbyMac, value = mac).fetchall()
            
            connection.close()
        
        except Exception as ex:
            print(str(ex))
        
        return result[0][0]        
    
    @classmethod
    def queryEsnByMac(self, mac):
        
        try:
            engine = self.createOssDAO()
            
            
            connection = engine.connect() 
            connection.begin()
            
            result = connection.execute(self.getEsnbyMac, value = mac).fetchall()
            
            connection.close()
        except Exception as ex:
            print(str(ex))
        
        return result[0][0]
    
    @classmethod
    def setDisconnect(self,req):
        
        try:
            engine = self.createOssDAO()
            
            connection = engine.connect() 
            connection.begin()
        
            result = connection.execute(self.disconnectPacket , id=req['id']).fetchall()
            
            connection.close()
        except Exception as ex:
            print(str(ex))
            
        return result[0][0]
        