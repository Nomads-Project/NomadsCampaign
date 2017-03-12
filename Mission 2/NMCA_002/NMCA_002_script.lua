---------------------------------
-- Nomads Campaign - Mission 2 --
---------------------------------
local Objectives = import('/lua/SimObjectives.lua')
local Buff = import('/lua/sim/Buff.lua')
local Cinematics = import('/lua/cinematics.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Difficulty = ScenarioInfo.Options.Difficulty
--local OpStrings   = import('/maps/NMCA_003/NMCA_003_strings.lua')

-- AI
local M1_UEF_Base_AI = import('/maps/NMCA_002/NMCA_002_M1_UEF_Base_AI.lua')
local Cybran_NW_Base_AI = import('/maps/NMCA_002/NMCA_002_Cybran_NW_Base_AI.lua')

-- Global Variables
AssignedObjectives = {}
ScenarioInfo.PlayerACU = {}
ScenarioInfo.OpEnded = false
ScenarioInfo.UEF = 1
ScenarioInfo.UEF_Disabled = 2
ScenarioInfo.Cybran = 3
ScenarioInfo.Nomad_Reinforcements = 4
ScenarioInfo.Player1 = 5
ScenarioInfo.Player2 = 6
ScenarioInfo.Player3 = 7
ScenarioInfo.Player4 = 8
PlayerColours = {[5]={r=250, g=250, b=0},[6]={r=189, g=183, b=107},[7]={r=255, g=255, b=165},[8]={r=255, g=192, b=0},}

-- Local Variables
local UEF = ScenarioInfo.UEF
local UEF_Disabled = ScenarioInfo.UEF_Disabled
local Cybran = ScenarioInfo.Cybran
local Nomad_Reinforcements = ScenarioInfo.Nomad_Reinforcements
local Player1 = ScenarioInfo.Player1
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4

function OnPopulate()
	ScenarioUtils.InitializeScenarioArmies()
	ScenarioFramework.SetPlayableArea('M1_Area', false)
	
	-- Set Unit Cap
	ScenarioFramework.SetSharedUnitCap(1000)
	
	-- Set Restrictions
	ScenarioFramework.AddRestrictionForAllHumans(categories.TECH3 + categories.TECH2 + categories.EXPERIMENTAL)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.inu2004 + categories.inb0201 + categories.inb0211 + categories.inb1202 + categories.inu1005 + categories.inb3201+ categories.inu3003)
	ScenarioFramework.RestrictEnhancements({'IntelProbe', 'IntelProbeAdv', 'GunUpgrade', 'DoubleGuns', 'MovementSpeedIncrease', 'ResourceAllocation', 'RapidRepair', 'PowerArmor', 'AdvancedEngineering', 'T3Engineering', 'OrbitalBombardment'})
	
	-- Set Army Colours
	ScenarioFramework.SetUEFColor(UEF)
	ScenarioFramework.SetUEFColor(UEF_Disabled)
	ScenarioFramework.SetCybranColor(Cybran)
	SetArmyColor("Nomad_Reinforcements", 255, 191, 128)
	
	-- Create M1 UEF Base
	M1_UEF_Base_AI.Base_Spawner()
	Cybran_NW_Base_AI.Base_Spawner()
	
	-- Debug vis markers
	
	ScenarioFramework.CreateVisibleAreaLocation(20, "UEF_M1_Land_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(20, "UEF_M1_Land_Base_2", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(25, "UEF_M1_Land_Base_3", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(20, "UEF_M1_Land_Base_4", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(30, "UEF_M1_Resource_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(25, "UEF_M1_Patrol_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(25, "UEF_M1_Air_Base_1", 0, ArmyBrains[Player1])
	
	ScenarioFramework.CreateVisibleAreaLocation(30, "Cybran_NW_Land_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(30, "Cybran_NW_Land_Base_2", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(27, "Cybran_NW_Land_Base_3", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(27, "Cybran_NW_Land_Base_4", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(30, "Cybran_NW_Eco_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(25, "Cybran_NW_Patrol_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(20, "Cybran_NW_Air_Base_1", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(20, "Cybran_NW_Air_Base_2", 0, ArmyBrains[Player1])
end
   
function OnStart()
	ScenarioInfo.CybranACU = ScenarioFramework.SpawnCommander('Cybran', 'ACU', false, 'Mr Cybran', true, PlayerDeath, {'AdvancedEngineering', 'StealthGenerator', 'CoolingUpgrade'})
	ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'Starting_Attack_1', 'GrowthFormation')
	ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'Starting_Attack_1', 'GrowthFormation')
	
	platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'Starting_Attack_2', 'GrowthFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_NW_Attack_Chain_3')
	platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'Starting_Attack_3', 'GrowthFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_NW_Attack_Chain_2')
	
	platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'Starting_Attack_2', 'GrowthFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'Cybran_NW_Land_Attack_Chain_3')
	platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'Starting_Attack_3', 'GrowthFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'Cybran_NW_Land_Attack_Chain_1')
	ForkThread(Intro_Mission_1)
