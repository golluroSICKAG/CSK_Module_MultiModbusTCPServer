-- Block namespace
local BLOCK_NAMESPACE = 'MultiModbusTCPServer_FC.SetValue'
local nameOfModule = 'CSK_MultiModbusTCPServer'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function setValue(handle, source)

  local instance = Container.get(handle, 'Instance')
  local varName = Container.get(handle, 'VarName')

  -- Check incoming value
  if source then

    -- Check if amount of instances is valid
    -- if not: add multiple additional instances
    while true do
      local amount = CSK_MultiModbusTCPServer.getInstancesAmount()
      if amount < instance then
        CSK_MultiModbusTCPServer.addInstance()
      else
        CSK_MultiModbusTCPServer.setSelectedInstance(instance)
        CSK_MultiModbusTCPServer.setRegisteredEventOfVariable(varName, source)
        break
      end
    end
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.setValue', setValue)

--*************************************************************
--*************************************************************

local function create(instance, varName)

  -- Check if same instance is already configured
  if instance < 1 or nil ~= instanceTable[instance] then
    _G.logger:warning(nameOfModule .. ': Instance invalid or already in use, please choose another one')
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[instance] = instance
    Container.add(handle, 'Instance', instance)
    Container.add(handle, 'VarName', varName)
    return handle
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)