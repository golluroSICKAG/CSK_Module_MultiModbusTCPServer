-- Include all relevant FlowConfig scripts

--*****************************************************************
-- Here you will find all the required content to provide specific
-- features of this module via the 'CSK FlowConfig'.
--*****************************************************************

require('Communication/MultiModbusTCPServer/FlowConfig/MultiModbusTCPServer_SetValue')
require('Communication/MultiModbusTCPServer/FlowConfig/MultiModbusTCPServer_OnNewData')

--- Function to react if FlowConfig was updated
local function handleOnClearOldFlow()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    CSK_MultiModbusTCPServer.clearFlowConfigRelevantConfiguration()
  end
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)