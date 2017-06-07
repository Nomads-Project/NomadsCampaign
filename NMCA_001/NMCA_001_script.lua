#****************************************************************************
#**
#**  File     :  /maps/NMCA_001/NMCA_001_script.lua
#**  Author(s):  JJs_AI, Tokyto_
#**
#**  Summary  :  Ths script for the first mission of the Nomads campaign.
#**
#****************************************************************************

local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utilities = import('/lua/utilities.lua')
local Cinematics = import('/lua/cinematics.lua')
local OpStrings = import('/maps/NMCA_001/NMCA_001_strings.lua')
local TauntManager = import('/lua/TauntManager.lua')
local PingGroups = import('/lua/ScenarioFramework.lua').PingGroups

----------
-- AI
----------
local M1OutpostAI = import('/maps/NMCA_001/NMCA_001_M1_AI.lua')
local M3BaseAI = import('/maps/NMCA_001/NMCA_001_M3_AI.lua')

ScenarioInfo.Player1 = 1
ScenarioInfo.UEF = 2
ScenarioInfo.Civilian = 3
ScenarioInfo.Nomads = 4
ScenarioInfo.Coop1 = 5
ScenarioInfo.Coop2 = 6
ScenarioInfo.Coop3 = 7

local Player1 = ScenarioInfo.Player1
local UEF = ScenarioInfo.UEF
local Civilian = ScenarioInfo.Civilian
local Nomads = ScenarioInfo.Nomads
local Player2 = ScenarioInfo.Coop1
local Player3 = ScenarioInfo.Coop2
local Player4 = ScenarioInfo.Coop3

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFM1Timer = {900, 600, 450}
local TMLTimer = {450, 375, 300}
local M1TransportTimer = {450, 400, 350}
local BombAbilCoolDown = {240, 300, 420}

local Spotted = false
local TMLAlive = true
local PlayerLost = false
local FactoryCaptured = false

local AssignedObjectives = {}

----------------
-- Taunt Managers
----------------
local M1UEFTM = TauntManager.CreateTauntManager('M1UEFTM', '/maps/NMCA_001/NMCA_001_strings.lua')
local M3UEFTM = TauntManager.CreateTauntManager('M3UEFTM', '/maps/NMCA_001/NMCA_001_strings.lua')
  
function OnPopulate()
	ScenarioUtils.InitializeScenarioArmies()

	SetArmyColor('Player1', 225, 135, 62)
	SetArmyColor('UEF', 41, 40, 140)
	SetArmyColor('Civilian', 71, 114, 148)
    SetArmyColor('Nomads', 225, 135, 62)

	----------
	-- Coop Colours
	----------

	----------
	-- Unit Cap
	----------
	SetArmyUnitCap(Player1, 300)
	SetArmyUnitCap(UEF, 1000)
	SetArmyUnitCap(Civilian, 200)
end
  
