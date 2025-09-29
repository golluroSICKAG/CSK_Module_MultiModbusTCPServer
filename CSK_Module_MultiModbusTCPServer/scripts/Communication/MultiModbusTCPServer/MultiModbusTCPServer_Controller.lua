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
Script.serveFunction("CSK_MultiModbusTCPServer.setHoldingValueNUM", emptyFunction)
Script.serveFunction("CSK_MultiModbusTCPServer.setInputValueNUM", emptyFunction)

Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueToForwardNUM", "MultiModbusTCPServer_OnNewValueToForwardNUM")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueUpdateNUM", "MultiModbusTCPServer_OnNewValueUpdateNUM")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewVariableUpdateNUM", "MultiModbusTCPServer_OnNewVariableValueUpdateNUM")
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewVariableUpdateNUM_VAR", "MultiModbusTCPServer_OnNewVariableValueUpdateNUM_VAR")
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

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempVarInputName', 'MultiModbusTCPServer_OnNewStatusTempVarInputName')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempVarInputSize', 'MultiModbusTCPServer_OnNewStatusTempVarInputSize')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempVarInputRegisteredEvent', 'MultiModbusTCPServer_OnNewStatusTempVarInputRegisteredEvent')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusInputValueToSet', 'MultiModbusTCPServer_OnNewStatusInputValueToSet')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempVarHoldingName', 'MultiModbusTCPServer_OnNewStatusTempVarHoldingName')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempVarHoldingSize', 'MultiModbusTCPServer_OnNewStatusTempVarHoldingSize')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusTempVarHoldingRegisteredEvent', 'MultiModbusTCPServer_OnNewStatusTempVarHoldingRegisteredEvent')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusHoldingValueToSet', 'MultiModbusTCPServer_OnNewStatusHoldingValueToSet')

Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusListOfInputVariables', 'MultiModbusTCPServer_OnNewStatusListOfInputVariables')
Script.serveEvent('CSK_MultiModbusTCPServer.OnNewStatusListOfHoldingVariables', 'MultiModbusTCPServer_OnNewStatusListOfHoldingVariables')

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
  if parameter == 'ValueUpdateInput' then
    multiModbusTCPServer_Instances[instance].currentInputValues = value
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[instance].parameters.listOfInputVariables, multiModbusTCPServer_Instances[instance].currentInputSelection, 'INPUT', value))
  elseif parameter == 'ValueUpdateHolding' then
    multiModbusTCPServer_Instances[instance].currentHoldingValues = value
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[instance].parameters.listOfHoldingVariables, multiModbusTCPServer_Instances[instance].currentHoldingSelection, 'HOLDING', value))
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

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarInputName", multiModbusTCPServer_Instances[selectedInstance].tempVarInputName)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarInputSize", multiModbusTCPServer_Instances[selectedInstance].tempInputByteSize)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarInputRegisteredEvent", multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusInputValueToSet", multiModbusTCPServer_Instances[selectedInstance].tempInputValue)

    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarHoldingName", multiModbusTCPServer_Instances[selectedInstance].tempVarHoldingName)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarHoldingSize", multiModbusTCPServer_Instances[selectedInstance].tempHoldingByteSize)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarHoldingRegisteredEvent", multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent)
    Script.notifyEvent("MultiModbusTCPServer_OnNewStatusHoldingValueToSet", multiModbusTCPServer_Instances[selectedInstance].tempHoldingValue)

    multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
    multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables, multiModbusTCPServer_Instances[selectedInstance].currentInputSelection, 'INPUT', multiModbusTCPServer_Instances[selectedInstance].currentInputValues))
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables, multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection, 'HOLDING', multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues))

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

local function setInputVarTableSelection(selection)
  if selection == "" then
    multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
    _G.logger:info(nameOfModule .. ": Did not find variable. Is empty")
  else
    local _, pos = string.find(selection, '"DTC_ID_Input":"')
    if pos == nil then
      _G.logger:info(nameOfModule .. ": Did not find variable. Is nil")
      multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local newSelection = string.sub(selection, pos+1, endPos-1)
      if newSelection == multiModbusTCPServer_Instances[selectedInstance].currentInputSelection then
        multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
      else
        if (newSelection == nil or newSelection == "" ) then
          _G.logger:info(nameOfModule .. ": Did not find variable. Is empty or nil")
          multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
        else
          multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = newSelection
          _G.logger:fine(nameOfModule .. ": Selected ID: " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentInputSelection))
          --if ( multiModbusTCPServer_Instances[selectedInstance].currentInputSelection ~= "-" ) then
            --multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent = 
            --Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarInputRegisteredEvent", multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent)
          --  Script.notifyEvent("MultiTCPIPClient_OnNewEventToForward", eventToForward)
          --end
        end
      end
    end
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables, multiModbusTCPServer_Instances[selectedInstance].currentInputSelection, 'INPUT', multiModbusTCPServer_Instances[selectedInstance].currentInputValues))
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputVarTableSelection', setInputVarTableSelection)

