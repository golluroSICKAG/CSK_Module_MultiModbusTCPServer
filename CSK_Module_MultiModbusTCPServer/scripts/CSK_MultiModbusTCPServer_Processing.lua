---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

-- If App property "LuaLoadAllEngineAPI" is FALSE, use this to load and check for required APIs
-- This can improve performance of garbage collection
local availableAPIs = require('Communication/MultiModbusTCPServer/helper/checkAPIs') -- check for available APIs
-----------------------------------------------------------
local nameOfModule = 'CSK_MultiModbusTCPServer'
--Logger
_G.logger = Log.SharedLogger.create('ModuleLogger')

local scriptParams = Script.getStartArgument() -- Get parameters from model

local multiModbusTCPServerInstanceNumber = scriptParams:get('multiModbusTCPServerInstanceNumber') -- number of this instance
local multiModbusTCPServerInstanceNumberString = tostring(multiModbusTCPServerInstanceNumber) -- number of this instance as string

-- Event to notify updated Modbus variables
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewVariableUpdate".. multiModbusTCPServerInstanceNumberString, "MultiModbusTCPServer_OnNewVariableUpdate".. multiModbusTCPServerInstanceNumberString, 'string, binary')
-- Event to forward content from this thread to Controller to show e.g. on UI
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueToForward".. multiModbusTCPServerInstanceNumberString, "MultiModbusTCPServer_OnNewValueToForward" .. multiModbusTCPServerInstanceNumberString, 'string, auto:[?*]')
-- Event to forward update of e.g. parameter update to keep data in sync between threads
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, "MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, 'int, string, auto:[?*], auto:?')

local modbusTCPServerHandle = Modbus.Server.create()

local processingParams = {}
processingParams.activeInUI = false

processingParams.connectionStatus = scriptParams:get('connectionStatus')
processingParams.interface = scriptParams:get('interface')
processingParams.port = scriptParams:get('port')

processingParams.currentConnectionStatus = false --scriptParams:get('currentConnectionStatus')

processingParams.forwardEvents = {} -- Table of events to register to update values of Modbus variables
processingParams.forwardEventsFunctions = {} -- Table of functions to handle value updates

processingParams.currentValues = {} -- Table to track current values of variables
processingParams.currentValues.inputIDs = {}
processingParams.currentValues.input = {}
processingParams.currentValues.holdingIDs = {}
processingParams.currentValues.holding = {}

local log = {}

--- Function to notify latest log messages, e.g. to show on UI
local function sendLog()
  if #log == 100 then
    table.remove(log, 100)
  end
  local tempLog = ''
  for i=1, #log do
    tempLog = tempLog .. tostring(log[i]) .. '\n'
  end
  if processingParams.activeInUI then
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueToForward" .. multiModbusTCPServerInstanceNumberString, 'MultiModbusTCPServer_OnNewLog', tostring(tempLog))
  end
end

--- Function to react if value was written by client
---@param name string[] The name of the variable
---@param value binary[] The new value of the variable
local function handleOnWriteByClient(name, value)
  for key, valName in pairs(name) do
    _G.logger:fine(nameOfModule .. ": Value " .. tostring(valName) .. " was changed to " .. tostring(value[key]))

    processingParams.currentValues.holding[processingParams.currentValues.holdingIDs[valName]] = value[key]

    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'ValueUpdateHolding', processingParams.currentValues.holding)

    -- Forward data to other modules
    Script.notifyEvent("MultiModbusTCPServer_OnNewVariableUpdate" .. multiModbusTCPServerInstanceNumberString, valName, value[key])
    Script.notifyEvent("MultiModbusTCPServer_OnNewVariableUpdate" .. multiModbusTCPServerInstanceNumberString .. '_' .. valName, value[key])

    table.insert(log, 1, DateTime.getTime() .. ' - Update = ' .. tostring(valName) .. ' = ' .. tostring(value[key]))

    sendLog()
  end
end
Modbus.Server.register(modbusTCPServerHandle, 'OnWriteByClient', handleOnWriteByClient)

--- Function to update the Modbus TCP server connection with new setup
local function updateSetup()
  modbusTCPServerHandle:setPort(processingParams.port)
  modbusTCPServerHandle:setInterface(processingParams.interface)
  --sendLog()