function OnStart(self)
	ScenarioFramework.SetPlayableArea('M1', false)

	----------
	-- Remove the Pesky Ship
	----------
    local OrbitalShip = GetEntityById('INO0001')

    OrbitalShip:Destroy()

	----------
	-- Restrictions
	----------
	for _, player in ScenarioInfo.HumanPlayers do
    	ScenarioFramework.AddRestriction(player, categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
    	ScenarioFramework.AddRestriction(player, categories.ina1003) # Attack Bomber
    	ScenarioFramework.AddRestriction(player, categories.uel0105) # UEF Engineer
    	ScenarioFramework.AddRestriction(player, categories.ina1005) # Transport Drone
    	ScenarioFramework.AddRestriction(player, categories.inu1004) # Medium Tank
    	ScenarioFramework.AddRestriction(player, categories.inu1008) # Tank Destroyer
    	ScenarioFramework.AddRestriction(player, categories.NAVAL) # Navy
	end

	----------
	-- Set Storage
	----------
	ForkThread(function()
        for _, player in ScenarioInfo.HumanPlayers do
    		ArmyBrains[player]:GiveStorage('ENERGY', 4000)
    		ArmyBrains[player]:GiveStorage('MASS', 650)
            WaitSeconds(2)
            ArmyBrains[player]:GiveResource('ENERGY', 4000)
    		ArmyBrains[player]:GiveResource('MASS', 650)
    	end
    end)

	----------
	-- Spawn Things
	----------
	local Engineers = ScenarioUtils.CreateArmyGroup('Player1', 'Engineers')
	ScenarioInfo.Ship = ScenarioUtils.CreateArmyUnit('Player1', 'Ship')

	local CivilBuildings = ScenarioUtils.CreateArmyGroup('Civilian', 'CivilianGroup')
	ScenarioInfo.UEFTech = ScenarioUtils.CreateArmyUnit('UEF', 'TechCentre')
    ScenarioInfo.UEFFactory = ScenarioInfo.UnitNames[Civilian]['Factory']

    ScenarioInfo.UEFTech:SetCanTakeDamage(false)
    ScenarioInfo.UEFTech:SetCanBeKilled(false)
    ScenarioInfo.UEFTech:SetDoNotTarget(true)
    ScenarioInfo.UEFTech:SetReclaimable(false)

	local Walls = ScenarioUtils.CreateArmyGroup('UEF', 'M1Walls')

	ScenarioInfo.Ship:SetCustomName('High Command Ship')
	ScenarioInfo.UEFTech:SetCustomName('Tech Centre')
	
	for _, v in Engineers do
        IssueMove({v}, ScenarioUtils.MarkerToPosition('M1_Nomads_Engineer_Move_Marker'))
    end

    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'AirPatrol_' .. Difficulty, 'NoFormation')

    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_AirPatrol_Chain')))
    end

    local LabPatrol_1 = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'LabPatrol_1', 'GrowthFormation')

    for k, v in LabPatrol_1:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('LabPatrol_1_Chain')))
    end

    local LabPatrol_2 = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'LabPatrol_2', 'GrowthFormation')

    for k, v in LabPatrol_2:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('LabPatrol_2_Chain')))
    end

    local LabPatrol_3 = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'LabPatrol_3', 'GrowthFormation')

    for k, v in LabPatrol_3:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('LabPatrol_3_Chain')))
    end

    ----------
	-- Run AI
	----------
    M1OutpostAI.UEFOutpostAI()

    ----------
	-- Cinematics
	----------
	ForkThread(M1NIS)
end

function PlayerWin()
    KillGame()
end

function PlayerLose(Ship)
	----------
	-- Player Lost Game
	----------
    PlayerLost = true


    Ship:SetCanBeKilled(false)
    Ship:SetReclaimable(false)

    -- Mark objectives as failed
    for k, v in AssignedObjectives do
        if(v and v.Active) then
            v:ManualResult(false)
        end
    end

	ScenarioFramework.CDRDeathNISCamera(Ship)

	local UEFUnits = GetUnitsInRect(ScenarioUtils.AreaToRect('M1'))
    M1OutpostAI.DisableBase()
    ScenarioFramework.EndOperationSafety()
	
	for k, v in UEFUnits do
	    if v and not v:IsDead() and (v:GetAIBrain() == ArmyBrains[UEF]) then
            v:Stop()
	    end
	end

    local NISUnits = ScenarioUtils.CreateArmyGroup('UEF', 'PlayerLose')
    for k, v in NISUnits do
    	v:SetFireState('HoldFire')
        IssueAttack({v}, Ship)
    end
end

function KillGame()
    ForkThread(
        function()
            ScenarioFramework.EndOperation(ScenarioInfo.OpComplete, ScenarioInfo.OpComplete)
        end
    )
end

function M1NIS()
	local Engineer1 = ScenarioInfo.UnitNames[Player1]['Engineer_1']
    local Engineer2 = ScenarioInfo.UnitNames[Player1]['Engineer_2']
    local Engineer3 = ScenarioInfo.UnitNames[Player1]['Engineer_3']
    local Engineer4 = ScenarioInfo.UnitNames[Player1]['Engineer_4']

	ScenarioFramework.CreateUnitDamagedTrigger(PlayerLose, ScenarioInfo.Ship, .75)

	WaitSeconds(1)

	Cinematics.EnterNISMode()

	ScenarioFramework.Dialogue(OpStrings.IntroNIS_Dialogue, nil, true)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01a'), 0)
	WaitSeconds(.5)
	Cinematics.CameraTrackEntity(Engineer1, 40, 3)

	WaitSeconds(7)

	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01b'), 2)

	Cinematics.ExitNISMode()

    if ScenarioInfo.HumanPlayers == 2 then
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer2, Player2)
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer3, Player2)
    elseif ScenarioInfo.HumanPlayers == 3 then
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer2, Player2)
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer3, Player3)
    elseif ScenarioInfo.HumanPlayers == 4 then
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer2, Player2)
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer3, Player3)
        ScenarioFramework.GiveUnitToArmy(ScenarioInfo.Engineer4, Player4)
    end

	WaitSeconds(1)
	ForkThread(M1)
