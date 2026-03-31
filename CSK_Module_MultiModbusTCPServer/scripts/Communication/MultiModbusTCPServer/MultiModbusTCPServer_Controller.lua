---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--***************************************************************
-- Inside of this script, you will find the necessary functions,
-- variables and events to communicate with the MultiModbusTCPServer_Model and _Instances
--***************************************************************

--**************************************************************************
--************************ Start Global Scope ******************************
--**************************************************************************
local nameOfModule = 'CSK_MultiModbusTCPServer'

local funcs = {}

-- Timer to update UI via events after page was loaded
local tmrMultiModbusTCPServer = Timer.create()
tmrMultiModbusTCPServer:setExpirationTime(300)
tmrMultiModbusTCPServer:setPeriodic(false)

local multiModbusTCPServer_Model -- Reference to model handle
local multiModbusTCPServer_Instances -- Reference to instances handle
local selectedInstance = 1 -- Which instance is currently selected
local helperFuncs = require('Communication/MultiModbusTCPServer/helper/funcs')

-- ************************ UI Events Start ********************************
-- Only to prevent WARNING messages, but these are only examples/placeholders for dynamically created events/functions
----------------------------------------------------------------
local function emptyFunction()
end

Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueToForwardNUM", "MultiModbusTCPServer_OnNewValueToForwardNUM")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueUpdateNUM", "MultiModbusTCPServer_OnNewValueUpdateNUM")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewUpdateNUM_TYPE_ADDRESS", "MultiModbusTCPServer_OnNewUpdateNUM_TYPE_ADDRESS")
----------------------------------------------------------------

-- Real events
--------------------------------------------------
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewLog', 'MultiModbusTCPServer_OnNewLog')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusModuleVersion', 'MultiModbusTCPServer_OnNewStatusModuleVersion')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusCSKStyle', 'MultiModbusTCPServer_OnNewStatusCSKStyle')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusModuleIsActive', 'MultiModbusTCPServer_OnNewStatusModuleIsActive')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusServerActive', 'MultiModbusTCPServer_OnNewStatusServerActive')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusServerPort', 'MultiModbusTCPServer_OnNewStatusServerPort')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusInterfaceList', 'MultiModbusTCPServer_OnNewStatusInterfaceList')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusSelectedInterface', 'MultiModbusTCPServer_OnNewStatusSelectedInterface')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusShowLog', 'MultiModbusTCPServer_OnNewStatusShowLog')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempDiscreteInputAddress', 'MultiModbusTCPServer_OnNewStatusTempDiscreteInputAddress')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempDiscreteInputRegisteredEvent', 'MultiModbusTCPServer_OnNewStatusTempDiscreteInputRegisteredEvent')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusDiscreteInputStatusToSet', 'MultiModbusTCPServer_OnNewStatusDiscreteInputStatusToSet')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempCoilAddress', 'MultiModbusTCPServer_OnNewStatusTempCoilAddress')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempCoilRegisteredEvent', 'MultiModbusTCPServer_OnNewStatusTempCoilRegisteredEvent')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusCoilStatusToSet', 'MultiModbusTCPServer_OnNewStatusCoilStatusToSet')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempInputRegisterAddress', 'MultiModbusTCPServer_OnNewStatusTempInputRegisterAddress')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempInputRegisterDataType', 'MultiModbusTCPServer_OnNewStatusTempInputRegisterDataType')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempInputRegisterEvent', 'MultiModbusTCPServer_OnNewStatusTempInputRegisterEvent')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusInputRegisterValueToSet', 'MultiModbusTCPServer_OnNewStatusInputRegisterValueToSet')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempHoldingRegisterAddress', 'MultiModbusTCPServer_OnNewStatusTempHoldingRegisterAddress')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempHoldingRegisterDataType', 'MultiModbusTCPServer_OnNewStatusTempHoldingRegisterDataType')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempHoldingRegisterEvent', 'MultiModbusTCPServer_OnNewStatusTempHoldingRegisterEvent')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusHoldingRegisterValueToSet', 'MultiModbusTCPServer_OnNewStatusHoldingRegisterValueToSet')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusListOfCoils', 'MultiModbusTCPServer_OnNewStatusListOfCoils')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusListOfDiscreteInputs', 'MultiModbusTCPServer_OnNewStatusListOfDiscreteInputs')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusListOfInputRegisters', 'MultiModbusTCPServer_OnNewStatusListOfInputRegisters')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusListOfHoldingRegisters', 'MultiModbusTCPServer_OnNewStatusListOfHoldingRegisters')

Script.serveEvent("CSK_MultiModbusTCPServer.OnNewStatusLoadParameterOnReboot", "MultiModbusTCPServer_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_MultiModbusTCPServer.OnPersistentDataModuleAvailable", "MultiModbusTCPServer_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewParameterName", "MultiModbusTCPServer_OnNewParameterName")

Script.serveEvent("CSK_MultiModbusTCPServer.OnNewInstanceList", "MultiModbusTCPServer_OnNewInstanceList")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewProcessingParameter", "MultiModbusTCPServer_OnNewProcessingParameter")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewSelectedInstance", "MultiModbusTCPServer_OnNewSelectedInstance")
Script.serveEvent("CSK_MultiModbusTCPServer.OnDataLoadedOnReboot", "MultiModbusTCPServer_OnDataLoadedOnReboot")

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusFlowConfigPriority', 'MultiModbusTCPServer_OnNewStatusFlowConfigPriority')
Script.serveEvent("CSK_MultiModbusTCPServer.OnUserLevelOperatorActive", "MultiModbusTCPServer_OnUserLevelOperatorActive")
Script.serveEvent("CSK_MultiModbusTCPServer.OnUserLevelMaintenanceActive", "MultiModbusTCPServer_OnUserLevelMaintenanceActive")
Script.serveEvent("CSK_MultiModbusTCPServer.OnUserLevelServiceActive", "MultiModbusTCPServer_OnUserLevelServiceActive")
Script.serveEvent("CSK_MultiModbusTCPServer.OnUserLevelAdminActive", "MultiModbusTCPServer_OnUserLevelAdminActive")