end

--- Function to start the Modbus TCP server
local function start()
  updateSetup()
  processingParams.currentConnectionStatus = modbusTCPServerHandle:start()
  table.insert(log, 1, DateTime.getTime() .. ' - Start Server')
  sendLog()
end

--- Function to stop the Modbus TCP server
local function stop()
  modbusTCPServerHandle:stop()
  processingParams.currentConnectionStatus = false
  table.insert(log, 1, DateTime.getTime() .. ' - Stop Server')
  sendLog()
end

local function handleOnSetValue(valueName, varType, value)
  _G.logger:fine(nameOfModule .. ": Set value " .. tostring(valueName) .. " to " .. tostring(value))
  Modbus.Server.writeVariable(modbusTCPServerHandle, valueName, value)

  if varType == 'INPUT' then
    processingParams.currentValues.input[processingParams.currentValues.inputIDs[valueName]] = value
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'ValueUpdateInput', processingParams.currentValues.input)
  elseif varType == 'HOLDING' then
    processingParams.currentValues.holding[processingParams.currentValues.holdingIDs[valueName]] = value
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'ValueUpdateHolding', processingParams.currentValues.holding)
  end

  -- Forward data to other modules
  Script.notifyEvent("MultiModbusTCPServer_OnNewVariableUpdate" .. multiModbusTCPServerInstanceNumberString, valueName, value)
  Script.notifyEvent("MultiModbusTCPServer_OnNewVariableUpdate" .. multiModbusTCPServerInstanceNumberString .. '_' .. valueName, value)

  table.insert(log, 1, DateTime.getTime() .. ' - Update = ' .. tostring(valueName) .. ' = ' .. tostring(value))
  sendLog()
end

local function setInputValue(varName, value)
  handleOnSetValue(varName, 'INPUT', value)
end
Script.serveFunction("CSK_MultiModbusTCPServer.setInputValue" .. multiModbusTCPServerInstanceNumberString, setInputValue, 'string:1, binary:1')

local function setHoldingValue(varName, value)
  handleOnSetValue(varName, 'HOLDING', value)
end
Script.serveFunction("CSK_MultiModbusTCPServer.setHoldingValue" .. multiModbusTCPServerInstanceNumberString, setHoldingValue, 'string:1, binary:1')

local function createInternalForwardFunction(varName, varType)
  local function setValue(varName, varType, data)
    if processingParams.currentConnectionStatus then
      handleOnSetValue(varName, varType, data)
    else
      _G.logger:info(nameOfModule .. ": Set value not possible. Server not active")
    end
  end

  local function forwardContent(data)
    setValue(varName, varType, data)
  end
  processingParams.forwardEventsFunctions[varName] = forwardContent
end