local function setHoldingVarTableSelection(selection)
  if selection == "" then
    multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
    _G.logger:info(nameOfModule .. ": Did not find variable. Is empty")
  else
    local _, pos = string.find(selection, '"DTC_ID_Holding":"')
    if pos == nil then
      _G.logger:info(nameOfModule .. ": Did not find variable. Is nil")
      multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local newSelection = string.sub(selection, pos+1, endPos-1)
      if newSelection == multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection then
        multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
      else
        if (newSelection == nil or newSelection == "" ) then
          _G.logger:info(nameOfModule .. ": Did not find variable. Is empty or nil")
          multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
        else
          multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = newSelection
          _G.logger:fine(nameOfModule .. ": Selected ID: " .. tostring(multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection))
          --if ( multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection ~= "-" ) then
            --multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent = 
            --Script.notifyEvent("MultiModbusTCPServer_OnNewStatusTempVarHoldingRegisteredEvent", multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent)
          --  Script.notifyEvent("MultiTCPIPClient_OnNewEventToForward", eventToForward)
          --end
        end
      end
    end
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables, multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection, 'HOLDING', multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues))
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingVarTableSelection', setHoldingVarTableSelection)

local function addVariable(varName, size, varType, eventName)
  for _, inputValue in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names) do
    if inputValue == varName then
      _G.logger:info(nameOfModule .. ": Variable name already exists.")
      return
    end
  end
  for _, holdingValue in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names) do
    if holdingValue == varName then
      _G.logger:info(nameOfModule .. ": Variable name already exists.")
      return
    end
  end

  multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
  multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
  if varType == 'INPUT' then
    table.insert(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names, varName)
    table.insert(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.size, size)
    table.insert(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.event, eventName)
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables, multiModbusTCPServer_Instances[selectedInstance].currentInputSelection, 'INPUT', multiModbusTCPServer_Instances[selectedInstance].currentInputValues))
  elseif varType == 'HOLDING' then
    table.insert(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names, varName)
    table.insert(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.size, size)
    table.insert(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.event, eventName)
    Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables, multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection, 'HOLDING', multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues))
  end
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'addVariable', varName, size, varType, eventName)
end
Script.serveFunction('CSK_MultiModbusTCPServer.addVariable', addVariable)

local function addInputVariableViaUI()
  addVariable(multiModbusTCPServer_Instances[selectedInstance].tempVarInputName, multiModbusTCPServer_Instances[selectedInstance].tempInputByteSize, 'INPUT', multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent)
end
Script.serveFunction('CSK_MultiModbusTCPServer.addInputVariableViaUI', addInputVariableViaUI)