-- ************************ UI Events End **********************************

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

-- Functions to forward logged in user roles via CSK_UserManagement module (if available)
-- ***********************************************
--- Function to react on status change of Operator user level
---@param status boolean Status if Operator level is active
local function handleOnUserLevelOperatorActive(status)
  Script.notifyEvent("MultiModbusTCPServer_OnUserLevelOperatorActive", status)
end

--- Function to react on status change of Maintenance user level
---@param status boolean Status if Maintenance level is active
local function handleOnUserLevelMaintenanceActive(status)
  Script.notifyEvent("MultiModbusTCPServer_OnUserLevelMaintenanceActive", status)
end

--- Function to react on status change of Service user level
---@param status boolean Status if Service level is active
local function handleOnUserLevelServiceActive(status)
  Script.notifyEvent("MultiModbusTCPServer_OnUserLevelServiceActive", status)
end

--- Function to react on status change of Admin user level
---@param status boolean Status if Admin level is active
local function handleOnUserLevelAdminActive(status)
  Script.notifyEvent("MultiModbusTCPServer_OnUserLevelAdminActive", status)
end
-- ***********************************************

--- Function to forward data updates from instance threads to Controller part of module
---@param eventname string Eventname to use to forward value
---@param value auto Value to forward
local function handleOnNewValueToForward(eventname, value)
  Script.notifyEvent(eventname, value)
end

--- Optionally: Only use if needed for extra internal objects -  see also Model
--- Function to sync paramters between instance threads and Controller part of module
---@param instance int Instance new value is coming from
---@param parameter string Name of the paramter to update/sync
---@param value auto[?*] Value to update
---@param valueB auto[?*] Optional value
local function handleOnNewValueUpdate(instance, parameter, value, valueB)
  if parameter == 'UpdateInputRegister' then
    for key, val in pairs(value) do
      multiModbusTCPServer_Instances[instance].currentInputRegisterValues['Address_'..tostring(val)] = valueB[key]
    end
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[instance].parameters.listOfInputRegisters, multiModbusTCPServer_Instances[instance].currentInputRegisterSelection, 'INPUT_REGISTER', multiModbusTCPServer_Instances[instance].currentInputRegisterValues))

  elseif parameter == 'UpdateHoldingRegister' then
    for key, val in pairs(value) do
      multiModbusTCPServer_Instances[instance].currentHoldingRegisterValues['Address_'..tostring(val)] = valueB[key]
    end
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[instance].parameters.listOfHoldingRegisters, multiModbusTCPServer_Instances[instance].currentHoldingRegisterSelection, 'HOLDING_REGISTER', multiModbusTCPServer_Instances[instance].currentHoldingRegisterValues))

  elseif parameter == 'UpdateDiscreteInputs' then
    for key, val in pairs(value) do
      multiModbusTCPServer_Instances[instance].currentDiscreteInputValues['Address_'..tostring(val)] = valueB[key]
    end
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfDiscreteInputs', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[instance].parameters.listOfDiscreteInputs, multiModbusTCPServer_Instances[instance].currentDiscreteInputSelection, 'DISCRETE_INPUT', multiModbusTCPServer_Instances[instance].currentDiscreteInputValues))

  elseif parameter == 'UpdateCoils' then
    for key, val in pairs(value) do
      multiModbusTCPServer_Instances[instance].currentCoilValues['Address_'..tostring(val)] = valueB[key]
    end
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfCoils', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[instance].parameters.listOfCoils, multiModbusTCPServer_Instances[instance].currentCoilSelection, 'COIL', multiModbusTCPServer_Instances[instance].currentCoilValues))
  else
    multiModbusTCPServer_Instances[instance].parameters[parameter] = value
  end
end

--- Function to get access to the multiModbusTCPServer_Model object
---@param handle handle Handle of multiModbusTCPServer_Model object
local function setMultiModbusTCPServer_Model_Handle(handle)
  multiModbusTCPServer_Model = handle
  Script.releaseObject(handle)
end
funcs.setMultiModbusTCPServer_Model_Handle = setMultiModbusTCPServer_Model_Handle

--- Function to get access to the multiModbusTCPServer_Instances object
---@param handle handle Handle of multiModbusTCPServer_Instances object
local function setMultiModbusTCPServer_Instances_Handle(handle)
  multiModbusTCPServer_Instances = handle
  if multiModbusTCPServer_Instances[selectedInstance].userManagementModuleAvailable then
    -- Register on events of CSK_UserManagement module if available
    Script.register('CSK_UserManagement.OnUserLevelOperatorActive', handleOnUserLevelOperatorActive)
    Script.register('CSK_UserManagement.OnUserLevelMaintenanceActive', handleOnUserLevelMaintenanceActive)
    Script.register('CSK_UserManagement.OnUserLevelServiceActive', handleOnUserLevelServiceActive)
    Script.register('CSK_UserManagement.OnUserLevelAdminActive', handleOnUserLevelAdminActive)
  end
  Script.releaseObject(handle)

  for i = 1, #multiModbusTCPServer_Instances do
    Script.register("CSK_MultiModbusTCPServer.OnNewValueToForward" .. tostring(i) , handleOnNewValueToForward)
  end

  for i = 1, #multiModbusTCPServer_Instances do
    Script.register("CSK_MultiModbusTCPServer.OnNewValueUpdate" .. tostring(i) , handleOnNewValueUpdate)
  end