--- Function to handle updates of processing parameters from Controller
---@param multiModbusTCPServerNo int Number of instance to update
---@param parameter string Parameter to update
---@param value auto Value of parameter to update
---@param value2 auto Value2 of parameter to update
---@param value3 auto Value3 of parameter to update
---@param value4 auto Value4 of parameter to update
local function handleOnNewProcessingParameter(multiModbusTCPServerNo, parameter, value, value2, value3, value4)

  if multiModbusTCPServerNo == multiModbusTCPServerInstanceNumber then -- set parameter only in selected script
    _G.logger:fine(nameOfModule .. ": Update parameter '" .. parameter .. "' of multiModbusTCPServerInstanceNo." .. tostring(multiModbusTCPServerNo) .. " to value = " .. tostring(value))

    if parameter == 'start' then
      start()

    elseif parameter == 'stop' then
      stop()

    elseif parameter == 'addVariable' then
      if value3 == 'INPUT' then
        table.insert(processingParams.currentValues.input, '')
        processingParams.currentValues.inputIDs[value] = #processingParams.currentValues.input

      elseif value3 == 'HOLDING' then
        table.insert(processingParams.currentValues.holding, '')
        processingParams.currentValues.holdingIDs[value] = #processingParams.currentValues.holding
      end
      Modbus.Server.addVariable(modbusTCPServerHandle, value, value2, value3)

      local isServed = Script.isServedAsEvent("CSK_MultiModbusTCPServer.OnNewVariableUpdate".. multiModbusTCPServerInstanceNumberString .. '_' .. tostring(value))

      if not isServed then
        Script.serveEvent("CSK_MultiModbusTCPServer.OnNewVariableUpdate".. multiModbusTCPServerInstanceNumberString .. '_' .. tostring(value), "MultiModbusTCPServer_OnNewVariableUpdate".. multiModbusTCPServerInstanceNumberString .. '_' .. tostring(value), 'string')
      end

      if processingParams.forwardEventsFunctions[value] then
        Script.deregister(value, processingParams.forwardEventsFunctions[value])
        processingParams.forwardEventsFunctions[value] = nil
      end

      processingParams.forwardEvents[value] = value4

      createInternalForwardFunction(value, value3)

      if value4 ~= '' then
        _G.logger:fine(nameOfModule .. ": Register to event '" .. value4 .. "' to forward its content to variable '" .. value .. "'")
        Script.register(value4, processingParams.forwardEventsFunctions[value])
      end

    elseif parameter == 'removeVariable' then

      if value2 == 'INPUT' then
        for key, val in pairs(processingParams.currentValues.inputIDs) do
          if val >= value3 then
            processingParams.currentValues.inputIDs[key] = val -1
          elseif val == value3 then
            processingParams.currentValues.inputIDs[key] = nil
          end
        end
        table.remove(processingParams.currentValues.input, value3)
      elseif value2 == 'HOLDING' then
        for key, val in pairs(processingParams.currentValues.holdingIDs) do
          if val > value3 then
            processingParams.currentValues.holdingIDs[key] = val -1
          elseif val == value3 then
            processingParams.currentValues.holdingIDs[key] = nil
          end
        end
        table.remove(processingParams.currentValues.holding, value3)
      end

      Modbus.Server.removeVariable(modbusTCPServerHandle, value)

      if processingParams.forwardEvents[value] then

        _G.logger:fine(nameOfModule .. ": Deregister from event '" .. processingParams.forwardEvents[value] .. " for variable '" .. value .. "'.")

        Script.deregister(processingParams.forwardEvents[value], processingParams.forwardEventsFunctions[value])
        processingParams.forwardEvents[value] = nil
        processingParams.forwardEventsFunctions[value] = nil
      end

    elseif parameter == 'removeAllVariables' then
      for key, value in pairs(processingParams.forwardEvents) do
        Modbus.Server.removeVariable(modbusTCPServerHandle, key)

        if processingParams.forwardEvents[value] ~= '' then
          _G.logger:fine(nameOfModule .. ": Deregister from event '" .. value .. " for variable '" .. key .. "'.")
          Script.deregister(value, processingParams.forwardEventsFunctions[key])
        end
        processingParams.forwardEventsFunctions[key] = nil
      end

      processingParams.forwardEvents = {}

      processingParams.currentValues.input = {}
      processingParams.currentValues.holding = {}

      processingParams.currentValues.inputIDs ={}
      processingParams.currentValues.holdingIDs = {}

    elseif parameter == 'updateEvent' then
      if processingParams.forwardEventsFunctions[value] then
        Script.deregister(value, processingParams.forwardEventsFunctions[value])
        processingParams.forwardEventsFunctions[value] = nil
      end

      processingParams.forwardEvents[value] = value3

      createInternalForwardFunction(value, value2)

      if value4 ~= '' then
        _G.logger:fine(nameOfModule .. ": Register to event '" .. value3 .. "' to forward its content to variable '" .. value .. "'")
        Script.register(value3, processingParams.forwardEventsFunctions[value])
      end

    elseif parameter == 'setInputValue' then
      handleOnSetValue(value, 'INPUT', value2)

    elseif parameter == 'setHoldingValue' then
      handleOnSetValue(value, 'HOLDING', value2)

    else
      processingParams[parameter] = value
    end
  elseif parameter == 'activeInUI' then
    processingParams[parameter] = false
  end
end
Script.register("CSK_MultiModbusTCPServer.OnNewProcessingParameter", handleOnNewProcessingParameter)

