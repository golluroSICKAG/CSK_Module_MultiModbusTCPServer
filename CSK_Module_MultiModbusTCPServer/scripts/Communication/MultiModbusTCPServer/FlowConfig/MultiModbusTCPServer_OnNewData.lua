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
  local varName = Container.get(handle, 'VarName')

  -- Check if amount of instances is valid
  -- if not: add multiple additional instances
  while true do
    local amount = CSK_MultiModbusTCPServer.getInstancesAmount()
    if amount < instance then
      CSK_MultiModbusTCPServer.addInstance()
    else
      break
    end
  end

  local function localCallback()
    local cbFunction = Container.get(handle,"CB_Function")

    if cbFunction ~= nil then
        Script.callFunction(cbFunction, 'CSK_MultiModbusTCPServer.OnNewVariableUpdate' .. tostring(instance) .. '_' .. tostring(varName))
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

local function create(instance, varName)

  local fullInstanceName = tostring(instance) -- .. tostring(mode) -- Optionally add parameters, check manifest as well

  -- Check if same instance is already configured
  if instance < 1 or instanceTable[fullInstanceName] ~= nil then
    _G.logger:warning(nameOfModule .. "Instance invalid or already in use, please choose another one")
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[fullInstanceName] = fullInstanceName
    Container.add(handle, 'Instance', instance)
    Container.add(handle, 'VarName', varName)
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