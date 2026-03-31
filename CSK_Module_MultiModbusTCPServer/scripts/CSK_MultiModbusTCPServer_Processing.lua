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

-- Event to forward content from this thread to Controller to show e.g. on UI
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueToForward".. multiModbusTCPServerInstanceNumberString, "MultiModbusTCPServer_OnNewValueToForward" .. multiModbusTCPServerInstanceNumberString, 'string, auto:[?*]')
-- Event to forward update of e.g. parameter update to keep data in sync between threads
Script.serveEvent("CSK_MultiModbusTCPServer.OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, "MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, 'int, string, auto:[?*], auto:[?*]')

local modbusTCPServerHandle = Modbus.TCPServer.create()
local modbusTCPModelHandle = Modbus.Model.create()

local processingParams = {}
processingParams.activeInUI = false

processingParams.connectionStatus = scriptParams:get('connectionStatus')
processingParams.interface = scriptParams:get('interface')
processingParams.port = scriptParams:get('port')

processingParams.maxConnections = scriptParams:get('maxConnections')
processingParams.transmitTimeout = scriptParams:get('transmitTimeout')

processingParams.showLog = scriptParams:get('showLog')

processingParams.currentConnectionStatus = false --scriptParams:get('currentConnectionStatus')

processingParams.forwardEvents = {} -- Table of events to register to update values of Modbus registers
processingParams.forwardEventsFunctions = {} -- Table of functions to handle value updates

processingParams.dataTypes = {} -- -- Table to track data types of registers
processingParams.dataTypes.inputRegisters = {}
processingParams.dataTypes.holdingRegisters = {}

processingParams.currentValues = {} -- Table to track current values of registers
processingParams.currentValues.coils = {}
processingParams.currentValues.discreteInputs = {}
processingParams.currentValues.holdingRegisters = {}
processingParams.currentValues.inputRegisters = {}

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

local function pushNewData(modType, address, data)
  if Script.isServedAsEvent("CSK_MultiModbusTCPServer.OnNewUpdate" .. multiModbusTCPServerInstanceNumberString .. '_' .. modType .. '_' .. tostring(address)) then
    Script.notifyEvent("MultiModbusTCPServer_OnNewUpdate" .. multiModbusTCPServerInstanceNumberString .. '_' .. modType .. '_' .. tostring(address), data)
    if processingParams.showLog then
      table.insert(log, 1, DateTime.getTime() .. " - Update " .. tostring(modType) .. " at address " .. tostring(address) .. " to " .. tostring(data))
      sendLog()
    end
  else
    _G.logger:info(nameOfModule .. ": No event for " .. modType .. " at address " .. address)
  end
end

