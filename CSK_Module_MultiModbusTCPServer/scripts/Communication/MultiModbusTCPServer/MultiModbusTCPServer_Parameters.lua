---@diagnostic disable: redundant-parameter, undefined-global

--***************************************************************
-- Inside of this script, you will find the relevant parameters
-- for this module and its default values
--***************************************************************

local functions = {}

local function getParameters()

  local multiModbusTCPServerParameters = {}
  multiModbusTCPServerParameters.flowConfigPriority = CSK_FlowConfig ~= nil or false -- Status if FlowConfig should have priority for FlowConfig relevant configurations
  multiModbusTCPServerParameters.processingFile = 'CSK_MultiModbusTCPServer_Processing' -- which file to use for processing (will be started in own thread)

  multiModbusTCPServerParameters.interface = '' -- Interface to use (must be set individually)
  multiModbusTCPServerParameters.port = 502 -- Port of Modbus TCP connection

  multiModbusTCPServerParameters.connectionStatus = false -- Server connection status

  -- List of variables
  multiModbusTCPServerParameters.listOfInputVariables = {}
  multiModbusTCPServerParameters.listOfInputVariables.names = {}
  multiModbusTCPServerParameters.listOfInputVariables.size = {}
  multiModbusTCPServerParameters.listOfInputVariables.event = {}

  multiModbusTCPServerParameters.listOfHoldingVariables = {}
  multiModbusTCPServerParameters.listOfHoldingVariables.names = {}
  multiModbusTCPServerParameters.listOfHoldingVariables.size = {}
  multiModbusTCPServerParameters.listOfHoldingVariables.event = {}

  return multiModbusTCPServerParameters
end
functions.getParameters = getParameters

return functions