end
   
function Intro_Mission_1()
	tblArmy = ListArmies()
	
	--Intro Cinematic
	Cinematics.EnterNISMode()
	ScenarioFramework.CreateVisibleAreaLocation(30, "Intro_Cine_Vis_Marker", 20, ArmyBrains[Player1])
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_1"), 0)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_1"), 1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_2"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_2"), 1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_3"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_3"), 1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_4"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_4"), 1.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_5"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_5"), 1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_6"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_6"), 1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_7"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_7"), 1.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_8"), 0.5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Intro_Cine_8"), 2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker(tostring(tblArmy[GetFocusArmy()])), 4)	--N.B the camer markers for eatch player double up as the starting spot markers observer is called nil
	Cinematics.ExitNISMode()
	ForkThread(SpawnInitalUnits)
	ForkThread(Start_Mission_1)
end

function Start_Mission_1()
	---------------------------------------------------------------------------
    -- Mission 1 Primary Objective 1 - Establish contact with the Cybran ACU --
    ---------------------------------------------------------------------------
    ScenarioInfo.M1P1 = Objectives.Protect(
        'primary',                    											-- type
        'incomplete',                   										-- complete
        'Establish contact with the Cybran ACU',  								-- title
        'Establish contact with the Cybran ACU',   								-- description
        {
			Units = {ScenarioInfo.CybranACU},
			Timer = nil,   														-- if nil, requires manual completion
			NumRequired = 1,          											-- how many must survive
        }
	)
    ScenarioInfo.M1P1:AddResultCallback(
        function(result)
            if(result) then
				LOG("TODO")
            end
        end
	)
	table.insert(AssignedObjectives, ScenarioInfo.M1P1)
	ForkThread(M1_South_Spawner)
	WaitSeconds(4)
	---------------------------------------------------------------------
    -- Mission 1 Secondary Objective 1 - Kill 10 units with nomads ACU --
    ---------------------------------------------------------------------
    ScenarioInfo.M1S1 = Objectives.UnitStatCompare(
        'secondary',                    										-- type
        'incomplete',                   										-- complete
        'ACU combat test',  													-- title
        'Kill 10 Units with the marked ACU',   									-- description
		'kill',																	-- action
        {
			Unit = ScenarioInfo.PlayerACU[5],
			StatName = 'KILLS',
			CompareOp = '>=',   												-- op is one of: '<=', '>=', '<', '>', or '=='
			Value = 10,
        }
	)
    ScenarioInfo.M1S1:AddResultCallback(
        function(result)
            if(result) then
				ScenarioFramework.RestrictEnhancements({'IntelProbe', 'IntelProbeAdv', 'DoubleGuns', 'ResourceAllocation', 'RapidRepair', 'PowerArmor', 'T3Engineering', 'OrbitalBombardment'})
            end
        end
	)
	ScenarioFramework.CreateTimerTrigger(Intro_Mission_2, 30)
end

function Intro_Mission_2()
	LOG("TODO")
	ScenarioFramework.SetPlayableArea('M2_Area', true)
	
    for _, player in ScenarioInfo.HumanPlayers do
        SetAlliance(player, Cybran, 'Ally')
    end
	Start_Mission_2()
end

