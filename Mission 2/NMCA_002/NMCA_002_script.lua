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

-- AI
local M1UEFAI = import('/maps/NMCA_002/M1_UEF_AI.lua')
local M1CybranAI = import('/maps/NMCA_002/M1_Cybran_AI.lua')
local M3UEFAI = import('/maps/NMCA_002/M3_UEF_AI.lua')
local M3CybranAI = import('/maps/NMCA_002/M3_Cybran_AI.lua')

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
ScenarioInfo.Civilian = 9
PlayerColours = {[5]={r=225, g=135, b=62},[6]={r=189, g=183, b=107},[7]={r=255, g=255, b=165},[8]={r=255, g=192, b=0},}

-- Local Variables
local UEF = ScenarioInfo.UEF
local UEF_Disabled = ScenarioInfo.UEF_Disabled
local Cybran = ScenarioInfo.Cybran
local Nomad_Reinforcements = ScenarioInfo.Nomad_Reinforcements
local Player1 = ScenarioInfo.Player1
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4
local Civilian = ScenarioInfo.Civilian

function OnPopulate()
	ScenarioUtils.InitializeScenarioArmies()
	ScenarioFramework.SetPlayableArea('M2_Area', false)
	
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
	SetArmyColor('Civilian', 165, 9, 1)
	SetArmyColor("Nomad_Reinforcements", 225, 135, 62)
	
	-- Create M1 UEF Base
	M1UEFAI.M1UEFBase()
	ScenarioUtils.CreateArmyGroup('UEF', 'M1_Walls')

	-- Create M1 Cybran Base
	M1CybranAI.M1CybranBase()
	ScenarioUtils.CreateArmyGroup('Cybran', 'M1_Cybran_Base_Walls')
	local Jammer = ScenarioUtils.CreateArmyUnit('Cybran', 'Jammer')
	Jammer:SetCustomName("Long Range Jammer")
	Jammer:SetCanBeKilled(false)
	Jammer:SetCanTakeDamage(false)
	
	-- Civilian Structures
	ScenarioUtils.CreateArmyGroup('Civilian', 'M1CivilianTechBase', true)

	-- Debug vis markers

	-- Spawn Initial Units
	ScenarioUtils.CreateArmyGroup('Cybran', 'M1_Cybran_Init_Units')
	ScenarioUtils.CreateArmyGroup('Cybran', 'M1_Cybran_Init_Destroyed', true)
	local UEFInitUnits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_UEF_Init_Units', 'GrowthFormation')
	ScenarioFramework.PlatoonPatrolChain(UEFInitUnits, 'M1_Init_Fight_Chain')
end
   
function OnStart()
	ScenarioInfo.CybranACU = ScenarioFramework.SpawnCommander('Cybran', 'ACU', false, 'Mr Cybran', true, PlayerDeath, {'AdvancedEngineering', 'StealthGenerator', 'CoolingUpgrade'})

	ForkThread(Intro_Mission_1)
end
   
function Intro_Mission_1()
	tblArmy = ListArmies()

	local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(75, 'M1_Init_Fight_Chain0', 0, ArmyBrains[Player1])
	local TankToTrack = ScenarioInfo.UnitNames[UEF]['CineTank']
	
	--Intro Cinematic
	Cinematics.EnterNISMode()
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M1_Init_Camera_1'), 0)

	WaitSeconds(2)

	Cinematics.CameraTrackEntity(TankToTrack, 15, 1)

	WaitSeconds(5)

	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M1_Init_Camera_2'), 3)

	WaitSeconds(3)

	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Player1'), 4)
	ForkThread(SpawnInitalUnits)

	WaitSeconds(5)

	ScenarioFramework.SetPlayableArea('M1_Area', true)

	VisMarker1_1:Destroy()
	ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('M1_Init_Fight_Chain0'), 75)
	Cinematics.ExitNISMode()

	ForkThread(CheatEconomy, Cybran)
	ForkThread(CheatEconomy, UEF)
	ForkThread(Start_Mission_1)
	ForkThread(M1_South_Spawner)

	local Patrol = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Air_Patrols_D'..Difficulty, 'GrowthFormation')

	-- Create M1 UEF Base Patrols
	for k, v in Patrol:GetPlatoonUnits() do
		ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_UEF_Air_Patrol')))
	end

	-- Create M1 Cybran Base Patrols
	local CybranPatrol = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'M1_Cybran_Base_Patrol', 'GrowthFormation')

	for k, v in CybranPatrol:GetPlatoonUnits() do
		ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_Cybran_Air_Patrol')))
	end

	-- Debug
	ScenarioFramework.SetPlayableArea('M2_Area', true)

	local function MissionNameAnnouncement()
        ScenarioFramework.SimAnnouncement(ScenarioInfo.name, 'mission by [e]JJs_AI')
    end

    ScenarioFramework.CreateTimerTrigger(MissionNameAnnouncement, 7)

    -- Create an Intel Trigger for the Cybran and the Player
    ScenarioFramework.CreateArmyIntelTrigger(FixCybranAlliance, ArmyBrains[Cybran], 'LOSNow', false, true,  categories.NOMADS, true, ArmyBrains[Player1] )

    -- Create another Intel Trigger for the UEF to attack the Player when seen
    ScenarioFramework.CreateArmyIntelTrigger(M1UEFAI.StartPlayerAttacks, ArmyBrains[UEF], 'LOSNow', false, true,  categories.NOMADS, true, ArmyBrains[Player1] )