end
funcs.setMultiModbusTCPServer_Instances_Handle = setMultiModbusTCPServer_Instances_Handle

--- Function to update user levels
local function updateUserLevel()
  if multiModbusTCPServer_Instances[selectedInstance].userManagementModuleAvailable then
    -- Trigger CSK_UserManagement module to provide events regarding user role
    CSK_UserManagement.pageCalled()
  else
    -- If CSK_UserManagement is not active, show everything
    Script.notifyEvent("MultiModbusTCPServer_OnUserLevelAdminActive", true)
    Script.notifyEvent("MultiModbusTCPServer_OnUserLevelMaintenanceActive", true)
    Script.notifyEvent("MultiModbusTCPServer_OnUserLevelServiceActive", true)
    Script.notifyEvent("MultiModbusTCPServer_OnUserLevelOperatorActive", true)
  end
end

--- Function to send all relevant values to UI on resume
local function handleOnExpiredTmrMultiModbusTCPServer()

  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusModuleVersion", 'v' .. multiModbusTCPServer_Model.version)
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusCSKStyle", multiModbusTCPServer_Model.styleForUI)
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusModuleIsActive", _G.availableAPIs.default and _G.availableAPIs.specific)

  if _G.availableAPIs.default and _G.availableAPIs.specific then

    updateUserLevel()

    Script.notifyEvent('MultiModbusTCPServer_OnNewSelectedInstance', selectedInstance)
    Script.notifyEvent("MultiModbusTCPServer_OnNewInstanceList", helperFuncs.createStringListBySize(#multiModbusTCPServer_Instances))

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusServerActive", multiModbusTCPServer_Instances[selectedInstance].parameters.connectionStatus)

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusServerPort", multiModbusTCPServer_Instances[selectedInstance].parameters.port)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusInterfaceList", multiModbusTCPServer_Instances[selectedInstance].interfaceList)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusSelectedInterface", multiModbusTCPServer_Instances[selectedInstance].parameters.interface)

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusShowLog", multiModbusTCPServer_Instances[selectedInstance].parameters.showLog)

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempDiscreteInputAddress", multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputAddress)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempDiscreteInputRegisteredEvent", multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputRegisteredEvent)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusDiscreteInputStatusToSet", multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputValue)

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempCoilAddress", multiModbusTCPServer_Instances[selectedInstance].tempCoilAddress)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempCoilRegisteredEvent", multiModbusTCPServer_Instances[selectedInstance].tempCoilRegisteredEvent)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusCoilStatusToSet", multiModbusTCPServer_Instances[selectedInstance].tempCoilValue)

    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfDiscreteInputs', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs, multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection, 'DISCRETE_INPUT', multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues))
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfCoils', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils, multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection, 'COIL', multiModbusTCPServer_Instances[selectedInstance].currentCoilValues))
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters, multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection, 'INPUT_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues))
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters, multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection, 'HOLDING_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues))

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempInputRegisterAddress", multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterAddress)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempInputRegisterDataType", multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterDataType)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempInputRegisterEvent", multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusInputRegisterValueToSet", multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterValue)

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempHoldingRegisterAddress", multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterAddress)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempHoldingRegisterDataType", multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterDataType)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempHoldingRegisterEvent", multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusHoldingRegisterValueToSet", multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterValue)

    multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
    multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusFlowConfigPriority", multiModbusTCPServer_Instances[selectedInstance].parameters.flowConfigPriority)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusLoadParameterOnReboot", multiModbusTCPServer_Instances[selectedInstance].parameterLoadOnReboot)
    Script.notifyEvent("MultiModbusTCPServer_OnPersistentDataModuleAvailable", multiModbusTCPServer_Instances[selectedInstance].persistentModuleAvailable)
    Script.notifyEvent("MultiModbusTCPServer_OnNewParameterName", multiModbusTCPServer_Instances[selectedInstance].parametersName)
  end
end
Timer.register(tmrMultiModbusTCPServer, "OnExpired", handleOnExpiredTmrMultiModbusTCPServer)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    updateUserLevel() -- try to hide user specific content asap
  end
  tmrMultiModbusTCPServer:start()
  return ''
end
Script.serveFunction("CSK_MultiModbusTCPServer.pageCalled", pageCalled)

local function setServerPort(port)
  _G.logger:info(nameOfModule .. ": Set port of ModbusTCP server to " .. tostring(port))
  multiModbusTCPServer_Instances[selectedInstance].parameters.port = port
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'port', port)
end
Script.serveFunction('CSK_MultiModbusTCPServer.setServerPort', setServerPort)

local function setServerInterface(interface)
  _G.logger:info(nameOfModule .. ": Set interface of ModbusTCP server to " .. tostring(interface))
  multiModbusTCPServer_Instances[selectedInstance].parameters.interface = interface
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'interface', interface)
end
Script.serveFunction('CSK_MultiModbusTCPServer.setServerInterface', setServerInterface)

local function startServer()
  _G.logger:info(nameOfModule .. ": Start ModbusTCP server.")
  multiModbusTCPServer_Instances[selectedInstance].parameters.connectionStatus = true
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'start')
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusServerActive", multiModbusTCPServer_Instances[selectedInstance].parameters.connectionStatus)
end

