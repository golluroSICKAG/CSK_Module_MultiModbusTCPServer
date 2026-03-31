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
  multiModbusTCPServerParameters.maxConnections = 10 -- Maximum number of synchronous connections
  multiModbusTCPServerParameters.transmitTimeout = 1000 -- Timeout in ms

  multiModbusTCPServerParameters.showLog = true -- Show log in UI

  multiModbusTCPServerParameters.connectionStatus = false -- Server connection status

  -- List of registers

  multiModbusTCPServerParameters.listOfDiscreteInputs = {}
  multiModbusTCPServerParameters.listOfDiscreteInputs.address = {}
  multiModbusTCPServerParameters.listOfDiscreteInputs.event = {}

  multiModbusTCPServerParameters.listOfCoils = {}
  multiModbusTCPServerParameters.listOfCoils.address = {}
  multiModbusTCPServerParameters.listOfCoils.event = {}

  multiModbusTCPServerParameters.listOfInputRegisters = {}
  multiModbusTCPServerParameters.listOfInputRegisters.address = {}
  multiModbusTCPServerParameters.listOfInputRegisters.dataType = {}
  multiModbusTCPServerParameters.listOfInputRegisters.event = {}

  multiModbusTCPServerParameters.listOfHoldingRegisters = {}
  multiModbusTCPServerParameters.listOfHoldingRegisters.address = {}
  multiModbusTCPServerParameters.listOfHoldingRegisters.dataType = {}
  multiModbusTCPServerParameters.listOfHoldingRegisters.event = {}

  --multiModbusTCPServerParameters.testTable = {}
  --multiModbusTCPServerParameters.testTable['A12'] = 'ValueABC'
  --table.insert(multiModbusTCPServerParameters.testTable, 'ValueA')

  --multiModbusTCPServerParameters.testTable.additionalTable = {}
  --table.insert(multiModbusTCPServerParameters.testTable.additionalTable, 'ValueB')
  --table.insert(multiModbusTCPServerParameters.testTable.additionalTable, 'ValueC')
  --multiModbusTCPServerParameters.testTable.additionalTable['A1'] = 'ValueB'
  --multiModbusTCPServerParameters.testTable.additionalTable['A3'] = 'ValueC'

  return multiModbusTCPServerParameters
end
functions.getParameters = getParameters

return functions