--- Function to react if value was written by client
---@param type Modbus.Model.RegisterType Register type
---@param address int Start address of the written register(s)
---@param quantity int Quantity of the written register(s)
local function handleOnWriteByClient(modType, address, quantity)
  _G.logger:fine(nameOfModule .. ": Update of type " .. tostring(modType) .. '; Address = ' .. tostring(address) .. ', Quantity = ' .. tostring(quantity))

  if modType == 'HOLDING_REGISTER' then
    local content = modbusTCPModelHandle:getHoldingRegisters(address, quantity)
    local checkQuantity = 0
    while checkQuantity < quantity do
      local unpackedData
      if processingParams.dataTypes.holdingRegisters[tostring(address+checkQuantity)] == 'INT16' then
        local tempData = string.sub(content, 1, 2)

        if #tempData == 2 then
          unpackedData = string.unpack('>i2', tempData)
          processingParams.currentValues.holdingRegisters[tostring(address+checkQuantity)] = unpackedData
          pushNewData(modType, address+checkQuantity, unpackedData)
        else
          _G.logger:warning(nameOfModule .. ": Received data is not INT16 format.")
        end

        if #content > 2 then
          content = string.sub(content, 3, #content)
        end
        checkQuantity = checkQuantity + 1
      elseif processingParams.dataTypes.holdingRegisters[tostring(address+checkQuantity)] == 'UINT16' then
        local tempData = string.sub(content, 1, 2)

        if #tempData == 2 then
          unpackedData = string.unpack('>I2', tempData)
          processingParams.currentValues.holdingRegisters[tostring(address+checkQuantity)] = unpackedData
          pushNewData(modType, address+checkQuantity, unpackedData)
        else
          _G.logger:warning(nameOfModule .. ": Received data is not UINT16 format.")
        end

        if #content > 2 then
          content = string.sub(content, 3, #content)
        end
        checkQuantity = checkQuantity + 1
      elseif processingParams.dataTypes.holdingRegisters[tostring(address+checkQuantity)] == 'FLOAT' then
        local tempData = string.sub(content, 1, 4)
        if #tempData == 4 then
          unpackedData = string.unpack('>f', tempData)
          processingParams.currentValues.holdingRegisters[tostring(address+checkQuantity)] = unpackedData
          pushNewData(modType, address+checkQuantity, unpackedData)
        else
          _G.logger:warning(nameOfModule .. ": Received data is not FLOAT format.")
        end

        if #content > 4 then
          content = string.sub(content, 5, #content)
        end
        checkQuantity = checkQuantity + 2
      elseif processingParams.dataTypes.holdingRegisters[tostring(address+checkQuantity)] == 'DOUBLE' then
        local tempData = string.sub(content, 1, 8)
        if #tempData == 8 then
          unpackedData = string.unpack('>d', tempData)
          processingParams.currentValues.holdingRegisters[tostring(address+checkQuantity)] = unpackedData
          pushNewData(modType, address+checkQuantity, unpackedData)
        end

        if #content > 8 then
          content = string.sub(content, 9, #content)
        end
        checkQuantity = checkQuantity + 4
        --[[
      elseif processingParams.dataTypes.holdingRegisters[tostring(address+checkQuantity)] == 'BOOL' then
        local tempData = string.sub(content, 1, 2)
        unpackedData = string.unpack('>I2', tempData)
        if #content > 8 then
          content = string.sub(content, 9, #content)
        end
        processingParams.currentValues.holdingRegisters[tostring(address+checkQuantity)] = unpackedData
        pushNewData(modType, address+checkQuantity, unpackedData)
        checkQuantity = checkQuantity + 4
        ]]

      else
        _G.logger:info(nameOfModule .. ": HOLDING_REGISTER address " .. tostring(address+checkQuantity) .. " is not configured.")
        break
      end
    end

    local addressTable = {}
    local valueTable = {}
    for key, val in pairs(processingParams.currentValues.holdingRegisters) do
      if val ~= nil and val ~= '' then
        table.insert(addressTable, key)
        table.insert(valueTable, val)
      end
    end
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'UpdateHoldingRegister', addressTable, valueTable)

  elseif modType == 'COIL' then
    local content = modbusTCPModelHandle:getCoils(address, quantity)
    for j=1, quantity do
      local tempData = string.sub(content, 1, 1)
      local unpackedData = string.unpack('>I1', tempData)
      if unpackedData == 1 then
        processingParams.currentValues.coils[tostring(address+j-1)] = true
        -- Forward data to other modules
        pushNewData(modType, address+j-1, true)
      else
        processingParams.currentValues.coils[tostring(address+j-1)] = false
        pushNewData(modType, address+j-1, false)
      end
      if #content > 1 then
        content = string.sub(content, 2, #content)
      end
    end

    local addressTable = {}
    local valueTable = {}
    for key, val in pairs(processingParams.currentValues.coils) do
      if val ~= nil and val ~= '' then
        table.insert(addressTable, key)
        table.insert(valueTable, val)
      end
    end
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'UpdateCoils', addressTable, valueTable)
  end
end
Modbus.TCPServer.register(modbusTCPServerHandle, 'OnWriteByClient', handleOnWriteByClient)

--- Function to update the Modbus TCP server connection with new setup
local function updateSetup()
  modbusTCPServerHandle:setPort(processingParams.port)
  modbusTCPServerHandle:setInterface(processingParams.interface)
  modbusTCPServerHandle:setMaxConnections(processingParams.maxConnections)
  modbusTCPServerHandle:setTransmitTimeout(processingParams.transmitTimeout)
  modbusTCPServerHandle:setModel(modbusTCPModelHandle)
end

--- Function to start the Modbus TCP server
local function start()
  updateSetup()
  processingParams.currentConnectionStatus = modbusTCPServerHandle:start()
  if processingParams.showLog then
    table.insert(log, 1, DateTime.getTime() .. ' - Start Server')
    sendLog()
  end
end

--- Function to stop the Modbus TCP server
local function stop()
  modbusTCPServerHandle:stop()
  processingParams.currentConnectionStatus = false
  if processingParams.showLog then
    table.insert(log, 1, DateTime.getTime() .. ' - Stop Server')
    sendLog()
  end
end

local function handleOnSetValue(modType, address, value)
  _G.logger:fine(nameOfModule .. ": Set '" .. tostring(modType) .. "' at address " .. tostring(address) .. " to " .. tostring(value))

  if modType == 'DISCRETE_INPUT' then
    if value == true then
      local suc = modbusTCPModelHandle:setDiscreteInputs(address, 1, string.pack('>I1', 1))
    elseif value == false then
      local suc = modbusTCPModelHandle:setDiscreteInputs(address, 1, string.pack('>I1', 0))
    end

    processingParams.currentValues.discreteInputs[tostring(address)] = value
    local addressTable = {}
    local valueTable = {}
    for key, val in pairs(processingParams.currentValues.discreteInputs) do
      if val ~= nil and val ~= '' then
        table.insert(addressTable, key)
        table.insert(valueTable, val)
      end
    end
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'UpdateDiscreteInputs', addressTable, valueTable)

  elseif modType == 'COIL' then
    if value == true then
      local suc = modbusTCPModelHandle:setCoils(address, 1, string.pack('>I1', 1))
    elseif value == false then
      local suc = modbusTCPModelHandle:setCoils(address, 1, string.pack('>I1', 0))
    end

    processingParams.currentValues.coils[tostring(address)] = value
    local addressTable = {}
    local valueTable = {}
    for key, val in pairs(processingParams.currentValues.coils) do
      if val ~= nil and val ~= '' then
        table.insert(addressTable, key)
        table.insert(valueTable, val)
      end
    end
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'UpdateCoils', addressTable, valueTable)

  elseif modType == 'HOLDING_REGISTER' then
    if type(value) == 'boolean' then
      if value == false then
        value = 0
      else
        value = 1
      end
    end
    processingParams.currentValues.holdingRegisters[tostring(address)] = value

    if processingParams.dataTypes.holdingRegisters[tostring(address)] == 'INT16' then
      modbusTCPModelHandle:setHoldingRegisters(address, 1, string.pack('>i2', value))
    elseif processingParams.dataTypes.holdingRegisters[tostring(address)] == 'UINT16' then
      modbusTCPModelHandle:setHoldingRegisters(address, 1, string.pack('>I2', value))
    elseif processingParams.dataTypes.holdingRegisters[tostring(address)] == 'FLOAT' then
      modbusTCPModelHandle:setHoldingRegisters(address, 2, string.pack('>f', value))
    elseif processingParams.dataTypes.holdingRegisters[tostring(address)] == 'DOUBLE' then
      modbusTCPModelHandle:setHoldingRegisters(address, 4, string.pack('>d', value))
    else
      modbusTCPModelHandle:setHoldingRegisters(address, 1, string.pack('>I2', value))
    end

    local addressTable = {}
    local valueTable = {}
    for key, val in pairs(processingParams.currentValues.holdingRegisters) do
      if val ~= nil and val ~= '' then
        table.insert(addressTable, key)
        table.insert(valueTable, val)
      end
    end
    --TODO
    --Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'UpdateHoldingRegister', addressTable, valueTable)

  elseif modType == 'INPUT_REGISTER' then
    if type(value) == 'boolean' then
      if value == false then
        value = 0
      else
        value = 1
      end
    end
    processingParams.currentValues.inputRegisters[tostring(address)] = value

    if processingParams.dataTypes.inputRegisters[tostring(address)] == 'INT16' then
      modbusTCPModelHandle:setInputRegisters(address, 1, string.pack('>i2', value))
    elseif processingParams.dataTypes.inputRegisters[tostring(address)] == 'UINT16' then
      modbusTCPModelHandle:setInputRegisters(address, 1, string.pack('>I2', value))
    elseif processingParams.dataTypes.inputRegisters[tostring(address)] == 'FLOAT' then
      modbusTCPModelHandle:setInputRegisters(address, 2, string.pack('>f', value))
    elseif processingParams.dataTypes.inputRegisters[tostring(address)] == 'DOUBLE' then
      modbusTCPModelHandle:setInputRegisters(address, 4, string.pack('>d', value))
    else
      modbusTCPModelHandle:setInputRegisters(address, 1, string.pack('>I2', value))
    end

    local addressTable = {}
    local valueTable = {}
    for key, val in pairs(processingParams.currentValues.inputRegisters) do
      if val ~= nil and val ~= '' then
        table.insert(addressTable, key)
        table.insert(valueTable, val)
      end
    end
    Script.notifyEvent("MultiModbusTCPServer_OnNewValueUpdate" .. multiModbusTCPServerInstanceNumberString, multiModbusTCPServerInstanceNumber, 'UpdateInputRegister', addressTable, valueTable)
  end

  -- Forward data to other modules
  --TODO
  pushNewData(modType, address, value)

end

local function createInternalForwardFunction(varType, address)
  local function setValue(varType, address, data)
    if processingParams.currentConnectionStatus then
      handleOnSetValue(varType, address, data)
    else
      _G.logger:info(nameOfModule .. ": Setting value not possible. Server not active")
    end
  end

  local function forwardContent(data)
    setValue(varType, address, data)
  end
  processingParams.forwardEventsFunctions[varType .. '_' .. tostring(address)] = forwardContent
end

--- Function to handle updates of processing parameters from Controller
---@param multiModbusTCPServerNo int Number of instance to update
---@param parameter string Parameter to update
---@param value auto Value of parameter to update
---@param value2 auto Value2 of parameter to update
---@param value3 auto Value3 of parameter to update
---@param value4 auto Value4 of parameter to update
local function handleOnNewProcessingParameter(multiModbusTCPServerNo, parameter, value, value2, value3, value4)

  if parameter == 'showLog' then
    processingParams[parameter] = value

  elseif multiModbusTCPServerNo == multiModbusTCPServerInstanceNumber then -- set parameter only in selected script
    _G.logger:fine(nameOfModule .. ": Update parameter '" .. parameter .. "' of multiModbusTCPServerInstanceNo." .. tostring(multiModbusTCPServerNo) .. " to value = " .. tostring(value))

    if parameter == 'start' then
      start()

    elseif parameter == 'stop' then
      stop()

    elseif parameter == 'addRegister' then
      if value == 'DISCRETE_INPUT' then
        processingParams.currentValues.discreteInputs[tostring(value2)] = ''

      elseif value == 'COIL' then
        processingParams.currentValues.coils[tostring(value2)] = ''

      elseif value == 'INPUT_REGISTER' then
        processingParams.currentValues.inputRegisters[tostring(value2)] =  ''
        processingParams.dataTypes.inputRegisters[tostring(value2)] = value4

      elseif value == 'HOLDING_REGISTER' then
        processingParams.currentValues.holdingRegisters[tostring(value2)] =  ''
        processingParams.dataTypes.holdingRegisters[tostring(value2)] = value4
      end

      local isServed = Script.isServedAsEvent("CSK_MultiModbusTCPServer.OnNewUpdate".. multiModbusTCPServerInstanceNumberString .. '_' .. tostring(value) .. '_' .. tostring(value2))

      if not isServed then
        Script.serveEvent("CSK_MultiModbusTCPServer.OnNewUpdate".. multiModbusTCPServerInstanceNumberString .. '_' .. tostring(value) .. '_' .. tostring(value2), "MultiModbusTCPServer_OnNewUpdate".. multiModbusTCPServerInstanceNumberString .. '_' .. tostring(value) .. '_' .. tostring(value2), 'auto')
      end
      local fullName = tostring(value) .. '_' .. tostring(value2)

      if processingParams.forwardEventsFunctions[fullName] then
        Script.deregister(processingParams.forwardEvents[fullName], processingParams.forwardEventsFunctions[fullName])
        processingParams.forwardEventsFunctions[fullName] = nil
      end

      processingParams.forwardEvents[fullName] = value3

      createInternalForwardFunction(value, value2)

      if value3 ~= '' then
        _G.logger:fine(nameOfModule .. ": Register to event '" .. value3 .. "' to forward its content to address " .. value2 .. " of " .. value)
        Script.register(value3, processingParams.forwardEventsFunctions[fullName])
      end

    elseif parameter == 'removeRegister' then

      if value == 'DISCRETE_INPUT' then
        processingParams.currentValues.discreteInputs[value2] = nil
      elseif value == 'COIL' then
        processingParams.currentValues.coils[value2] = nil
      elseif value == 'INPUT_REGISTER' then
        processingParams.currentValues.inputRegisters[value2] = nil
        processingParams.dataTypes.inputRegisters[value2] = nil
      elseif value == 'HOLDING_REGISTER' then
        processingParams.currentValues.holdingRegisters[value2] = nil
        processingParams.dataTypes.holdingRegisters[value2] = nil
      end

      local fullName = value .. '_' .. tostring(value2)
      if processingParams.forwardEvents[fullName] then
        _G.logger:fine(nameOfModule .. ": Deregister from event '" .. processingParams.forwardEvents[fullName] .. "' for address '" .. value2 .. "' of " .. tostring(value))
        Script.deregister(processingParams.forwardEvents[fullName], processingParams.forwardEventsFunctions[fullName])
        processingParams.forwardEvents[fullName] = nil
        processingParams.forwardEventsFunctions[fullName] = nil
      end

    elseif parameter == 'removeAllRegisters' then
      for key, value in pairs(processingParams.forwardEvents) do

        if processingParams.forwardEvents[value] ~= '' then
          _G.logger:fine(nameOfModule .. ": Deregister from event '" .. value)
          Script.deregister(value, processingParams.forwardEventsFunctions[key])
        end
        processingParams.forwardEventsFunctions[key] = nil
      end

      processingParams.forwardEvents = {}

      processingParams.currentValues.discreteInputs = {}
      processingParams.currentValues.coils = {}
      processingParams.currentValues.inputRegisters = {}
      processingParams.currentValues.holdingRegisters = {}

      processingParams.dataTypes.inputRegisters = {}
      processingParams.dataTypes.holdingRegisters = {}


    elseif parameter == 'updateEvent' then

      if value == 'INPUT_REGISTER' then
        processingParams.dataTypes.inputRegisters[tostring(value2)] = value4
      elseif value == 'HOLDING_REGISTER' then
        processingParams.dataTypes.holdingRegisters[tostring(value2)] = value4
      end
      local fullName = value .. '_' .. tostring(value2)
      if processingParams.forwardEventsFunctions[fullName] then
        Script.deregister(processingParams.forwardEvents[fullName], processingParams.forwardEventsFunctions[fullName])
        processingParams.forwardEventsFunctions[fullName] = nil
      end

      processingParams.forwardEvents[fullName] = value3

      createInternalForwardFunction(value, value2)


      if value3 ~= '' then
        _G.logger:fine(nameOfModule .. ": Register to event '" .. value3 .. "' to forward its content to address " .. tostring(value2) .. " of " .. tostring(value))
        Script.register(value3, processingParams.forwardEventsFunctions[fullName])
      end

    elseif parameter == 'setCoilValue' then
      handleOnSetValue('COIL', tonumber(value), value2)

    elseif parameter == 'setDiscreteInputValue' then
      handleOnSetValue('DISCRETE_INPUT', tonumber(value), value2)

    elseif parameter == 'setInputValue' then
      handleOnSetValue('INPUT_REGISTER', tonumber(value), value2)

    elseif parameter == 'setHoldingValue' then
      handleOnSetValue('HOLDING_REGISTER', tonumber(value), value2)

    else
      processingParams[parameter] = value
    end
  elseif parameter == 'activeInUI' then
    processingParams[parameter] = false
  end
end
Script.register("CSK_MultiModbusTCPServer.OnNewProcessingParameter", handleOnNewProcessingParameter)

