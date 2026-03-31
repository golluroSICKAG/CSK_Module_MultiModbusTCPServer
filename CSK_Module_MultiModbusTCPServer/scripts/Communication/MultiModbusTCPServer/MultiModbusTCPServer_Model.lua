---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find the module definition
-- including its parameters and functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
local nameOfModule = 'CSK_MultiModbusTCPServer'

-- Create kind of "class"
local multiModbusTCPServer = {}
multiModbusTCPServer.__index = multiModbusTCPServer

multiModbusTCPServer.styleForUI = 'None' -- Optional parameter to set UI style
multiModbusTCPServer.version = Engine.getCurrentAppVersion() -- Version of module

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to react on UI style change
local function handleOnStyleChanged(theme)
  multiModbusTCPServer.styleForUI = theme
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusCSKStyle", multiModbusTCPServer.styleForUI)
end
Script.register('CSK_PersistentData.OnNewStatusCSKStyle', handleOnStyleChanged)

--- Function to create new instance
---@param multiModbusTCPServerInstanceNo int Number of instance
---@return table[] self Instance of multiModbusTCPServer
function multiModbusTCPServer.create(multiModbusTCPServerInstanceNo)

  local self = {}
  setmetatable(self, multiModbusTCPServer)

  self.multiModbusTCPServerInstanceNo = multiModbusTCPServerInstanceNo -- Number of this instance
  self.multiModbusTCPServerInstanceNoString = tostring(self.multiModbusTCPServerInstanceNo) -- Number of this instance as string
  self.helperFuncs = require('Communication/MultiModbusTCPServer/helper/funcs') -- Load helper functions

  -- Create parameters etc. for this module instance
  self.activeInUI = false -- Check if this instance is currently active in UI

  -- Check if CSK_PersistentData module can be used if wanted
  self.persistentModuleAvailable = CSK_PersistentData ~= nil or false

  -- Check if CSK_UserManagement module can be used if wanted
  self.userManagementModuleAvailable = CSK_UserManagement ~= nil or false

  -- Default values for persistent data
  -- If available, following values will be updated from data of CSK_PersistentData module (check CSK_PersistentData module for this)
  self.parametersName = 'CSK_MultiModbusTCPServer_Parameter' .. self.multiModbusTCPServerInstanceNoString -- name of parameter dataset to be used for this module
  self.parameterLoadOnReboot = false -- Status if parameter dataset should be loaded on app/device reboot

  --self.currentConnectionStatus = false -- Status of Modbus TCP server connection

  self.log = {} -- Log of Modbus TCP communication

  self.availableInterfaces = Engine.getEnumValues("EthernetInterfaces") -- Available ethernet interfaces on device
  self.interfaceList = self.helperFuncs.createStringListBySimpleTable(self.availableInterfaces) -- List of ethernet interfaces

  self.tempDiscreteInputAddress = 0
  self.tempDiscreteInputRegisteredEvent = ''
  self.currentDiscreteInputSelection = ''
  self.tempDiscreteInputValue = false
  self.currentDiscreteInputValues = {} -- Table to track values of discrete input values

  self.tempCoilAddress = 0
  self.tempCoilRegisteredEvent = ''
  self.currentCoilSelection = ''
  self.tempCoilValue = false
  self.currentCoilValues = {} -- Table to track values of coil values

  --self.tempVarInputName = ''
  self.tempInputRegisterAddress = 0
  self.tempInputRegisterDataType = 'INT16'
  self.tempInputRegisteredEvent = ''
  self.currentInputRegisterSelection = ''
  self.tempInputRegisterValue = 0
  self.currentInputRegisterValues = {} -- Table to track values of input registers

  --self.tempVarHoldingName = ''
  self.tempHoldingRegisterAddress = 0
  self.tempHoldingRegisterDataType = 'INT16'
  self.tempHoldingRegisteredEvent = ''
  self.currentHoldingRegisterSelection = ''
  self.tempHoldingRegisterValue = 0
  self.currentHoldingRegisterValues = {} -- Table to track values of holding registers

  -- Parameters to be saved permanently if wanted
  self.parameters = {}
  self.parameters = self.helperFuncs.defaultParameters.getParameters() -- Load default parameters

  -- Instance specific parameters
  if self.availableInterfaces then
    self.parameters.interface = self.availableInterfaces[1] -- e.g. 'ETH1' -- Select first available ethernet interface per default
  else
    self.parameters.interface = ''
  end

  -- Parameters to give to the processing script
  self.multiModbusTCPServerProcessingParams = Container.create()
  self.multiModbusTCPServerProcessingParams:add('multiModbusTCPServerInstanceNumber', multiModbusTCPServerInstanceNo, "INT")

  self.multiModbusTCPServerProcessingParams:add('connectionStatus', self.parameters.connectionStatus, "BOOL")
  self.multiModbusTCPServerProcessingParams:add('interface', self.parameters.interface, "STRING")
  self.multiModbusTCPServerProcessingParams:add('port', self.parameters.port, "INT")

  self.multiModbusTCPServerProcessingParams:add('showLog', self.parameters.showLog, "BOOL")

  self.multiModbusTCPServerProcessingParams:add('maxConnections', self.parameters.maxConnections, "INT")
  self.multiModbusTCPServerProcessingParams:add('transmitTimeout', self.parameters.transmitTimeout, "INT")

  -- Handle processing
  Script.startScript(self.parameters.processingFile, self.multiModbusTCPServerProcessingParams)

  return self
end

return multiModbusTCPServer

--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************