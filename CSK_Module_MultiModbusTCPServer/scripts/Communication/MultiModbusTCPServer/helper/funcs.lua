---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find helper functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************


local nameOfModule = 'CSK_ModuleName'

local funcs = {}
-- Providing standard JSON functions
funcs.json = require('Communication/MultiModbusTCPServer/helper/Json')
-- Default parameters for instances of module
funcs.defaultParameters = require('Communication/MultiModbusTCPServer/MultiModbusTCPServer_Parameters')

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to create a json string out of 'Modbus TCP Variables' table content
---@param content table[] Table with 'Modbus TCP Variables' data entries
---@param selectedParam string Selected table entry
---@param tableType string Type of table
---@return string jsonstring JSON string
local function createJsonListVariableList(content, selectedParam, tableType, values)
  local varList = {}
  if content.names == nil then
    if tableType == 'INPUT' then
      varList = {{DTC_ID_Input = '-', DTC_BytePosition_Input = '-', DTC_VarName_Input = '-', DTC_RegisteredEvent_Input = '-', DTC_CurrentValue_Input = '-'},}
    elseif tableType == 'HOLDING' then
      varList = {{DTC_ID_Holding = '-', DTC_BytePosition_Holding = '-', DTC_VarName_Holding = '-', DTC_RegisteredEvent_Holding = '-', DTC_CurrentValue_Holding = '-'},}
    end
  else

    local tempBytePosition = 0
    for i in ipairs(content.names) do
      local isSelected = false
      if tostring(i) == selectedParam then
        isSelected = true
      end
      if tableType == 'INPUT' then
        if values[i] then
          table.insert(varList, {DTC_ID_Input = tostring(i), DTC_BytePosition_Input = tostring(tempBytePosition) .. ' - ' .. tostring(tempBytePosition + content.size[i] -1), DTC_VarName_Input = content.names[i], DTC_RegisteredEvent_Input = content.event[i], DTC_CurrentValue_Input = string.unpack('>I2', values[i]), selected = isSelected})
        else
          table.insert(varList, {DTC_ID_Input = tostring(i), DTC_BytePosition_Input = tostring(tempBytePosition) .. ' - ' .. tostring(tempBytePosition + content.size[i] -1), DTC_VarName_Input = content.names[i], DTC_RegisteredEvent_Input = content.event[i], DTC_CurrentValue_Input = 'nA', selected = isSelected})
        end
      elseif tableType == 'HOLDING' then
        if values[i] then
          table.insert(varList, {DTC_ID_Holding = tostring(i), DTC_BytePosition_Holding = tostring(tempBytePosition) .. ' - ' .. tostring(tempBytePosition + content.size[i] -1), DTC_VarName_Holding = content.names[i], DTC_RegisteredEvent_Holding = content.event[i], DTC_CurrentValue_Holding = string.unpack('>I2', values[i]), selected = isSelected})
        else
          table.insert(varList, {DTC_ID_Holding = tostring(i), DTC_BytePosition_Holding = tostring(tempBytePosition) .. ' - ' .. tostring(tempBytePosition + content.size[i] -1), DTC_VarName_Holding = content.names[i], DTC_RegisteredEvent_Holding = content.event[i], DTC_CurrentValue_Holding = 'nA', selected = isSelected})
        end
      end
      tempBytePosition = tempBytePosition + content.size[i]
    end

    if #varList == 0 then
      if tableType == 'INPUT' then
        varList = {{DTC_ID_Input = '-', DTC_BytePosition_Input = '-', DTC_VarName_Input = '-', DTC_RegisteredEvent_Input = '-', DTC_CurrentValue_Input = '-'},}
      elseif tableType == 'HOLDING' then
        varList = {{DTC_ID_Holding = '-', DTC_BytePosition_Holding = '-', DTC_VarName_Holding = '-', DTC_RegisteredEvent_Holding = '-', DTC_CurrentValue_Holding = '-'},}
      end
    end
  end

  local jsonstring = funcs.json.encode(varList)
  return jsonstring
end
funcs.createJsonListVariableList = createJsonListVariableList