local function stopServer()
  _G.logger:info(nameOfModule .. ": Stop ModbusTCP server.")
  multiModbusTCPServer_Instances[selectedInstance].parameters.connectionStatus = false
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'stop')
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusServerActive", multiModbusTCPServer_Instances[selectedInstance].parameters.connectionStatus)
end

local function setStatusOfServer(status)
  if status then
    startServer()
  else
    stopServer()
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setStatusOfServer', setStatusOfServer)

local function setShowLog(status)
  _G.logger:fine(nameOfModule .. ": Set showLog status to = " .. tostring(status))
  multiModbusTCPServer_Instances[selectedInstance].parameters.showLog = status
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'showLog', status)
end
Script.serveFunction('CSK_MultiModbusTCPServer.setShowLog', setShowLog)

local function setDiscreteInputTableSelection(selection)
  if selection == "" then
    multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = ''
    _G.logger:info(nameOfModule .. ": Did not find register. Is empty")
  else
    local _, pos = string.find(selection, '"DTC_DiscreteInput_Address":"')
    if pos == nil then
      _G.logger:info(nameOfModule .. ": Did not find register. Is nil")
      multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = ''
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local newSelection = string.sub(selection, pos+1, endPos-1)
      if newSelection == multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection then
        multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = ''
      else
        if (newSelection == nil or newSelection == "" ) then
          _G.logger:info(nameOfModule .. ": Did not find register. Is empty or nil")
          multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = ''
        else
          multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = newSelection
          _G.logger:fine(nameOfModule .. ": Selected input register address: " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection))
        end
      end
    end
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfDiscreteInputs', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs, multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection, 'DISCRETE_INPUT', multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues))
end
Script.serveFunction('CSK_MultiModbusTCPServer.setDiscreteInputTableSelection', setDiscreteInputTableSelection)

local function setCoilTableSelection(selection)
  if selection == "" then
    multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = ''
    _G.logger:info(nameOfModule .. ": Did not find register. Is empty")
  else
    local _, pos = string.find(selection, '"DTC_Coil_Address":"')
    if pos == nil then
      _G.logger:info(nameOfModule .. ": Did not find register. Is nil")
      multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = ''
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local newSelection = string.sub(selection, pos+1, endPos-1)
      if newSelection == multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection then
        multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = ''
      else
        if (newSelection == nil or newSelection == "" ) then
          _G.logger:info(nameOfModule .. ": Did not find register. Is empty or nil")
          multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = ''
        else
          multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = newSelection
          _G.logger:fine(nameOfModule .. ": Selected coil address: " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection))
        end
      end
    end
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfCoils', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils, multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection, 'COIL', multiModbusTCPServer_Instances[selectedInstance].currentCoilValues))
end
Script.serveFunction('CSK_MultiModbusTCPServer.setCoilTableSelection', setCoilTableSelection)

local function setInputRegisterTableSelection(selection)
  if selection == "" then
    multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
    _G.logger:info(nameOfModule .. ": Did not find register. Is empty")
  else
    local _, pos = string.find(selection, '"DTC_InputRegister_Address":"')
    if pos == nil then
      _G.logger:info(nameOfModule .. ": Did not find register. Is nil")
      multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local newSelection = string.sub(selection, pos+1, endPos-1)
      if newSelection == multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection then
        multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
      else
        if (newSelection == nil or newSelection == "" ) then
          _G.logger:info(nameOfModule .. ": Did not find register. Is empty or nil")
          multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
        else
          multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = newSelection
          _G.logger:fine(nameOfModule .. ": Selected input register address: " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection))
        end
      end
    end
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters, multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection, 'INPUT_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues))
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputRegisterTableSelection', setInputRegisterTableSelection)

local function setHoldingRegisterTableSelection(selection)
  if selection == "" then
    multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''
    _G.logger:info(nameOfModule .. ": Did not find register. Is empty")
  else
    local _, pos = string.find(selection, '"DTC_HoldingRegister_Address":"')
    if pos == nil then
      _G.logger:info(nameOfModule .. ": Did not find register. Is nil")
      multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local newSelection = string.sub(selection, pos+1, endPos-1)
      if newSelection == multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection then
        multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''
      else
        if (newSelection == nil or newSelection == "" ) then
          _G.logger:info(nameOfModule .. ": Did not find register. Is empty or nil")
          multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''
        else
          multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = newSelection
          _G.logger:fine(nameOfModule .. ": Selected holding register address: " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection))
        end
      end
    end
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters, multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection, 'HOLDING_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues))
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingRegisterTableSelection', setHoldingRegisterTableSelection)