end

function Start_Mission_1()
	---------------------------------------------------------------------------
    -- Mission 1 Primary Objective 1 - Establish contact with the Cybran ACU --
    ---------------------------------------------------------------------------
    ScenarioInfo.M1P1 = Objectives.Protect(
        'primary',                    											-- type
        'incomplete',                   										-- complete
        'Establish Contact with Cybran ACU',  								-- title
        'A Cybran Commander is fighting against the UEF. We could use this to our advantage. Establish contact with the Cybran Commander.',   								-- description
        {
			Units = {ScenarioInfo.CybranACU},
			FlashVisible = true,													-- if nil, requires manual completion
			NumRequired = 1,          											-- how many must survive
        }
	)
    ScenarioInfo.M1P1:AddResultCallback(
        function(result)
            if(result) then
				ForkThread(Intro_Mission_2)
            end
        end
	)
	table.insert(AssignedObjectives, ScenarioInfo.M1P1)

	WaitSeconds(4)

	---------------------------------------------------------------------
    -- Mission 1 Secondary Objective 1 - Kill 10 units with nomads ACU --
    ---------------------------------------------------------------------
    ScenarioInfo.M1S1 = Objectives.UnitStatCompare(
        'secondary',                    										-- type
        'incomplete',                   										-- complete
        'ACU Combat Test',  													-- title
        'Kill 10 enemy units with the marked ACU.',   									-- description
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
end

function Intro_Mission_2()
	-- Start Dialogue

	ScenarioFramework.SetPlayableArea('M2_Area', true)
	Start_Mission_2()
end

function Start_Mission_2()
	------------------------------------------------------
    -- Mission 2 Primary Objective 1 - Destroy UEF Base --
    ------------------------------------------------------
	ScenarioInfo.M2P1 = Objectives.CategoriesInArea(
		'primary',                      					-- type
		'incomplete',                   					-- status
		'Destroy Northern UEF Outpost',    							-- title
		'Our Cybran ally is being attacked. The UEF are assaulting us also. Destroy the northern UEF Outpost to put a stop to these attacks.',  	-- description
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
				ForkThread(Intro_Mission_3)
            end
        end
    )
    WaitSeconds(2)
	--------------------------------------------------------------------
    -- Mission 2 Secondary Objective 1 - Mark Targets of opportunity  --
    --------------------------------------------------------------------
	ScenarioInfo.M2S1 = Objectives.CategoriesInArea(
		'secondary',                      					-- type
		'incomplete',                   					-- status
		'Cripple UEF Production',    	-- title
		'These Power Generators are in a poorly defended area. Destroying them will cripple the production in the UEF base.',  			-- description
		'kill',                         					-- action
		{                              						-- target
			MarkUnits = true,
			MarkArea = true,
			Requirements = {
				{Area = 'UEF_M1_Power_Area', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
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
	ForkThread(Mission_3_Supply_Trucks)
	ScenarioFramework.SetPlayableArea('M3_Area', true)

	-- Disable Bases
	M1UEFAI.DisableBase()
	M1CybranAI.DisableBase()

	-- New AI
	M3UEFAI.M3UEFBase()
	M3CybranAI.M3CybranBase()
end

function Start_Mission_3()
    Mission_3_Supply_Trucks()
end

function Mission_3_Supply_Trucks()
	while ScenarioInfo.M3P1.Active do
		if ScenarioInfo.M3P1.Active then
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_Trucks', 'GrowthFormation')
			ScenarioFramework.PlatoonPatrolChain(platoon, 'UEF_M1_SW_Attack_Chain_1')
			WaitSeconds(180)
		end
	end
end

-- MISC FUNCTIONS --
function FixCybranAlliance()
    for _, Player in ScenarioInfo.HumanPlayers do
        SetAlliance(Player, Cybran, 'Ally')
        SetAlliance(Cybran, Player, 'Ally')
    end
    -- Create Objective for this
    ScenarioInfo.M1P1:ManualResult(true)

    ScenarioInfo.ProtectCybran = Objectives.Protect(
        'secondary',                    									-- type
        'incomplete',                   									-- complete
        'Ensure Safety of Cybran Commander',  								-- title
        'The Cybran will help us destroy the UEF Commander. Ensure his safety during the operation.',   								-- description
        {
			Units = {ScenarioInfo.CybranACU},									-- if nil, requires manual completion
			NumRequired = 1,          											-- how many must survive
        }
	)
	table.insert(AssignedObjectives, ScenarioInfo.ProtectCybran)
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
			platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'M1_South_Attacking_Units', 'AttackFormation', 5)
			ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_UEF_Attack_South')
			WaitSeconds(90)
		end
	end
end

function CheatEconomy(army)
    ArmyBrains[army]:GiveStorage('MASS', 10000)
    ArmyBrains[army]:GiveStorage('ENERGY', 10000)
    while(true) do
        ArmyBrains[army]:GiveResource('MASS', 10000)
        ArmyBrains[army]:GiveResource('ENERGY', 10000)
        WaitSeconds(1)
    end
end