end


function M1()
	ScenarioFramework.CreateTimerTrigger(M1StartUEFScouting, UEFM1Timer[Difficulty])

	local function MissionNameAnnouncement()
        ScenarioFramework.SimAnnouncement(ScenarioInfo.name, 'mission by [e]JJs_AI')
    end

    ScenarioFramework.CreateTimerTrigger(MissionNameAnnouncement, 7)

    ScenarioInfo.M1P1 = Objectives.Protect(
        'primary',                    -- type
        'incomplete',                   -- complete
        'Defend Command Ship',  -- title
        'Defend the Command Ship at all costs. We need it to leave this planet.',  -- description
        {                               -- target
            Units = {ScenarioInfo.Ship},
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P1)

	ScenarioFramework.CreateArmyIntelTrigger(ForkAttackThread, ArmyBrains[UEF], 'LOSNow', false, true,  categories.NOMADS, true, ArmyBrains[Player1] )
end

function M1StartUEFScouting()
	----------
	-- Scouting Starts
	----------
	local Scouts = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'Scouts','NoFormation')

	for k, v in Scouts:GetPlatoonUnits() do
    	ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_UEF_Scout_Chain')))
    end
end

function ForkAttackThread()
	ForkThread(M1StartUEFAttacks)
end

function M1StartUEFAttacks()
	if not Spotted then
		ScenarioFramework.Dialogue(OpStrings.UEF_Notice, nil, true)
		
		WaitSeconds(7)	

		local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(10, 'M1_Vis_1_1', 0, ArmyBrains[Player1])
		ScenarioInfo.TacLauncher = ScenarioInfo.UnitNames[UEF]['TacMissile']

		Cinematics.EnterNISMode()

		Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01c'), 0)
		WaitSeconds(4)
		IssueTactical({ScenarioInfo.TacLauncher}, ScenarioInfo.Ship)
		WaitSeconds(5)	

		Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01b'), 2)

		VisMarker1_1:Destroy()

		Cinematics.ExitNISMode()

		WaitSeconds(10)	
		ScenarioFramework.Dialogue(OpStrings.M1_Scream_Incoming, nil, true)
		WaitSeconds(9)
		ScenarioFramework.Dialogue(OpStrings.M1_Update_Commander, nil, true)

	    Spotted = true

		----------
		-- Start Attacks
		----------
		M1OutpostAI.M1LandAttacks()
		M1OutpostAI.M1AirAttacks()

		----------
		-- Set Timer for Missile Launches
		----------
		ScenarioFramework.CreateUnitDeathTrigger(TacDead, ScenarioInfo.TacLauncher)
		ScenarioFramework.CreateTimerTrigger(LaunchTac, TMLTimer[Difficulty])
		ScenarioFramework.CreateTimerTrigger(M1Reinforcements, M1TransportTimer[Difficulty])

		WaitSeconds(10)

        UEFM1Taunts()

		ForkThread(M2)

        WaitSeconds(7)
        ScenarioFramework.PlayUnlockDialogue()
        for _, player in ScenarioInfo.HumanPlayers do
            ScenarioFramework.RemoveRestriction(player, categories.ina1003)
            ScenarioFramework.RemoveRestriction(player, categories.ina1005)
        end
	end
end

function M1Reinforcements()
    if not PlayerLost and ScenarioInfo.M2P1.Active then
    	----------
    	-- Transports
    	----------
    	local allUnits = {}

    	local base_units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_Reinforcements','AttackFormation')
    	local attack_units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_Reinforcements_Attack', 'AttackFormation')

    	for i = 1, 4 do
    	   	local transport = ScenarioUtils.CreateArmyUnit('UEF', 'M2_Transport')

    	    for _, v in attack_units do
    	        table.insert(allUnits, v)
    	    end

    	    ScenarioFramework.AttachUnitsToTransports(attack_units:GetPlatoonUnits(), {transport})
    	    WaitSeconds(0.5)

    		IssueTransportUnload({transport}, ScenarioUtils.MarkerToPosition('M2_Transport_Drop_' .. i))

    		IssueMove({transport}, ScenarioUtils.MarkerToPosition('UEF_Main_Base'))

    		attack_units.PlatoonData = {}
    		attack_units.PlatoonData.PatrolChain = ('M2_Transport_Attack_Route')
    		ScenarioPlatoonAI.PatrolThread(attack_units)
    	end

    	for i = 1, 2 do
    	   	local transport = ScenarioUtils.CreateArmyUnit('UEF', 'M2_Transport')

    	    for _, v in base_units do
    	        table.insert(allUnits, v)
    	    end

    	    ScenarioFramework.AttachUnitsToTransports(base_units:GetPlatoonUnits(), {transport})
    	    WaitSeconds(0.5)

    		IssueTransportUnload({transport}, ScenarioUtils.MarkerToPosition('M2_Transport_Base_Drop_' .. i))

    		IssueMove({transport}, ScenarioUtils.MarkerToPosition('UEF_Main_Base'))

    		base_units.PlatoonData = {}
    		base_units.PlatoonData.PatrolChain = ('M2_Outpost_Patrol')
    		ScenarioPlatoonAI.PatrolThread(base_units)
    	end
    end