local function addRegister(regType, address, eventName, dataType, noEventUpdate)
  if noEventUpdate == nil then
    noEventUpdate = false
  end
  multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = ''
  multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = ''

  multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
  multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''

  if regType == 'COIL' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address['Address_'..tostring(address)] and noEventUpdate ~= true then
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName)
    else
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address['Address_'..tostring(address)] = address
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', regType, address, eventName, 'BOOL')
    end
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.event['Address_'..tostring(address)] = eventName
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfCoils', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils, multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection, 'COIL', multiModbusTCPServer_Instances[selectedInstance].currentCoilValues))

  elseif regType == 'DISCRETE_INPUT' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address['Address_'..tostring(address)] and noEventUpdate ~= true then
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName)
    else
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address['Address_'..tostring(address)] = address
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', regType, address, eventName, 'BOOL')
    end
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.event['Address_'..tostring(address)] = eventName
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfDiscreteInputs', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs, multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection, 'DISCRETE_INPUT', multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues))

  elseif regType == 'INPUT_REGISTER' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address['Address_'..tostring(address)] and noEventUpdate ~= true then
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName, dataType)
    else
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address['Address_'..tostring(address)] = address
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', regType, address, eventName, dataType)
    end
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.event['Address_'..tostring(address)] = eventName
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.dataType['Address_'..tostring(address)] = dataType
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters, multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection, 'INPUT_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues))

  elseif regType == 'HOLDING_REGISTER' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address['Address_'..tostring(address)] and noEventUpdate ~= true then
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName, dataType)
    else
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address['Address_'..tostring(address)] = address
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', regType, address, eventName, dataType)
    end
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.event['Address_'..tostring(address)] = eventName
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.dataType['Address_'..tostring(address)] = dataType
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters, multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection, 'HOLDING_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues))

  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.addRegister', addRegister)

local function setDiscreteInputAddress(address)
  multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputAddress = address
end
Script.serveFunction('CSK_MultiModbusTCPServer.setDiscreteInputAddress', setDiscreteInputAddress)

local function setDiscreteInputRegisteredEvent(event)
  multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputRegisteredEvent = event
end
Script.serveFunction('CSK_MultiModbusTCPServer.setDiscreteInputRegisteredEvent', setDiscreteInputRegisteredEvent)

local function setCoilAddress(address)
  multiModbusTCPServer_Instances[selectedInstance].tempCoilAddress = address
end
Script.serveFunction('CSK_MultiModbusTCPServer.setCoilAddress', setCoilAddress)

local function setCoilRegisteredEvent(event)
  multiModbusTCPServer_Instances[selectedInstance].tempCoilRegisteredEvent = event
end
Script.serveFunction('CSK_MultiModbusTCPServer.setCoilRegisteredEvent', setCoilRegisteredEvent)

local function addDiscreteInputViaUI()
  addRegister('DISCRETE_INPUT', multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputAddress, multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputRegisteredEvent, 'BOOL')
end
Script.serveFunction('CSK_MultiModbusTCPServer.addDiscreteInputViaUI', addDiscreteInputViaUI)

local function addCoilViaUI()
  addRegister('COIL', multiModbusTCPServer_Instances[selectedInstance].tempCoilAddress, multiModbusTCPServer_Instances[selectedInstance].tempCoilRegisteredEvent, 'BOOL')
end
Script.serveFunction('CSK_MultiModbusTCPServer.addCoilViaUI', addCoilViaUI)

local function addInputRegisterViaUI()
  addRegister('INPUT_REGISTER', multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterAddress, multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent, multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterDataType)
end
Script.serveFunction('CSK_MultiModbusTCPServer.addInputRegisterViaUI', addInputRegisterViaUI)

local function addHoldingRegisterViaUI()
  addRegister('HOLDING_REGISTER', multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterAddress, multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent, multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterDataType)
end
Script.serveFunction('CSK_MultiModbusTCPServer.addHoldingRegisterViaUI', addHoldingRegisterViaUI)

