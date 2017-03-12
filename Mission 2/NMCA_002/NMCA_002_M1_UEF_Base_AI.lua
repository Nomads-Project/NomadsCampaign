local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local Difficulty = ScenarioInfo.Options.Difficulty

local UEF_M1_Land_Base_1 = BaseManager.CreateBaseManager()
local UEF_M1_Land_Base_2 = BaseManager.CreateBaseManager()
local UEF_M1_Land_Base_3 = BaseManager.CreateBaseManager()
local UEF_M1_Land_Base_4 = BaseManager.CreateBaseManager()
local UEF_M1_Air_Base_1 = BaseManager.CreateBaseManager()
local UEF_M1_Resource_Base_1 = BaseManager.CreateBaseManager()
local UEF_M1_Patrol_Base_1 = BaseManager.CreateBaseManager()

local UEF = 1

function Base_Spawner()
	UEF_M1_Land_Base_1:Initialize(ArmyBrains[UEF], "UEF_M1_Land_Base_1", "UEF_M1_Land_Base_1", 20, {UEF_M1_Land_Base_1 = 200})
	UEF_M1_Land_Base_1:StartNonZeroBase(6)
	
	UEF_M1_Land_Base_2:Initialize(ArmyBrains[UEF], "UEF_M1_Land_Base_2", "UEF_M1_Land_Base_2", 20, {UEF_M1_Land_Base_2 = 200})
	UEF_M1_Land_Base_2:StartNonZeroBase(6)
	
	UEF_M1_Land_Base_3:Initialize(ArmyBrains[UEF], "UEF_M1_Land_Base_3", "UEF_M1_Land_Base_3", 25, {UEF_M1_Land_Base_3 = 200})
	UEF_M1_Land_Base_3:StartNonZeroBase(6)
	
	UEF_M1_Land_Base_4:Initialize(ArmyBrains[UEF], "UEF_M1_Land_Base_4", "UEF_M1_Land_Base_4", 20, {UEF_M1_Land_Base_4 = 200})
	UEF_M1_Land_Base_4:StartNonZeroBase(6)
	
	UEF_M1_Air_Base_1:Initialize(ArmyBrains[UEF], "UEF_M1_Air_Base_1", "UEF_M1_Air_Base_1", 25, {UEF_M1_Air_Base_1 = 200})
	UEF_M1_Air_Base_1:StartNonZeroBase(6)
	
	UEF_M1_Resource_Base_1:Initialize(ArmyBrains[UEF], "UEF_M1_Resource_Base_1", "UEF_M1_Resource_Base_1", 30, {UEF_M1_Resource_Base_1 = 200})
    UEF_M1_Patrol_Base_1:SetActive('LandScouting', true)
	UEF_M1_Resource_Base_1:StartNonZeroBase(6)
	
	UEF_M1_Patrol_Base_1:Initialize(ArmyBrains[UEF], "UEF_M1_Patrol_Base_1", "UEF_M1_Patrol_Base_1", 25, {UEF_M1_Patrol_Base_1 = 200})
	UEF_M1_Patrol_Base_1:SetActive('AirScouting', true)
    UEF_M1_Patrol_Base_1:SetActive('LandScouting', true)
	UEF_M1_Patrol_Base_1:StartNonZeroBase(6)

	UEF_M1_Land_Base_1:AddExpansionBase('UEF_M1_Land_Base_2', 1)
	UEF_M1_Land_Base_1:AddExpansionBase('UEF_M1_Land_Base_3', 1)
	UEF_M1_Land_Base_1:AddExpansionBase('UEF_M1_Air_Base_1', 1)
	UEF_M1_Land_Base_1:AddExpansionBase('UEF_M1_Resource_Base_1', 1)
	UEF_M1_Land_Base_1:AddExpansionBase('UEF_M1_Patrol_Base_1', 1)
	
	UEF_M1_Land_Base_2:AddExpansionBase('UEF_M1_Land_Base_1', 1)
	UEF_M1_Land_Base_2:AddExpansionBase('UEF_M1_Land_Base_3', 1)
	UEF_M1_Land_Base_2:AddExpansionBase('UEF_M1_Air_Base_1', 1)
	UEF_M1_Land_Base_2:AddExpansionBase('UEF_M1_Resource_Base_1', 1)
	UEF_M1_Land_Base_2:AddExpansionBase('UEF_M1_Patrol_Base_1', 1)

	UEF_M1_Land_Base_3:AddExpansionBase('UEF_M1_Land_Base_1', 1)
	UEF_M1_Land_Base_3:AddExpansionBase('UEF_M1_Land_Base_2', 1)
	UEF_M1_Land_Base_3:AddExpansionBase('UEF_M1_Air_Base_1', 1)
	UEF_M1_Land_Base_3:AddExpansionBase('UEF_M1_Resource_Base_1', 1)
	UEF_M1_Land_Base_3:AddExpansionBase('UEF_M1_Patrol_Base_1', 1)
	
	UEF_M1_Air_Base_1:AddExpansionBase('UEF_M1_Land_Base_1', 1)
	UEF_M1_Air_Base_1:AddExpansionBase('UEF_M1_Land_Base_2', 1)
	UEF_M1_Air_Base_1:AddExpansionBase('UEF_M1_Land_Base_3', 1)
	UEF_M1_Air_Base_1:AddExpansionBase('UEF_M1_Resource_Base_1', 1)
	UEF_M1_Air_Base_1:AddExpansionBase('UEF_M1_Patrol_Base_1', 1)
	
	UEF_M1_Resource_Base_1:AddExpansionBase('UEF_M1_Land_Base_1', 1)
	UEF_M1_Resource_Base_1:AddExpansionBase('UEF_M1_Land_Base_2', 1)
	UEF_M1_Resource_Base_1:AddExpansionBase('UEF_M1_Land_Base_3', 1)
	UEF_M1_Resource_Base_1:AddExpansionBase('UEF_M1_Air_Base_1', 1)
	UEF_M1_Resource_Base_1:AddExpansionBase('UEF_M1_Patrol_Base_1', 1)
	
	UEF_M1_Patrol_Base_1:AddExpansionBase('UEF_M1_Land_Base_1', 1)
	UEF_M1_Patrol_Base_1:AddExpansionBase('UEF_M1_Land_Base_2', 1)
	UEF_M1_Patrol_Base_1:AddExpansionBase('UEF_M1_Land_Base_3', 1)
	UEF_M1_Patrol_Base_1:AddExpansionBase('UEF_M1_Air_Base_1', 1)
	UEF_M1_Patrol_Base_1:AddExpansionBase('UEF_M1_Resource_Base_1', 1)
	
	--Patrols
	M1_UEF_Base_Air_Patrols("UEF_M1_Patrol_Base_1", 12, 100)
	M1_UEF_Base_Air_Patrols("UEF_M1_Air_Base_1", 2, 20)
	
	--Static Guards
	M1_UEF_Base_Tank_Guard("UEF_M1_Resource_Base_1", 100, {"UEF_M1_Tank_Guard_1_Chain"})
	M1_UEF_Base_Tank_Guard("UEF_M1_Patrol_Base_1", 100, {"UEF_M1_Tank_Guard_2_Chain"})
	M1_UEF_Base_Tank_Guard("UEF_M1_Patrol_Base_1", 101, {"UEF_M1_Tank_Guard_3_Chain"})
	M1_UEF_Base_Tank_Guard("UEF_M1_Patrol_Base_1", 102, {"UEF_M1_Tank_Guard_4_Chain"})
	M1_UEF_Base_Tank_Guard("UEF_M1_Patrol_Base_1", 103, {"UEF_M1_Tank_Guard_5_Chain"})
	
	--Land Attacks
	M1_UEF_Base_Land_Attack_1("UEF_M1_Land_Base_1", 1, 100, {"UEF_M1_NW_Attack_Chain_4", "UEF_M1_NW_Attack_Chain_5"})
	M1_UEF_Base_Land_Attack_5("UEF_M1_Land_Base_1", 5, 99, {"UEF_M1_NW_Attack_Chain_3", "UEF_M1_NW_Attack_Chain_4", "UEF_M1_NW_Attack_Chain_5"})
	
	M1_UEF_Base_Land_Attack_4("UEF_M1_Land_Base_2", 1, 100, {"UEF_M1_NW_Attack_Chain_1", "UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_3"})
	M1_UEF_Base_Land_Attack_1("UEF_M1_Land_Base_2", 5, 99, {"UEF_M1_NW_Attack_Chain_1", "UEF_M1_NW_Attack_Chain_2"})
	
	M1_UEF_Base_Land_Attack_4("UEF_M1_Land_Base_4", 1, 100, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_3", "UEF_M1_NW_Attack_Chain_4"})
	M1_UEF_Base_Land_Attack_5("UEF_M1_Land_Base_4", 5, 100, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_3", "UEF_M1_NW_Attack_Chain_4"})
	
	M1_UEF_Base_Land_Attack_3("UEF_M1_Resource_Base_1", 4, 10, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_3", "UEF_M1_NW_Attack_Chain_4"})
	M1_UEF_Base_Land_Attack_2("UEF_M1_Patrol_Base_1", 4, 10, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_3", "UEF_M1_NW_Attack_Chain_4"})
	
	
	--Air Attacks
	M1_UEF_Base_Air_Attack_1("UEF_M1_Patrol_Base_1", 4, 10, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_4"})
	
	M1_UEF_Base_Air_Attack_2("UEF_M1_Air_Base_1", 5, 100, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_4"})
	M1_UEF_Base_Air_Attack_1("UEF_M1_Air_Base_1", 2, 99, {"UEF_M1_NW_Attack_Chain_2", "UEF_M1_NW_Attack_Chain_4"})

end

function M1_UEF_Base_Air_Patrols(Base, NumOfInstances, BuildPriority)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Air_Patrol_1_' .. Base,
		'NoPlan',
		{ 'uea0102', 1, (1), 'Attack', 'GrowthFormation' },   -- Interceptor
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Air_Patrol_1_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = {'UEF_M1_Air_Patrol_Chain'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Land_Attack_1(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Land_Attack_1_' .. Base,
		'NoPlan',
		{ 'uel0202', 1, (10), 'Attack', 'GrowthFormation' },   -- T2 Heavy Tank
		{ 'uel0103', 1, (6), 'Attack', 'GrowthFormation' },   -- T1 Arty
		{ 'uel0307', 1, (3), 'Attack', 'GrowthFormation' },   -- T2 Mobile Shield
		{ 'uel0104', 1, (3), 'Attack', 'GrowthFormation' },   -- T1 AA
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Land_Attack_1_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Land_Attack_2(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Land_Attack_2_' .. Base,
		'NoPlan',
		{ 'uel0201', 1, (4), 'Attack', 'GrowthFormation' },   -- T1 Med Tank
		{ 'uel0106', 1, (2), 'Attack', 'GrowthFormation' },   -- LAB
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Land_Attack_2_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Land_Attack_3(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Land_Attack_3_' .. Base,
		'NoPlan',
		{ 'uel0103', 1, (8), 'Attack', 'GrowthFormation' },   -- T1 Arty
		{ 'uel0106', 1, (2), 'Attack', 'GrowthFormation' },   -- LAB
		{ 'uel0101', 1, (1), 'Attack', 'GrowthFormation' },   -- T1 Scout
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Land_Attack_3_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Land_Attack_4(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Land_Attack_4_' .. Base,
		'NoPlan',
		{ 'uel0111', 1, (8), 'Attack', 'GrowthFormation' },   -- T2 MML
		{ 'uel0201', 1, (2), 'Attack', 'GrowthFormation' },   -- T1 Med Tank
		{ 'uel0205', 1, (3), 'Attack', 'GrowthFormation' },   -- T1 Arty
		{ 'uel0101', 1, (1), 'Attack', 'GrowthFormation' },   -- T1 Scout
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Land_Attack_4_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Land_Attack_5(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Land_Attack_5_' .. Base,
		'NoPlan',
		{ 'uel0202', 1, (4), 'Attack', 'GrowthFormation' },   -- T2 Heavy Tank
		{ 'uel0203', 1, (5), 'Attack', 'GrowthFormation' },   -- T2 Hover Tank
		{ 'uel0307', 1, (3), 'Attack', 'GrowthFormation' },   -- T1 Arty
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Land_Attack_5_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Air_Attack_1(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Air_Attack_1_' .. Base,
		'NoPlan',
		{ 'uea0103', 1, (2), 'Attack', 'GrowthFormation' },   -- T1 Bomber
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Air_Attack_1_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Air_Attack_2(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Air_Attack_2_' .. Base,
		'NoPlan',
		{ 'uea0203', 1, (6), 'Attack', 'GrowthFormation' },   -- T2 Gunship
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Air_Attack_2_Builder_' .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = NumOfInstances,
		Priority = BuildPriority,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function M1_UEF_Base_Tank_Guard(Base, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'M1_UEF_Base_Tank_Guard_1_' .. BuildPriority .. Base,
		'NoPlan',
		{ 'uel0202', 1, (1), 'Attack', 'GrowthFormation' },   -- T2 Heavy Tank
	}
	local Builder = {
		BuilderName = 'M1_UEF_Base_Tank_Guard_1_Builder_' .. BuildPriority .. Base,
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = BuildPriority,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = Base,
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},
		PlatoonData = {
			PatrolChains = Patrol
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end