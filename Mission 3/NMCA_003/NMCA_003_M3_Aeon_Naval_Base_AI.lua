local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local Difficulty = ScenarioInfo.Options.Difficulty

local M3_Aeon_Naval_Base = BaseManager.CreateBaseManager()
local Aeon = 2

function M3_Aeon_Naval_Base_Spawn()
	M3_Aeon_Naval_Base:Initialize(ArmyBrains[Aeon], 'M3_Aeon_Naval_Base', 'M3_Aeon_Naval_Base_Marker', 150, {M3_Aeon_Naval_Base = 200})
    M3_Aeon_Naval_Base:StartNonZeroBase({{3,4,5}, {1,2,2}})
	--M3_Aeon_Naval_Base_Land_Patrols()
end

function M3_Aeon_Naval_Base_Land_Patrols()
	--local opai = nil
	local Temp = {
		'M3_Aeon_Naval_Base_Land_Patrol_Template',
		'NoPlan',
		{ 'xal0203', 1, (4), 'Attack', 'GrowthFormation' },   -- Assault Tank
		{ 'ual0202', 1, (2), 'Attack', 'GrowthFormation' },   -- Flak AA
		{ 'ual0205', 1, (2), 'Attack', 'GrowthFormation' },   -- Flak AA
	}
	local Builder = {
		BuilderName = 'M3_Aeon_Naval_Base_Land_Patrol_Builder',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M3_Aeon_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = {'M3_Aeon_Naval_Base_Patrol'}
		},
	}
	ArmyBrains[Aeon]:PBMAddPlatoon( Builder )
end