local function removeDiscreteInput(address)
  local id = ''
  for _, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address) do
    if tostring(value) == address then
      id = value
      break
    end
  end
  if id ~= '' then
    --Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address[id], 'DISCRETE_INPUT', id)
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', 'DISCRETE_INPUT', id)

    multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues['Address_'..id] = nil
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address['Address_'..id] = nil
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.event['Address_'..id] = nil

    multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection = ''
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfDiscreteInputs', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs, multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection, 'DISCRETE_INPUT', multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues))
  else
    _G.logger:info(nameOfModule .. ": Discrete input address" .. tostring(address) .. " does not exist.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeDiscreteInput', removeDiscreteInput)

local function removeDiscreteInputViaUI()
  if multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection ~= nil and multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection ~= '' then
    removeDiscreteInput(multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection)
  else
    _G.logger:info(nameOfModule .. ": No discrete input selection.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeDiscreteInputViaUI', removeDiscreteInputViaUI)

local function removeCoil(address)
  local id = ''
  for _, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address) do
    if tostring(value) == address then
      id = value
      break
    end
  end
  if id ~= '' then
    --Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address[id], 'COIL', id)
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', 'COIL', id)

      multiModbusTCPServer_Instances[selectedInstance].currentCoilValues['Address_'..id] = nil
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address['Address_'..id] = nil
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.event['Address_'..id] = nil

      multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection = ''
      Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfCoils', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils, multiModbusTCPServer_Instances[selectedInstance].listOfCoils, 'COIL', multiModbusTCPServer_Instances[selectedInstance].currentCoilValues))
  else
    _G.logger:info(nameOfModule .. ": Coil address" .. tostring(address) .. " does not exist.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeCoil', removeCoil)

local function removeCoilViaUI()
  if multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection ~= nil and multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection ~= '' then
    removeCoil(multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection)
  else
    _G.logger:info(nameOfModule .. ": No coil selection.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeCoilViaUI', removeCoilViaUI)

local function removeInputRegister(address)
  local id = ''
  for _, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address) do
    if tostring(value) == address then
      id = value
      break
    end
  end
  if id ~= '' then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', 'INPUT_REGISTER', id)

      multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues['Address_'..id] = nil
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address['Address_'..id] = nil
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.dataType['Address_'..id] = nil
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.event['Address_'..id] = nil

      multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection = ''
      Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters, multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection, 'INPUT_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues))
  else
    _G.logger:info(nameOfModule .. ": Input register address" .. tostring(address) .. " does not exist.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeInputRegister', removeInputRegister)

local function removeInputRegisterViaUI()
  if multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection ~= nil and multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection ~= '' then
    removeInputRegister(multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection)
  else
    _G.logger:info(nameOfModule .. ": No input register selection.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeInputRegisterViaUI', removeInputRegisterViaUI)

local function setInputRegisterAddress(address)
  _G.logger:fine(nameOfModule .. ": Set temp address of new input register to = " .. tostring(address))
  multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterAddress = address
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputRegisterAddress', setInputRegisterAddress)

local function setInputRegisterDataType(dataType)
  _G.logger:fine(nameOfModule .. ": Set dataType of new input register to = " .. tostring(dataType) .. ' Byte')
  multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterDataType = dataType
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputRegisterDataType', setInputRegisterDataType)

local function setInputRegisterEvent(event)
  _G.logger:fine(nameOfModule .. ": Set event to register new input register to = " .. tostring(event))
  multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent = event
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputRegisterEvent', setInputRegisterEvent)

local function removeHoldingRegister(address)
  local id = ''
  for _, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address) do
    if tostring(value) == address then
      id = value
      break
    end
  end
  if id ~= '' then
    --Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address[id], 'HOLDING_REGISTER', id)
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeRegister', 'HOLDING_REGISTER', id)

    multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues['Address_'..id] = nil
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address['Address_'..id] = nil
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.dataType['Address_'..id] = nil
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.event['Address_'..id] = nil

    multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection = ''
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingRegisters', helperFuncs.createJsonListRegisters(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters, multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection, 'HOLDING_REGISTER', multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues))
  else
    _G.logger:info(nameOfModule .. ": Holding register address" .. tostring(address) .. " does not exist.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeHoldingRegister', removeHoldingRegister)

local function removeHoldingRegisterViaUI()
  if multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection ~= nil and multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection ~= '' then
    removeHoldingRegister(multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection)
  else
    _G.logger:info(nameOfModule .. ": No holding register selection")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeHoldingRegisterViaUI', removeHoldingRegisterViaUI)

local function setHoldingRegisterAddress(address)
  _G.logger:fine(nameOfModule .. ": Set temp address of new holding register to = " .. tostring(address))
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterAddress = address
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingRegisterAddress', setHoldingRegisterAddress)

local function setHoldingRegisterDataType(dataType)
  _G.logger:fine(nameOfModule .. ": Set dataType of new holding register to = " .. tostring(dataType))
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterDataType = dataType
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingRegisterDataType', setHoldingRegisterDataType)

local function setHoldingRegisterEvent(event)
  _G.logger:fine(nameOfModule .. ": Set event to register new holding register to = " .. tostring(event))
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent = event
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingRegisterEvent', setHoldingRegisterEvent)

local function setRegisterValue(instance, regType, address, value)
  if regType == 'DISCRETE_INPUT' then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', instance, 'setDiscreteInputValue', address, value)
  elseif regType == 'COIL' then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', instance, 'setCoilValue', address, value)
  elseif regType == 'INPUT_REGISTER' then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', instance, 'setInputValue', address, value)
  elseif regType == 'HOLDING_REGISTER' then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', instance, 'setHoldingValue', address, value)
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setRegisterValue', setRegisterValue)

local function setCoilStatusViaUI(status)
  multiModbusTCPServer_Instances[selectedInstance].tempCoilValue = status
  if multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection ~= '' then
    _G.logger:fine(nameOfModule .. ": Set status of discrete input at address" .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection) .. " of instance " .. tostring(selectedInstance) .. " to = " .. tostring(multiModbusTCPServer_Instances[selectedInstance].tempCoilValue))
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'setCoilValue', multiModbusTCPServer_Instances[selectedInstance].currentCoilSelection, multiModbusTCPServer_Instances[selectedInstance].tempCoilValue)
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setCoilStatusViaUI', setCoilStatusViaUI)

local function setDiscreteInputStatusViaUI(status)
  multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputValue = status
  if multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection ~= '' then
    _G.logger:fine(nameOfModule .. ": Set status of discrete input at address" .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection) .. " of instance " .. tostring(selectedInstance) .. " to = " .. tostring(multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputValue))
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'setDiscreteInputValue', multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputSelection, multiModbusTCPServer_Instances[selectedInstance].tempDiscreteInputValue)
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setDiscreteInputStatusViaUI', setDiscreteInputStatusViaUI)

local function setInputRegisterValueViaUI(value)
  multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterValue = value
  if multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection ~= '' then
    _G.logger:fine(nameOfModule .. ": Set value of input register at address" .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection) .. " of instance " .. tostring(selectedInstance) .. " to = " .. tostring(multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterValue))
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'setInputValue', multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterSelection, multiModbusTCPServer_Instances[selectedInstance].tempInputRegisterValue)
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputRegisterValueViaUI', setInputRegisterValueViaUI)

local function setHoldingRegisterValueViaUI(value)
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterValue = value
  if multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection ~= '' then
    _G.logger:fine(nameOfModule .. ": Set value of holding register at address " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection) .. " of instance " .. tostring(selectedInstance) .. " to = " .. tostring(multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterValue))
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'setHoldingValue', multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterSelection, multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisterValue)
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingRegisterValueViaUI', setHoldingRegisterValueViaUI)