local function removeInputVariable(varName)
  local id = 0
  for key, value in ipairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names) do
    if value == varName then
      id = key
      break
    end
  end
  if id ~= 0 then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeVariable', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names[id], 'INPUT', id)

      table.remove(multiModbusTCPServer_Instances[selectedInstance].currentInputValues, id)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names, id)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.size, id)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.event, id)
      multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
      Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables, multiModbusTCPServer_Instances[selectedInstance].currentInputSelection, 'INPUT', multiModbusTCPServer_Instances[selectedInstance].currentInputValues))
  else
    _G.logger:info(nameOfModule .. ": Variable " .. tostring(varName) .. "does not exist.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeInputVariable', removeInputVariable)

local function removeInputVariableViaUI()
  if multiModbusTCPServer_Instances[selectedInstance].currentInputSelection ~= nil and multiModbusTCPServer_Instances[selectedInstance].currentInputSelection ~= '' then
    local selectedVarID = tonumber(multiModbusTCPServer_Instances[selectedInstance].currentInputSelection)
    if #multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names >= selectedVarID then
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeVariable', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names[selectedVarID], 'INPUT', selectedVarID)

      table.remove(multiModbusTCPServer_Instances[selectedInstance].currentInputValues, selectedVarID)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names, selectedVarID)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.size, selectedVarID)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.event, selectedVarID)
      multiModbusTCPServer_Instances[selectedInstance].currentInputSelection = ''
      Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfInputVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables, multiModbusTCPServer_Instances[selectedInstance].currentInputSelection, 'INPUT', multiModbusTCPServer_Instances[selectedInstance].currentInputValues))
    else
      _G.logger:info(nameOfModule .. ": Variable does not exist.")
    end
  else
    _G.logger:info(nameOfModule .. ": No selection.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeInputVariableViaUI', removeInputVariableViaUI)

local function setInputVarName(name)
  _G.logger:fine(nameOfModule .. ": Set temp name of new input variable to = " .. tostring(name))
  multiModbusTCPServer_Instances[selectedInstance].tempVarInputName = name
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputVarName', setInputVarName)

local function setInputVarSize(size)
  _G.logger:fine(nameOfModule .. ": Set size of new input variable to = " .. tostring(size) .. ' Byte')
  multiModbusTCPServer_Instances[selectedInstance].tempInputByteSize = size
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputVarSize', setInputVarSize)

local function setInputVarRegisteredEvent(event)
  _G.logger:fine(nameOfModule .. ": Set event to register new input variable to = " .. tostring(event))
  multiModbusTCPServer_Instances[selectedInstance].tempInputRegisteredEvent = event
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputVarRegisteredEvent', setInputVarRegisteredEvent)

local function addHoldingVariableViaUI()
  addVariable(multiModbusTCPServer_Instances[selectedInstance].tempVarHoldingName, multiModbusTCPServer_Instances[selectedInstance].tempHoldingByteSize, 'HOLDING', multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent)
end
Script.serveFunction('CSK_MultiModbusTCPServer.addHoldingVariableViaUI', addHoldingVariableViaUI)

local function removeHoldingVariable(varName)
  local id = 0
  for key, value in ipairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names) do
    if value == varName then
      id = key
      break
    end
  end
  if id ~= 0 then
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeVariable', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names[id], 'HOLDING', id)

      table.remove(multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues, id)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names, id)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.size, id)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.event, id)
      multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
      Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables, multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection, 'HOLDING', multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues))
  else
    _G.logger:info(nameOfModule .. ": Variable does not exist.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeHoldingVariable', removeHoldingVariable)

local function removeHoldingVariableViaUI()
  if multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection ~= nil and multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection ~= '' then
    local selectedVarID = tonumber(multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection)
    if #multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names >= selectedVarID then
      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeVariable', multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names[selectedVarID], 'HOLDING', selectedVarID)

      table.remove(multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues, selectedVarID)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names, selectedVarID)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.size, selectedVarID)
      table.remove(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.event, selectedVarID)
      multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection = ''
      Script.notifyEvent('MultiModbusTCPServer_OnNewStatusListOfHoldingVariables', helperFuncs.createJsonListVariableList(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables, multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection, 'HOLDING', multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues))
    else
      _G.logger:info(nameOfModule .. ": Variable does not exist.")
    end
  else
    _G.logger:info(nameOfModule .. ": No selection")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.removeHoldingVariableViaUI', removeHoldingVariableViaUI)

local function setHoldingVarName(name)
  _G.logger:fine(nameOfModule .. ": Set temp name of new holding variable to = " .. tostring(name))
  multiModbusTCPServer_Instances[selectedInstance].tempVarHoldingName = name
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingVarName', setHoldingVarName)

local function setHoldingVarSize(size)
  _G.logger:fine(nameOfModule .. ": Set size of new holding variable to = " .. tostring(size) .. ' Byte')
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingByteSize = size
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingVarSize', setHoldingVarSize)

local function setHoldingVarRegisteredEvent(event)
  _G.logger:fine(nameOfModule .. ": Set event to register new holding variable to = " .. tostring(event))
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingRegisteredEvent = event
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingVarRegisteredEvent', setHoldingVarRegisteredEvent)

--[[
local function setValueOfVariable(instance, varName, value)
  _G.logger:fine(nameOfModule .. ": Set value of variable " .. tostring(varName) .. "of instance " .. tostring(instance) .. " to = " .. tostring(value))
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', instance, 'setValue', varName, value)
end
Script.serveFunction('CSK_MultiModbusTCPServer.setValueOfVariable', setValueOfVariable)
]]

local function setInputValueToSet(value)
  multiModbusTCPServer_Instances[selectedInstance].tempInputValue = value
  if multiModbusTCPServer_Instances[selectedInstance].currentInputSelection ~= '' then
    local varName = multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names[tonumber(multiModbusTCPServer_Instances[selectedInstance].currentInputSelection)]
    _G.logger:fine(nameOfModule .. ": Set value of variable " .. tostring(varName) .. "of instance " .. tostring(selectedInstance) .. " to = " .. tostring(multiModbusTCPServer_Instances[selectedInstance].tempInputValue))
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'setInputValue', varName, string.pack('>I2', multiModbusTCPServer_Instances[selectedInstance].tempInputValue))
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setInputValueToSet', setInputValueToSet)