--- Function to create a list with numbers
---@param size int Size of the list
---@return string list List of numbers
local function createStringListBySize(size)
  local list = "["
  if size >= 1 then
    list = list .. '"' .. tostring(1) .. '"'
  end
  if size >= 2 then
    for i=2, size do
      list = list .. ', ' .. '"' .. tostring(i) .. '"'
    end
  end
  list = list .. "]"
  return list
end
funcs.createStringListBySize = createStringListBySize

--- Function to convert a table into a Container object
---@param content auto[] Lua Table to convert to Container
---@return Container cont Created Container
local function convertTable2Container(content)
  local cont = Container.create()
  for key, value in pairs(content) do
    if type(value) == 'table' then
      cont:add(key, convertTable2Container(value), nil)
    else
      cont:add(key, value, nil)
    end
  end
  return cont
end
funcs.convertTable2Container = convertTable2Container

--- Function to convert a Container into a table
---@param cont Container Container to convert to Lua table
---@return auto[] data Created Lua table
local function convertContainer2Table(cont)
  local data = {}
  local containerList = Container.list(cont)
  local containerCheck = false
  if tonumber(containerList[1]) then
    containerCheck = true
  end
  for i=1, #containerList do

    local subContainer

    if containerCheck then
      subContainer = Container.get(cont, tostring(i) .. '.00')
    else
      subContainer = Container.get(cont, containerList[i])
    end
    if type(subContainer) == 'userdata' then
      if Object.getType(subContainer) == "Container" then

        if containerCheck then
          table.insert(data, convertContainer2Table(subContainer))
        else
          data[containerList[i]] = convertContainer2Table(subContainer)
        end

      else
        if containerCheck then
          table.insert(data, subContainer)
        else
          data[containerList[i]] = subContainer
        end
      end
    else
      if containerCheck then
        table.insert(data, subContainer)
      else
        data[containerList[i]] = subContainer
      end
    end
  end
  return data
end
funcs.convertContainer2Table = convertContainer2Table

--- Function to get content list out of table
---@param data string[] Table with data entries
---@return string sortedTable Sorted entries as string, internally seperated by ','
local function createContentList(data)
  local sortedTable = {}
  for key, _ in pairs(data) do
    table.insert(sortedTable, key)
  end
  table.sort(sortedTable)
  return table.concat(sortedTable, ',')
end
funcs.createContentList = createContentList

--- Function to get content list as JSON string
---@param data string[] Table with data entries
---@return string sortedTable Sorted entries as JSON string
local function createJsonList(data)
  local sortedTable = {}
  for key, _ in pairs(data) do
    table.insert(sortedTable, key)
  end
  table.sort(sortedTable)
  return funcs.json.encode(sortedTable)
end
funcs.createJsonList = createJsonList

--- Function to create a list from table
---@param content string[] Table with data entries
---@return string list String list
local function createStringListBySimpleTable(content)
  if content then
    local list = "["
    if #content >= 1 then
      list = list .. '"' .. content[1] .. '"'
    end
    if #content >= 2 then
      for i=2, #content do
        list = list .. ', ' .. '"' .. content[i] .. '"'
      end
    end
    list = list .. "]"
    return list
  else
    return ''
  end
end
funcs.createStringListBySimpleTable = createStringListBySimpleTable

--- Function to compare table content. Optionally will fill missing values within content table with values of defaultTable
---@param content auto Data to check
---@param defaultTable auto Reference data
---@return auto[] content Update of data
local function checkParameters(content, defaultTable)
  for key, value in pairs(defaultTable) do
    if type(value) == 'table' then
      if content[key] == nil then
        _G.logger:info(nameOfModule .. ": Created missing parameters table '" .. tostring(key) .. "'")
        content[key] = {}
      end
      content[key] = checkParameters(content[key], defaultTable[key])
    elseif content[key] == nil then
      _G.logger:info(nameOfModule .. ": Missing parameter '" .. tostring(key) .. "'. Adding default value '" .. tostring(defaultTable[key]) .. "'")
      content[key] = defaultTable[key]
    end
  end
  return content
end
funcs.checkParameters = checkParameters

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************