local function setRegisteredEventOfRegister(regType, address, eventName, dataType)
  if regType == 'DISCRETE_INPUT' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address['Address_'..address] then
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.event['Address_'..inputID] = eventName
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName)
    else
      addRegister(regType, address, eventName, 'BOOL')
    end
  elseif regType == 'COIL' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address['Address_'..address] then
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.event['Address_'..inputID] = eventName
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName)
    else
      addRegister(regType, address, eventName, 'BOOL')
    end
  elseif regType == 'INPUT_REGISTER' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address['Address_'..address] then
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.event['Address_'..inputID] = eventName
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.dataType['Address_' .. inputID] = dataType
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName, dataType)
    else
      addRegister(regType, address, eventName, dataType)
    end
  elseif regType == 'HOLDING_REGISTER' then
    if multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address['Address_'..address] then
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.event['Address_'..inputID] = eventName
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.dataType['Address_' .. inputID] = dataType
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', regType, address, eventName, dataType)
    else
      addRegister(regType, address, eventName, dataType)
    end
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setRegisteredEventOfRegister', setRegisteredEventOfRegister)

local function setSelectedInstance(instance)
  if #multiModbusTCPServer_Instances >= instance then
    selectedInstance = instance
    _G.logger:fine(nameOfModule .. ": New selected instance = " .. tostring(selectedInstance))
    multiModbusTCPServer_Instances[selectedInstance].activeInUI = true
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)
    tmrMultiModbusTCPServer:start()
  else
    _G.logger:warning(nameOfModule .. ": Selected instance does not exist.")
  end
end
Script.serveFunction("CSK_MultiModbusTCPServer.setSelectedInstance", setSelectedInstance)

local function getInstancesAmount ()
  if multiModbusTCPServer_Instances then
    return #multiModbusTCPServer_Instances
  else
    return 0
  end
end
Script.serveFunction("CSK_MultiModbusTCPServer.getInstancesAmount", getInstancesAmount)

local function addInstance()
  _G.logger:fine(nameOfModule .. ": Add instance")
  table.insert(multiModbusTCPServer_Instances, multiModbusTCPServer_Model.create(#multiModbusTCPServer_Instances+1))
  Script.deregister("CSK_MultiModbusTCPServer.OnNewValueToForward" .. tostring(#multiModbusTCPServer_Instances) , handleOnNewValueToForward)
  Script.register("CSK_MultiModbusTCPServer.OnNewValueToForward" .. tostring(#multiModbusTCPServer_Instances) , handleOnNewValueToForward)
  handleOnExpiredTmrMultiModbusTCPServer()
end
Script.serveFunction('CSK_MultiModbusTCPServer.addInstance', addInstance)

local function resetInstances()
  _G.logger:info(nameOfModule .. ": Reset instances.")
  setSelectedInstance(1)
  local totalAmount = #multiModbusTCPServer_Instances
  while totalAmount > 1 do
    Script.releaseObject(multiModbusTCPServer_Instances[totalAmount])
    multiModbusTCPServer_Instances[totalAmount] =  nil
    totalAmount = totalAmount - 1
  end
  handleOnExpiredTmrMultiModbusTCPServer()
end
Script.serveFunction('CSK_MultiModbusTCPServer.resetInstances', resetInstances)

--- Function to share process relevant configuration with processing threads
local function updateProcessingParameters()
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'showLog', multiModbusTCPServer_Instances[selectedInstance].parameters.showLog)

  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeAllRegisters')
  setServerPort(multiModbusTCPServer_Instances[selectedInstance].parameters.port)
  setServerInterface(multiModbusTCPServer_Instances[selectedInstance].parameters.interface)

  for key, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address) do
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', 'COIL', value, multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.event['Address_' .. tostring(value)], 'BOOL')
  end
  for key, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address) do
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', 'DISCRETE_INPUT', value, multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.event['Address_' .. tostring(value)], 'BOOL')
  end
  for key, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address) do
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', 'INPUT_REGISTER', value, multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.event['Address_' .. tostring(value)], multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.dataType['Address_' .. tostring(value)])
  end
  for key, value in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address) do
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addRegister', 'HOLDING_REGISTER', value, multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.event['Address_' .. tostring(value)], multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.dataType['Address_' .. tostring(value)])
  end
end

local function getStatusModuleActive()
  return _G.availableAPIs.default and _G.availableAPIs.specific
end
Script.serveFunction('CSK_MultiModbusTCPServer.getStatusModuleActive', getStatusModuleActive)

local function clearFlowConfigRelevantConfiguration()
  for i = 1, #multiModbusTCPServer_Instances do
    if multiModbusTCPServer_Instances[i].parameters.flowConfigPriority then
      multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentCoilValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.dataType = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.dataType = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.event = {}

      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeAllRegisters')
    end
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.clearFlowConfigRelevantConfiguration', clearFlowConfigRelevantConfiguration)

local function getParameters(instanceNo)
  if instanceNo <= #multiModbusTCPServer_Instances then
    return helperFuncs.json.encode(multiModbusTCPServer_Instances[instanceNo].parameters)
  else
    return ''
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.getParameters', getParameters)

-- *****************************************************************
-- Following function can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:fine(nameOfModule .. ": Set parameter name = " .. tostring(name))
  multiModbusTCPServer_Instances[selectedInstance].parametersName = name
end
Script.serveFunction("CSK_MultiModbusTCPServer.setParameterName", setParameterName)

local function sendParameters(noDataSave)
  if multiModbusTCPServer_Instances[selectedInstance].persistentModuleAvailable then
    CSK_PersistentData.addParameter(helperFuncs.convertTable2Container(multiModbusTCPServer_Instances[selectedInstance].parameters), multiModbusTCPServer_Instances[selectedInstance].parametersName)

    -- Check if CSK_PersistentData version is >= 3.0.0
    if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
      CSK_PersistentData.setModuleParameterName(nameOfModule, multiModbusTCPServer_Instances[selectedInstance].parametersName, multiModbusTCPServer_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance), #multiModbusTCPServer_Instances)
    else
      CSK_PersistentData.setModuleParameterName(nameOfModule, multiModbusTCPServer_Instances[selectedInstance].parametersName, multiModbusTCPServer_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance))
    end
    _G.logger:fine(nameOfModule .. ": Send MultiModbusTCPServer parameters with name '" .. multiModbusTCPServer_Instances[selectedInstance].parametersName .. "' to CSK_PersistentData module.")
    if not noDataSave then
      CSK_PersistentData.saveData()
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_MultiModbusTCPServer.sendParameters", sendParameters)

