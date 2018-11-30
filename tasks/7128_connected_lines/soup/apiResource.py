'''
Created on Dic 11, 2016

@author: juan felipe salazar
'''
from flask import Flask, request, jsonify
from facade.OperationFacade import *
from auditing.loggerModule import *
from flask import render_template
import pydevd,json
#from OpenSSL import SSL

app = Flask(__name__)

@app.route('/', methods = ["GET"])
def hello_world():
    return "Contour Hardwork API"

@app.route('/config_update', methods = ["POST"])
def portConfigUpdate():
    
    #pydevd.settrace('192.168.161.168', port=5678)    
    req = request.json
    setInfo("Serial:"+req['sn']+", Config:"+req['configName'],"Start the config update")
    
    try:
        result = setConfigUpdate(req)
       
        if result == 1:
            return str(1)
        elif result == 2:
            return str(2)
        else:
            return None
        
    except Exception as ex:
        setError("Serial:"+req['sn'],"There was an error"+str(ex))
        return str(ex)
    
@app.route('/firmware_update', methods = ["POST"])
def portFirmwareUpdate():
    
    #pydevd.settrace('192.168.161.168', port=5678)
    req = request.json
    setInfo("Serial:"+req['sn']+", Config:"+req['configName'],"Start the firmware update")
    
    try:
        result = setFirmwareUpdate(req)
        
        if result == 1:
            return str(1)
        elif result == 2:
            return str(2)
        else:
            return None    
        
    except Exception as ex:
        setError("Serial:"+req['sn'],"There was an error"+str(ex))
        return str(ex)
    
@app.route('/configInfo', methods = ["POST"])
def postConfigInformation():
    
    #pydevd.settrace('192.168.161.168', port=5678)
    req = request.json
    setInfo("MAC:"+req['mac'],"Start the config information.")
    try:
        result = setConfigInformation(req)
        return jsonify(response=result)     
        
    except Exception as ex:
        setError("MAC:"+req['mac'],"There was an error"+str(ex))
        return str(ex)

@app.route('/digiInfo', methods = ["POST"])
def postDigiInfo():
    
    #pydevd.settrace('192.168.161.168', port=5678)
    req = request.json
    setInfo("MAC:"+req['sn'],"Start the config information.")
    
    try:
        result = setDigiFirmware(req)
        return jsonify(response=result)     
        
    except Exception as ex:
        setError("MAC:"+req['mac'],"There was an error"+str(ex))
        return str(ex)
    
@app.route('/setInfo', methods = ["GET"])
def setDigiInfo():
    
    setInfo("Remote Manager","Start the config information.")
    #pydevd.settrace('10.17.242.104', port=5678)
    try:
        result = setDigiInformation() 
        return jsonify(response=result)     
        
    except Exception as ex:
        setError("Remote Manager","There was an error"+str(ex))
        return str(ex)
    
@app.route('/packetDisconnect', methods = ["POST"])
def postPacketDis():
    
    #pydevd.settrace('192.168.161.168', port=5678)
    req = request.json
    setInfo("Session ID:"+req['id'],"Start the config information.")
    
    try:
        result = setPacketDis(req)
        return jsonify(response=result)     
        
    except Exception as ex:
        setError("Session ID:"+req['id'],"There was an error"+str(ex))
        return str(ex)
    
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=12000,debug=None)
    #app.run(host='0.0.0.0')
    #app.debug = True
    #run(host=None, port=None, debug=None, **options)
    #app.run()
    #app.run(debug=True)
    #app.run(host='0.0.0.0', debug=True, ssl_context=context)
