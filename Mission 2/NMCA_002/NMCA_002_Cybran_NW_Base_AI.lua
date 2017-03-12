local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')
local Difficulty = ScenarioInfo.Options.Difficulty

local Cybran_NW_Land_Base_1 = BaseManager.CreateBaseManager()
local Cybran_NW_Land_Base_2 = BaseManager.CreateBaseManager()
local Cybran_NW_Land_Base_3 = BaseManager.CreateBaseManager()
local Cybran_NW_Land_Base_4 = BaseManager.CreateBaseManager()
local Cybran_NW_Air_Base_1 = BaseManager.CreateBaseManager()
local Cybran_NW_Air_Base_2 = BaseManager.CreateBaseManager()
local Cybran_NW_Eco_Base_1 = BaseManager.CreateBaseManager()
local Cybran_NW_Patrol_Base_1 = BaseManager.CreateBaseManager()

local Cybran = 3

function Base_Spawner()
	Cybran_NW_Land_Base_1:Initialize(ArmyBrains[Cybran], "Cybran_NW_Land_Base_1", "Cybran_NW_Land_Base_1", 20, {Cybran_NW_Land_Base_1 = 200})
	Cybran_NW_Land_Base_1:StartNonZeroBase(6)
	
	Cybran_NW_Land_Base_2:Initialize(ArmyBrains[Cybran], "Cybran_NW_Land_Base_2", "Cybran_NW_Land_Base_2", 20, {Cybran_NW_Land_Base_2 = 200})
	Cybran_NW_Land_Base_2:StartNonZeroBase(6)
	
	Cybran_NW_Air_Base_1:Initialize(ArmyBrains[Cybran], "Cybran_NW_Air_Base_1", "Cybran_NW_Air_Base_1", 25, {Cybran_NW_Air_Base_1 = 200})
	Cybran_NW_Air_Base_1:StartNonZeroBase(6)
	
	Cybran_NW_Air_Base_2:Initialize(ArmyBrains[Cybran], "Cybran_NW_Air_Base_2", "Cybran_NW_Air_Base_2", 25, {Cybran_NW_Air_Base_2 = 200})
	Cybran_NW_Air_Base_2:StartNonZeroBase(6)
	
	Cybran_NW_Eco_Base_1:Initialize(ArmyBrains[Cybran], "Cybran_NW_Eco_Base_1", "Cybran_NW_Eco_Base_1", 30, {Cybran_NW_Eco_Base_1 = 200})
	Cybran_NW_Eco_Base_1:StartNonZeroBase(6)
	
	Cybran_NW_Patrol_Base_1:Initialize(ArmyBrains[Cybran], "Cybran_NW_Patrol_Base_1", "Cybran_NW_Patrol_Base_1", 25, {Cybran_NW_Patrol_Base_1 = 200})
	Cybran_NW_Patrol_Base_1:StartNonZeroBase(6)
	
	Cybran_NW_Land_Base_3:Initialize(ArmyBrains[Cybran], "Cybran_NW_Land_Base_3", "Cybran_NW_Land_Base_3", 25, {Cybran_NW_Land_Base_3 = 200})
	Cybran_NW_Land_Base_3:StartNonZeroBase(6)
	
	Cybran_NW_Land_Base_4:Initialize(ArmyBrains[Cybran], "Cybran_NW_Land_Base_4", "Cybran_NW_Land_Base_4", 25, {Cybran_NW_Land_Base_4 = 200})
	Cybran_NW_Land_Base_4:StartNonZeroBase(6)
	
	Cybran_NW_Land_Base_1:AddExpansionBase('Cybran_NW_Land_Base_2', 1)
	Cybran_NW_Land_Base_1:AddExpansionBase('Cybran_NW_Land_Base_3', 1)
	Cybran_NW_Land_Base_1:AddExpansionBase('Cybran_NW_Air_Base_1', 1)
	Cybran_NW_Land_Base_1:AddExpansionBase('Cybran_NW_Eco_Base_1', 1)
	Cybran_NW_Land_Base_1:AddExpansionBase('Cybran_NW_Patrol_Base_1', 1)
	
	Cybran_NW_Land_Base_2:AddExpansionBase('Cybran_NW_Land_Base_1', 1)
	Cybran_NW_Land_Base_2:AddExpansionBase('Cybran_NW_Land_Base_3', 1)
	Cybran_NW_Land_Base_2:AddExpansionBase('Cybran_NW_Air_Base_1', 1)
	Cybran_NW_Land_Base_2:AddExpansionBase('Cybran_NW_Eco_Base_1', 1)
	Cybran_NW_Land_Base_2:AddExpansionBase('Cybran_NW_Patrol_Base_1', 1)

	Cybran_NW_Land_Base_3:AddExpansionBase('Cybran_NW_Land_Base_1', 1)
	Cybran_NW_Land_Base_3:AddExpansionBase('Cybran_NW_Land_Base_2', 1)
	Cybran_NW_Land_Base_3:AddExpansionBase('Cybran_NW_Air_Base_1', 1)
	Cybran_NW_Land_Base_3:AddExpansionBase('Cybran_NW_Eco_Base_1', 1)
	Cybran_NW_Land_Base_3:AddExpansionBase('Cybran_NW_Patrol_Base_1', 1)
	
	Cybran_NW_Air_Base_1:AddExpansionBase('Cybran_NW_Land_Base_1', 1)
	Cybran_NW_Air_Base_1:AddExpansionBase('Cybran_NW_Land_Base_2', 1)
	Cybran_NW_Air_Base_1:AddExpansionBase('Cybran_NW_Land_Base_3', 1)
	Cybran_NW_Air_Base_1:AddExpansionBase('Cybran_NW_Eco_Base_1', 1)
	Cybran_NW_Air_Base_1:AddExpansionBase('Cybran_NW_Patrol_Base_1', 1)
	
	Cybran_NW_Eco_Base_1:AddExpansionBase('Cybran_NW_Land_Base_1', 1)
	Cybran_NW_Eco_Base_1:AddExpansionBase('Cybran_NW_Land_Base_2', 1)
	Cybran_NW_Eco_Base_1:AddExpansionBase('Cybran_NW_Land_Base_3', 1)
	Cybran_NW_Eco_Base_1:AddExpansionBase('Cybran_NW_Air_Base_1', 1)
	Cybran_NW_Eco_Base_1:AddExpansionBase('Cybran_NW_Patrol_Base_1', 1)
	
	Cybran_NW_Patrol_Base_1:AddExpansionBase('Cybran_NW_Land_Base_1', 1)
	Cybran_NW_Patrol_Base_1:AddExpansionBase('Cybran_NW_Land_Base_2', 1)
	Cybran_NW_Patrol_Base_1:AddExpansionBase('Cybran_NW_Land_Base_3', 1)
	Cybran_NW_Patrol_Base_1:AddExpansionBase('Cybran_NW_Air_Base_1', 1)
	Cybran_NW_Patrol_Base_1:AddExpansionBase('Cybran_NW_Eco_Base_1', 1)
	
	--Land Attacks
	Cybran_NW_Base_Land_Attack_4("Cybran_NW_Land_Base_3", 1, 100, {"Cybran_NW_Land_Attack_Chain_3", "Cybran_NW_Land_Attack_Chain_4", "Cybran_NW_Land_Attack_Chain_5"})
	Cybran_NW_Base_Land_Attack_1("Cybran_NW_Land_Base_3", 5, 99, {"Cybran_NW_Land_Attack_Chain_4", "Cybran_NW_Land_Attack_Chain_5"})
	
	Cybran_NW_Base_Land_Attack_4("Cybran_NW_Land_Base_4", 1, 100, {"Cybran_NW_Land_Attack_Chain_2", "Cybran_NW_Land_Attack_Chain_3"})
	Cybran_NW_Base_Land_Attack_1("Cybran_NW_Land_Base_4", 5, 99, {"Cybran_NW_Land_Attack_Chain_1", "Cybran_NW_Land_Attack_Chain_2", "Cybran_NW_Land_Attack_Chain_3"})
	
	Cybran_NW_Base_Land_Attack_3("Cybran_NW_Patrol_Base_1", 4, 10, {"Cybran_NW_Land_Attack_Chain_2", "Cybran_NW_Land_Attack_Chain_3", "Cybran_NW_Land_Attack_Chain_4"})
	Cybran_NW_Base_Land_Attack_2("Cybran_NW_Eco_Base_1", 4, 10, {"Cybran_NW_Land_Attack_Chain_2", "Cybran_NW_Land_Attack_Chain_3", "Cybran_NW_Land_Attack_Chain_4"})
	
	--Air Attacks
	Cybran_NW_Base_Air_Attack_1("Cybran_NW_Patrol_Base_1", 4, 10, {"Cybran_NW_Land_Attack_Chain_2", "Cybran_NW_Land_Attack_Chain_4"})
	Cybran_NW_Base_Air_Attack_2("Cybran_NW_Air_Base_2", 4, 100, {"Cybran_NW_Land_Attack_Chain_2", "Cybran_NW_Land_Attack_Chain_4"})