end

function M2()
	----------
	-- Objectives
	----------
	ScenarioInfo.M2P1 = Objectives.CategoriesInArea(
    'primary',                      -- type
    'incomplete',                   -- complete
    'Destroy Enemy Outpost',  -- title
    'Enemy forces are hammering our position! Destroy the enemy outpost to soften the attacks.',  -- description
    'kill',
    {
        MarkUnits = false,
        Requirements = {
            { Area = 'M1Outpost', Category = categories.FACTORY + categories.ENGINEER, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
        },
    })
    table.insert(AssignedObjectives, ScenarioInfo.M2P1)

    ScenarioInfo.M2P2 = Objectives.KillOrCapture(
    'primary',                      -- type
    'incomplete',                   -- complete
    'Destroy Tactical Missile Launcher',  -- title
    'The Enemy Commander has a Missile Launcher firing at our ship. Destroy it before we take too much damage.',  -- description
        {                               -- target
            Units = {ScenarioInfo.TacLauncher}
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P2)

    ScenarioInfo.M2P1:AddResultCallback(
    function(result)
        if(result) then
            ScenarioFramework.Dialogue(OpStrings.UEFOutpost_Dead, nil, true)
            Cinematics.EnterNISMode()
            Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_02b'), 1)
            WaitSeconds(4)
            Cinematics.ExitNISMode()
        	ForkThread(M2Capture)
        end
    end)
end

function M2Capture()
    ----------
    -- Spawn Base
    ----------
    local M3Walls = ScenarioUtils.CreateArmyGroup('UEF', 'M3Walls')
    local Engineers = ScenarioUtils.CreateArmyGroup('UEF', 'M3Engineers')

    ----------
    -- Run AI
    ----------
    M3BaseAI.UEFBaseAI()
    ScenarioInfo.EnemyCommander = ScenarioUtils.CreateArmyUnit('UEF', 'Commander')
    ScenarioInfo.EnemyCommander:SetCustomName("CDR Parker")

    if Difficulty == 1 then
        ScenarioInfo.EnemyCommander:CreateEnhancement('AdvancedEngineering')
        ScenarioInfo.EnemyCommander:CreateEnhancement('LeftPod')
        ScenarioInfo.EnemyCommander:CreateEnhancement('RightPod')
    elseif Difficulty == 2 then
        ScenarioInfo.EnemyCommander:CreateEnhancement('AdvancedEngineering')
        ScenarioInfo.EnemyCommander:CreateEnhancement('Shield')
        ScenarioInfo.EnemyCommander:CreateEnhancement('ResourceAllocation')   
    elseif Difficulty == 3 then
        ScenarioInfo.EnemyCommander:CreateEnhancement('AdvancedEngineering')
        ScenarioInfo.EnemyCommander:CreateEnhancement('Shield')
        ScenarioInfo.EnemyCommander:CreateEnhancement('HeavyAntiMatterCannon')
    end

    ----------
    -- Spawn PBase
    ----------
    local PBase = ScenarioUtils.CreateArmyGroup('UEF', 'PowerBase')
    local PBaseWalls = ScenarioUtils.CreateArmyGroup('UEF', 'M3PWalls')
    ScenarioInfo.Shields = ScenarioUtils.CreateArmyGroup('UEF', 'M3Shields')

    ----------
    -- Spawn Patrols
    ----------
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_AirPatrol_' .. Difficulty, 'NoFormation')

    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_AirPatrol_Chain')))
    end

    local AttackUnits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_Init_Attack_' .. Difficulty, 'AttackFormation')

    for k, v in AttackUnits:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_LandAttack_Chain')))
    end

    local PBasePatrol = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3PBasePatrol', 'NoFormation')

    for k, v in PBasePatrol:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_PBase_Patrol_Chain')))
    end

    ----------
    -- Dialogue
    ----------
    ScenarioFramework.Dialogue(OpStrings.M2_Update_Commander, M2ObjectviesExtended, true)
end

function M2ObjectviesExtended()
    ----------
    -- Objectives
    ----------
    ScenarioInfo.M2P3 = Objectives.Capture(
    'primary',                      -- type
    'incomplete',                   -- complete
    'Capture Enemy Tech Centre',  -- title
    'We need to find out what is going on. Capture the enemy tech centre so we can access the data.',  -- description
    {
        MarkUnits = true,
        Units = {ScenarioInfo.UEFTech},
    })
    table.insert(AssignedObjectives, ScenarioInfo.M2P3)

    ScenarioInfo.M2S1 = Objectives.Capture(
    'secondary',                      -- type
    'incomplete',                   -- complete
    'Capture Enemy Factory',  -- title
    'Our Tech is very weak compared to the enemy. Capture one of their factories to gain an advantage.',  -- description
        {
            MarkUnits = true,                               -- target
            Units = {ScenarioInfo.UEFFactory},
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2S1)

    ScenarioInfo.M2P3:AddResultCallback(
    function(result)
        if(result) then
            ScenarioFramework.Dialogue(OpStrings.M2TechCaptured, M3, true)
        end
    end)

    ScenarioInfo.M2S1:AddResultCallback(
    function(result, unit)
        ScenarioInfo.UEFFactory = unit
        FactoryCaptured = true
        ScenarioFramework.Dialogue(OpStrings.UEFTauntFactory, nil, true)
    end)
end

function M3()
    ForkThread(function()
        WaitSeconds(1)
    end)

    ScenarioFramework.SetPlayableArea('M3', true)

    ForkThread(function()
        WaitSeconds(3)
    end)

    ScenarioFramework.Dialogue(OpStrings.M3_Update_Commander, nil, true)
    if FactoryCaptured then
        ScenarioFramework.CreateTimerTrigger(M3SetFactoryObjective, 120)
    end

    ----------
    -- Cinematics
    ----------
    local VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(80, 'M3_UEF_Base_Marker', 0, ArmyBrains[Player1])
    local VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(40, 'M3PBase', 0, ArmyBrains[Player1])

    ForkThread(function()
        Cinematics.EnterNISMode()
        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_03a'), 1)
        WaitSeconds(1)
        Cinematics.CameraTrackEntity(ScenarioInfo.EnemyCommander, 40, 2)
        WaitSeconds(5)
        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_03b'), 1)
        WaitSeconds(5)
        VisMarker3_1:Destroy()
        VisMarker3_2:Destroy()
        ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('M3_UEF_Base_Marker'), 80)
        ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('M3PBase'), 40)
        Cinematics:ExitNISMode()
    end)

    ----------
    -- Unlock T2 Air Factory
    ----------
    ScenarioFramework.PlayUnlockDialogue()
    for _, player in ScenarioInfo.HumanPlayers do
        ScenarioFramework.RemoveRestriction(player, categories.inb0202)
        ScenarioFramework.RemoveRestriction(player, categories.inb0212)
    end

    ----------
    -- Objectives
    ----------
    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
    'primary',                      -- type
    'incomplete',                   -- complete
    'Destroy Enemy Commander',  -- title
    'The Enemy Commander is in sight and we need to kill him. Use all available units to destroy him.', -- description
        {                               -- target
            Units = {ScenarioInfo.EnemyCommander}
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3P1)

    ScenarioInfo.M3S1 = Objectives.CategoriesInArea(
    'secondary',                      -- type
    'incomplete',                   -- complete
    'Destroy Enemy Power Generators',  -- title
    'We believe this Power Station is powering the shields in the enemy base. Destroy them.',  -- description
    'kill',
    {
        MarkUnits = true,
        Requirements = {
            { Area = 'M3Power', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
            { Area = 'M3Power', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
            { Area = 'M3Power', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
        },
    })

    table.insert(AssignedObjectives, ScenarioInfo.M3S1)

    ScenarioInfo.M3S2 = Objectives.CategoriesInArea(
    'secondary',                      -- type
    'incomplete',                   -- complete
    'Construct Tech 2 Air Factory',  -- title
    'Our Tech 2 Air Factories provide the ability to call in orbital strikes. Construct one and use the ability.',  -- description
    'Build',
    {
        MarkUnits = false,
        MarkArea = false,
        Requirements =
        {
            {Area = 'M3', Category = categories.inb0202, CompareOp = '>=', Value = 1, ArmyIndex = Player1},
        },
    })

    table.insert(AssignedObjectives, ScenarioInfo.M3S2)

    ScenarioInfo.M3P1:AddResultCallback(
    function(result)
        if(result) then
            ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.EnemyCommander)
            M3BaseAI.DisableBase()
            ScenarioFramework.EndOperationSafety()
            ScenarioFramework.Dialogue(OpStrings.EnemyDead, PlayerWin, true)
        end
    end) 

    ScenarioInfo.M3S1:AddResultCallback(
    function(result)
        if(result) then
            for _, v in ScenarioInfo.Shields do
                v:ToggleScriptBit('RULEUTC_ShieldToggle')
            end
        end
    end)

    ScenarioInfo.M3S2:AddResultCallback(
    function(result)
        if(result) then
            ScenarioFramework.Dialogue(OpStrings.Tech2AirFactoryBuilt, nil, true)
            ForkThread(GiveOrbitalBombardmentAbil)
        end
    end)  
end

function M3SetFactoryObjective()
    ScenarioFramework.Dialogue(OpStrings.M3_ProtectFactory, nil, true)

    ScenarioInfo.M3S1 = Objectives.Protect(
    'secondary',                      -- type
    'incomplete',                   -- complete
    'Protect Captured Factory',  -- title
    'The captured Factory provides access to enemy units. Protect the Factory.',  -- description
        {
            MarkUnits = true,                               -- target
            Units = {ScenarioInfo.UEFFactory},
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3S1)
    ScenarioFramework.CreateUnitDeathTrigger(FacDead, ScenarioInfo.UEFFactory)
end

function TacDead()
	ScenarioInfo.M2P2:ManualResult(true)
    ScenarioFramework.Dialogue(OpStrings.M1_Tac_Dead, nil, true)
	TMLAlive = false
end

function LaunchTac()
	if TMLAlive then
		IssueTactical({ScenarioInfo.TacLauncher}, ScenarioInfo.Ship)
		ScenarioFramework.CreateTimerTrigger(LaunchTac, TMLTimer[Difficulty])
	else
		return
	end
end

function FacDead()
    ScenarioInfo.M3S1:ManualResult(false)
    ScenarioFramework.Dialogue(OpStrings.M3FactoryDead, nil, true)
end

function GiveOrbitalBombardmentAbil()
    ScenarioFramework.Dialogue(OpStrings.OrbStrikeReady, nil, true)
    ScenarioInfo.M2AttackPing = PingGroups.AddPingGroup('Signal Air Strike', nil, 'attack', 'Mark a location for the bombers to attack')
    ScenarioInfo.M2AttackPing:AddCallback(SendBombers)
end

function SendBombers(location)
    ForkThread(function()
        local Bombers = ScenarioUtils.CreateArmyGroup('Nomads', 'OrbStrikeBombers_' .. Difficulty)
        local delBomb = ScenarioUtils.MarkerToPosition('DestroyBombers')
        ScenarioInfo.M2AttackPing:Destroy()

        ----------
        -- Send Bombers
        ----------
        for _, v in Bombers do
            if(v and not v:IsDead()) then
                IssueStop({v})
                IssueClearCommands({v})
                v:SetFireState('GroundFire')
                IssueAttack({v}, location)
                IssueMove({v}, delBomb)
            end
        end

        ----------
        -- Trigger a Remove
        ----------
        for _, v in Bombers do
            WaitSeconds(10)
            ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, v, delBomb, 15)
        end

        ScenarioFramework.CreateTimerTrigger(GiveOrbitalBombardmentAbil, BombAbilCoolDown[Difficulty])
    end)
end

function DestroyUnit(unit)
    unit:Destroy()
end

function UEFM1Taunts()
    M1UEFTM:AddUnitsKilledTaunt('TAUNT1', ArmyBrains[Player1], categories.MOBILE, 60)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT2', ArmyBrains[Player1], categories.ALLUNITS, 95)
    M1UEFTM:AddDamageTaunt('TAUNT3', ScenarioInfo.Ship, .10)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT4', ArmyBrains[Player1], categories.MOBILE, 120)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT5', ArmyBrains[Player1], categories.STRUCTURE, 10)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT6', ArmyBrains[Player1], categories.STRUCTURE, 16)   
end

function UEFM3Taunts()
    M3UEFTM:AddTauntingCharacter(ScenarioInfo.UnitNames[UEF]['Commander'])
end