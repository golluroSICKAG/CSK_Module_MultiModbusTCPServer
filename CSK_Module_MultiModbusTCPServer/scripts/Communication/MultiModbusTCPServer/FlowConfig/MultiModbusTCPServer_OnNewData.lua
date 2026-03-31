-- Block namespace
local BLOCK_NAMESPACE = "MultiModbusTCPServer_FC.OnNewData"
local nameOfModule = 'CSK_MultiModbusTCPServer'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function register(handle, _ , callback)

  Container.remove(handle, "CB_Function")
  Container.add(handle, "CB_Function", callback)

  local instance = Container.get(handle, 'Instance')
  local registerType = Container.get(handle, 'RegisterType')
  local address = Container.get(handle, 'Address')
  local dataType = Container.get(handle, 'DataType')

  -- Check if amount of instances is valid
  -- if not: add multiple additional instances
  while true do
    local amount = CSK_MultiModbusTCPServer.getInstancesAmount()
    if amount < instance then
      CSK_MultiModbusTCPServer.addInstance()
    else
      CSK_MultiModbusTCPServer.setSelectedInstance(instance)
      if registerType =='HOLDING_REGISTER' or registerType == 'INPUT_REGISTER' then
        CSK_MultiModbusTCPServer.addRegister(registerType, address, '', dataType, true)
      else
        CSK_MultiModbusTCPServer.addRegister(registerType, address, '', 'BOOL', true)
      end
      break
    end
  end

  local function localCallback()
    local cbFunction = Container.get(handle,"CB_Function")

    if cbFunction ~= nil then
        Script.callFunction(cbFunction, 'CSK_MultiModbusTCPServer.OnNewUpdate' .. tostring(instance) .. '_' .. tostring(registerType) .. '_' .. tostring(address))
    else
      _G.logger:warning(nameOfModule .. ": " .. BLOCK_NAMESPACE .. ".CB_Function missing!")
    end
  end
  Script.register('CSK_FlowConfig.OnNewFlowConfig', localCallback)

  return true
end
Script.serveFunction(BLOCK_NAMESPACE ..".register", register)

--*************************************************************
--*************************************************************

local function create(instance, registerType, address, dataType)

  local fullInstanceName = tostring(instance) .. tostring(registerType) .. tostring(address)

  -- Check if same instance is already configured
  if instanceTable[fullInstanceName] ~= nil then
    _G.logger:warning(nameOfModule .. "Instance invalid or already in use, please choose another one")
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[fullInstanceName] = fullInstanceName
    Container.add(handle, 'Instance', instance)
    Container.add(handle, 'RegisterType', registerType)
    Container.add(handle, 'Address', address)
    if registerType =='HOLDING_REGISTER' or registerType == 'INPUT_REGISTER' then
      Container.add(handle, 'DataType', dataType or 'INT16')
    else
      Container.add(handle, 'DataType', dataType or 'BOOL')
    end
    Container.add(handle, "CB_Function", "")
    return handle
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. ".create", create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)