end

function Cybran_NW_Base_Land_Attack_1(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'Cybran_NW_Base_Land_Attack_1_' .. Base,
		'NoPlan',
		{ 'url0202', 1, (6), 'Attack', 'GrowthFormation' },   -- T2 Heavy Tank
		{ 'url0203', 1, (4), 'Attack', 'GrowthFormation' },   -- T2 Water Tank
		{ 'url0103', 1, (4), 'Attack', 'GrowthFormation' },   -- T1 Arty
		{ 'url0104', 1, (4), 'Attack', 'GrowthFormation' },   -- T1 AA
	}
	local Builder = {
		BuilderName = 'Cybran_NW_Base_Land_Attack_1_Builder_' .. Base,
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
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function Cybran_NW_Base_Land_Attack_2(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'Cybran_NW_Base_Land_Attack_2_' .. Base,
		'NoPlan',
		{ 'url0107', 1, (6), 'Attack', 'GrowthFormation' },   -- Mantis
		{ 'url0106', 1, (4), 'Attack', 'GrowthFormation' },   -- LAB
	}
	local Builder = {
		BuilderName = 'Cybran_NW_Base_Land_Attack_2_Builder_' .. Base,
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
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function Cybran_NW_Base_Land_Attack_3(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'Cybran_NW_Base_Land_Attack_3_' .. Base,
		'NoPlan',
		{ 'url0103', 1, (6), 'Attack', 'GrowthFormation' },   -- T1_Arty
		{ 'url0101', 1, (1), 'Attack', 'GrowthFormation' },   -- T1 Scout
		{ 'url0106', 1, (2), 'Attack', 'GrowthFormation' },   -- LAB
	}
	local Builder = {
		BuilderName = 'Cybran_NW_Base_Land_Attack_3_Builder_' .. Base,
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
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function Cybran_NW_Base_Land_Attack_4(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'Cybran_NW_Base_Land_Attack4_' .. Base,
		'NoPlan',
		{ 'url0111', 1, (6), 'Attack', 'GrowthFormation' },   -- T2 MML
		{ 'url0101', 1, (1), 'Attack', 'GrowthFormation' },   -- T1 Scout
		{ 'url0103', 1, (4), 'Attack', 'GrowthFormation' },   -- T1 Arty
		{ 'url0205', 1, (3), 'Attack', 'GrowthFormation' },   -- T2 AA
	}
	local Builder = {
		BuilderName = 'Cybran_NW_Base_Land_Attack_4_Builder_' .. Base,
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
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function Cybran_NW_Base_Air_Attack_1(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'Cybran_NW_Base_Air_Attack_1_' .. Base,
		'NoPlan',
		{ 'ura0103', 1, (2), 'Attack', 'GrowthFormation' },   -- T1 Bomber
	}
	local Builder = {
		BuilderName = 'Cybran_NW_Base_Air_Attack_1_Builder_' .. Base,
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
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end


function Cybran_NW_Base_Air_Attack_2(Base, NumOfInstances, BuildPriority, Patrol)
	--local opai = nil
	local Temp = {
		'Cybran_NW_Base_Air_Attack_2_' .. Base,
		'NoPlan',
		{ 'ura0203', 1, (3), 'Attack', 'GrowthFormation' },   -- T1 Bomber
	}
	local Builder = {
		BuilderName = 'Cybran_NW_Base_Air_Attack_2_Builder_' .. Base,
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
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end