local function loadParameters()
  if multiModbusTCPServer_Instances[selectedInstance].persistentModuleAvailable then
    local data = CSK_PersistentData.getParameter(multiModbusTCPServer_Instances[selectedInstance].parametersName)
    if data then
      stopServer()
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeAllRegisters')

      _G.logger:info(nameOfModule .. ": Loaded parameters for multiModbusTCPServerObject " .. tostring(selectedInstance) .. " from CSK_PersistentData module.")
      multiModbusTCPServer_Instances[selectedInstance].parameters = helperFuncs.convertContainer2Table(data)

      multiModbusTCPServer_Instances[selectedInstance].parameters = helperFuncs.checkParameters(multiModbusTCPServer_Instances[selectedInstance].parameters, helperFuncs.defaultParameters.getParameters())

      -- If something needs to be configured/activated with new loaded data
      updateProcessingParameters()
      if multiModbusTCPServer_Instances[selectedInstance].parameters.connectionStatus then
        startServer()
      end

      tmrMultiModbusTCPServer:start()
      return true
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
      tmrMultiModbusTCPServer:start()
      return false
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
    tmrMultiModbusTCPServer:start()
    return false
  end
end
Script.serveFunction("CSK_MultiModbusTCPServer.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  multiModbusTCPServer_Instances[selectedInstance].parameterLoadOnReboot = status
  _G.logger:fine(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusLoadParameterOnReboot", status)
end
Script.serveFunction("CSK_MultiModbusTCPServer.setLoadOnReboot", setLoadOnReboot)

local function setFlowConfigPriority(status)
  multiModbusTCPServer_Instances[selectedInstance].parameters.flowConfigPriority = status
  _G.logger:fine(nameOfModule .. ": Set new status of FlowConfig priority: " .. tostring(status))
  Script.notifyEvent("MultiModbusTCPServer_OnNewStatusFlowConfigPriority", multiModbusTCPServer_Instances[selectedInstance].parameters.flowConfigPriority)
end
Script.serveFunction('CSK_MultiModbusTCPServer.setFlowConfigPriority', setFlowConfigPriority)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  if _G.availableAPIs.default and _G.availableAPIs.specific then

    _G.logger:fine(nameOfModule .. ': Try to initially load parameter from CSK_PersistentData module.')
    if string.sub(CSK_PersistentData.getVersion(), 1, 1) == '1' then

      _G.logger:warning(nameOfModule .. ': CSK_PersistentData module is too old and will not work. Please update CSK_PersistentData module.')

      for j = 1, #multiModbusTCPServer_Instances do
        multiModbusTCPServer_Instances[j].persistentModuleAvailable = false
      end
    else
      -- Check if CSK_PersistentData version is >= 3.0.0
      if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
        local parameterName, loadOnReboot, totalInstances = CSK_PersistentData.getModuleParameterName(nameOfModule, '1')
        -- Check for amount if instances to create
        if totalInstances then
          local c = 2
          while c <= totalInstances do
            addInstance()
            c = c+1
          end
        end
      end

      if not multiModbusTCPServer_Instances then
        return
      end

      for i = 1, #multiModbusTCPServer_Instances do
        local parameterName, loadOnReboot = CSK_PersistentData.getModuleParameterName(nameOfModule, tostring(i))

        if parameterName then
          multiModbusTCPServer_Instances[i].parametersName = parameterName
          multiModbusTCPServer_Instances[i].parameterLoadOnReboot = loadOnReboot
        end

        if multiModbusTCPServer_Instances[i].parameterLoadOnReboot then
          setSelectedInstance(i)
          loadParameters()
        end
      end
      Script.notifyEvent('MultiModbusTCPServer_OnDataLoadedOnReboot')
    end
  end
end
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

local function resetModule()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    for i = 1, #multiModbusTCPServer_Instances do

      multiModbusTCPServer_Instances[selectedInstance].currentDiscreteInputValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfDiscreteInputs.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentCoilValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfCoils.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentInputRegisterValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.dataType = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputRegisters.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentHoldingRegisterValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.address = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.dataType = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingRegisters.event = {}

      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeAllRegisters')
      setStatusOfServer(false)
    end
    pageCalled()
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.resetModule', resetModule)
Script.register("CSK_PersistentData.OnResetAllModules", resetModule)

-- *************************************************
-- END of functions for CSK_PersistentData module usage
-- *************************************************

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