local function setHoldingValueToSetViaUI(value)
  multiModbusTCPServer_Instances[selectedInstance].tempHoldingValue = value
  if multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection ~= '' then
    local varName = multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names[tonumber(multiModbusTCPServer_Instances[selectedInstance].currentHoldingSelection)]
    _G.logger:fine(nameOfModule .. ": Set value of variable " .. tostring(varName) .. "of instance " .. tostring(selectedInstance) .. " to = " .. tostring(multiModbusTCPServer_Instances[selectedInstance].tempHoldingValue))
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'setHoldingValue', varName, string.pack('>I2', multiModbusTCPServer_Instances[selectedInstance].tempHoldingValue))
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setHoldingValueToSetViaUI', setHoldingValueToSetViaUI)

local function setRegisteredEventOfVariable(varName, eventName)
  local inputID = false
  local holdingID = false
  for key, inputValue in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names) do
    if inputValue == varName then
      inputID = key
      break
    end
  end
  if not inputID then
    for _, holdingValue in pairs(multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names) do
      if holdingValue == varName then
        holdingID = key
        break
      end
    end
  end

  if inputID then
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.event[inputID] = eventName
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', varName, 'INPUT', eventName)
  elseif holdingID then
    multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.event[holdingID] = eventName
    Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'updateEvent', varName, 'HOLDING', eventName)
  else
    _G.logger:info(nameOfModule .. ": Variable not available to set registerd event.")
  end
end
Script.serveFunction('CSK_MultiModbusTCPServer.setRegisteredEventOfVariable', setRegisteredEventOfVariable)

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

--TODO
local function setRegisterEvent(event)
  multiModbusTCPServer_Instances[selectedInstance].parameters.registeredEvent = event
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'registeredEvent', event)
end
Script.serveFunction("CSK_MultiModbusTCPServer.setRegisterEvent", setRegisterEvent)

--- Function to share process relevant configuration with processing threads
local function updateProcessingParameters()
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)

  --Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'registeredEvent', multiModbusTCPServer_Instances[selectedInstance].parameters.registeredEvent)

  --Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'value', multiModbusTCPServer_Instances[selectedInstance].parameters.value)

  -- optionally for internal objects...
  --[[
  -- Send config to instances
  local params = helperFuncs.convertTable2Container(multiModbusTCPServer_Instances[selectedInstance].parameters.internalObject)
  Container.add(data, 'internalObject', params, 'OBJECT')
  Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'FullSetup', data)
  ]]

end

local function getStatusModuleActive()
  return _G.availableAPIs.default and _G.availableAPIs.specific
end
Script.serveFunction('CSK_MultiModbusTCPServer.getStatusModuleActive', getStatusModuleActive)

local function clearFlowConfigRelevantConfiguration()
  for i = 1, #multiModbusTCPServer_Instances do
    if multiModbusTCPServer_Instances[i].parameters.flowConfigPriority then
      --TODO
      --multiModbusTCPServer_Instances[i].parameters.registeredEvent = ''
      --Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', i, 'deregisterFromEvent', '')
      --Script.notifyEvent('MultiModbusTCPServer_OnNewStatusRegisteredEvent', '')
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
      _G.logger:info(nameOfModule .. ": Loaded parameters for multiModbusTCPServerObject " .. tostring(selectedInstance) .. " from CSK_PersistentData module.")
      multiModbusTCPServer_Instances[selectedInstance].parameters = helperFuncs.convertContainer2Table(data)

      multiModbusTCPServer_Instances[selectedInstance].parameters = helperFuncs.checkParameters(multiModbusTCPServer_Instances[selectedInstance].parameters, helperFuncs.defaultParameters.getParameters())

      -- If something needs to be configured/activated with new loaded data
      --updateProcessingParameters()

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
      multiModbusTCPServer_Instances[selectedInstance].currentInputValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.names = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.size = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfInputVariables.event = {}

      multiModbusTCPServer_Instances[selectedInstance].currentHoldingValues = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.names = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.size = {}
      multiModbusTCPServer_Instances[selectedInstance].parameters.listOfHoldingVariables.event = {}

      Script.notifyEvent('MultiModbusTCPServer_OnNewProcessingParameter', selectedInstance, 'removeAllVariables')
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