function Start_Mission_2()
	------------------------------------------------------
    -- Mission 2 Primary Objective 1 - Destroy UEF Base --
    ------------------------------------------------------
	ScenarioInfo.M2P1 = Objectives.CategoriesInArea(
		'primary',                      					-- type
		'incomplete',                   					-- status
		'Destroy the UEF base',    							-- title
		'Help the Cybran commander destroy the UEF base',  	-- description
		'kill',                         					-- action
		{                              						-- target
			MarkUnits = false,
			Requirements = {
				{Area = 'North_UEF_Base', Category = categories.FACTORY + categories.ECONOMIC + categories.CONSTRUCTION, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
			},
		}
	)
    ScenarioInfo.M2P1:AddResultCallback(
        function(result)
            if(result) then
				LOG("TODO")
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M2P1)
	WaitSeconds(4)
	ScenarioInfo.M1P1:ManualResult(true)
	WaitSeconds(4)
	--------------------------------------------------------------------
    -- Mission 2 Secondary Objective 1 - Mark Targets of opportunity  --
    --------------------------------------------------------------------
	ScenarioInfo.M2S1 = Objectives.CategoriesInArea(
		'secondary',                      					-- type
		'incomplete',                   					-- status
		'Targets of opportunity - T2 power generators',    	-- title
		'These power generators are in a poorly defended area destroying them will cripple the production in the UEF base',  			-- description
		'kill',                         					-- action
		{                              						-- target
			MarkUnits = true,
			Requirements = {
				{Area = 'North_UEF_Base_Target_Op', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
			},
		}
	)
    ScenarioInfo.M2S1:AddResultCallback(
        function(result)
            if(result) then
				LOG("TODO")
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M2S1)
end

function Intro_Mission_3()
	LOG("TODO")
	ScenarioFramework.SetPlayableArea('M3_Area', true)
	Start_Mission_3()
end

function Start_Mission_3()
	LOG("TODO")
end

function SpawnInitalUnits()
	LOG("Spawning Players")
	for iArmy, strArmy in pairs(tblArmy) do
		if iArmy >= Player1 then
			SetArmyColor(strArmy, PlayerColours[iArmy].r, PlayerColours[iArmy].g, PlayerColours[iArmy].b)
			ScenarioInfo.PlayerACU[iArmy] = ScenarioFramework.SpawnCommander(strArmy, "ACU", "Warp", true, true, PlayerDeath)
		end
	end
end

function PlayerDeath(Player)
	LOG("ACU Death")
	if not ScenarioInfo.OpEnded then
		ScenarioFramework.CDRDeathNISCamera(Player)
		ForkThread(Mission_Failed)
	end
end

function Mission_Failed()
	LOG("Mission Failed")
	ScenarioFramework.EndOperationSafety()
	ScenarioFramework.FlushDialogueQueue()
	ScenarioInfo.OpComplete = false
	ForkThread(
		function()
			WaitSeconds(5)
			UnlockInput()
			Kill_Game()
		end
	)
    for k, v in AssignedObjectives do
        if(v and v.Active) then
            v:ManualResult(false)
        end
    end
end

function Player_Win()
	if(not ScenarioInfo.OpEnded) then
		ScenarioFramework.EndOperationSafety()
		ScenarioFramework.FlushDialogueQueue()
		ScenarioInfo.OpComplete = true
		ForkThread(
			function()
				WaitSeconds(5)
				UnlockInput()
				Kill_Game()
			end
		)
	end
end

function Kill_Game()
    UnlockInput()
    local allPrimaryCompleted = true
    local allSecondaryCompleted = true
    ScenarioFramework.EndOperation(ScenarioInfo.OpComplete, allPrimaryCompleted, allSecondaryCompleted)
end

function M1_South_Spawner()
	while ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active do
		if ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'SW_Attack_4', 'GrowthFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_1')
			WaitSeconds(12)
		end
		if ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'SW_Attack_1', 'GrowthFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_3')
			WaitSeconds(17)
		end
		if ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'SW_Attack_3', 'GrowthFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_2')
			WaitSeconds(25)
		end
		if ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'SW_Attack_2', 'GrowthFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_3')
			WaitSeconds(15)
		end
		if ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'SW_Attack_6', 'GrowthFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_3')
			WaitSeconds(18)
		end
		if ScenarioInfo.M1P1.Active or ScenarioInfo.M2P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'SW_Attack_5', 'GrowthFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_3')
			WaitSeconds(30)
		end
	end
end

-- Prints tables in the game log. usage: print_r ( table ) e.g print_r ( ScenarioInfo.PlayerCDR )
function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            LOG(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        LOG(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        LOG(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        LOG(indent.."["..pos..'] => "'..val..'"')
                    else
                        LOG(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                LOG(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        LOG(tostring(t).." {")
        sub_print_r(t,"  ")
        LOG("}")
    else
        sub_print_r(t,"  ")
    end
    LOG()
end