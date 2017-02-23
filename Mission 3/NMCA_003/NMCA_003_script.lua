---------------------------------
-- Nomads Campaign - Mission 3 --
---------------------------------
local Objectives = import('/lua/SimObjectives.lua')
local Buff = import('/lua/sim/Buff.lua')
local Cinematics = import('/lua/cinematics.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Difficulty = ScenarioInfo.Options.Difficulty
local OpStrings   = import('/maps/NMCA_003/NMCA_003_strings.lua')

-- AI
local M1_Aeon_Base_AI = import('/maps/NMCA_003/NMCA_003_M1_Aeon_Base_AI.lua')
local M2_Aeon_Land_Base_AI = import('/maps/NMCA_003/NMCA_003_M2_Aeon_Land_Base_AI.lua')
local M2_Aeon_Air_Base_AI = import('/maps/NMCA_003/NMCA_003_M2_Aeon_Air_Base_AI.lua')
local M3_Aeon_Naval_Base_AI = import('/maps/NMCA_003/NMCA_003_M3_Aeon_Naval_Base_AI.lua')
local M4_Aeon_Naval_Base_AI = import('/maps/NMCA_003/NMCA_003_M4_Aeon_Naval_Base_AI.lua')
local M4_Aeon_Palace_Base_AI = import('/maps/NMCA_003/NMCA_003_M4_Aeon_Palace_Base_AI.lua')
   
-- Global Variables
AssignedObjectives = {}
ScenarioInfo.PlayerACU = {}
ScenarioInfo.Crystal = {}
ScenarioInfo.M3_Pgen = {}
ScenarioInfo.Crystals = 1
ScenarioInfo.Aeon = 2
ScenarioInfo.Crashed_Ship = 3
ScenarioInfo.Aeon_Neutral = 4
ScenarioInfo.Player1 = 5
ScenarioInfo.Player2 = 6
ScenarioInfo.Player3 = 7
ScenarioInfo.Player4 = 8
ScenarioInfo.OpEnded = false
PlayerColours = {[5]={r=250, g=250, b=0},[6]={r=189, g=183, b=107},[7]={r=255, g=255, b=165},[8]={r=255, g=192, b=0},}

-- Local Variables
local Crystals = ScenarioInfo.Crystals
local Aeon = ScenarioInfo.Aeon
local Aeon_Neutral = ScenarioInfo.Aeon_Neutral
local Crashed_Ship = ScenarioInfo.Crashed_Ship
local Player1 = ScenarioInfo.Player1
local Player1 = ScenarioInfo.Player1
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4

function OnPopulate()
	ScenarioUtils.InitializeScenarioArmies()
	ScenarioFramework.SetPlayableArea('M1_Area', false)
	
	-- Set Unit Cap
	ScenarioFramework.SetSharedUnitCap(1000)
	
	-- Set Unit Restrictions
	ScenarioFramework.AddRestrictionForAllHumans(categories.TECH3 + categories.EXPERIMENTAL)
	
	-- Set Army Colours
	ScenarioFramework.SetAeonColor(Aeon)
	SetArmyColor("Crashed_Ship", 255, 191, 128)
	SetArmyColor("Aeon_Neutral", 16, 86, 16)
	
	-- M3 Artillery Base
	ScenarioInfo.M3_Science_Lab = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_Science_Lab")
	ScenarioInfo.M3_T3_Artillery = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_T3_Artillery")
	ScenarioInfo.M3_Pgen[1] = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_Pgen_1")
	ScenarioInfo.M3_Pgen[2] = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_Pgen_2")
	ScenarioInfo.M3_Pgen[3] = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_Pgen_3")
	ScenarioInfo.M3_Pgen[4] = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_Pgen_4")
	ScenarioInfo.M3_Pgen[5] = ScenarioUtils.CreateArmyUnit("Aeon_Neutral", "M3_Pgen_5")
	ScenarioInfo.M3_T3_Artillery:SetCapturable(false)
	ScenarioInfo.M3_T3_Artillery:SetReclaimable(false)
	ScenarioFramework.CreateUnitDestroyedTrigger(M3S1_Manual_Result, ScenarioInfo.M3_T3_Artillery)
	
	-- Crashed Ship
	ScenarioInfo.Crashed_Ship_Unit = ScenarioUtils.CreateArmyUnit("Crashed_Ship", "Crashed_Ship")
	ScenarioInfo.Crashed_Ship_Unit:SetCustomName("Crashed Ship")
	ScenarioInfo.Crashed_Ship_Unit:SetReclaimable(false)
	ScenarioInfo.Crashed_Ship_Unit:SetCapturable(false) 
	ScenarioInfo.Crashed_Ship_Unit:SetHealth(ScenarioInfo.Crashed_Ship_Unit, 2250)
	ForkThread(Crashed_Ship_Jerky_Rotors)
	
	-- Aeon Town
	ScenarioUtils.CreateArmyGroup("Aeon_Neutral", "M4_Town")
	
	-- Admin Center
	ScenarioInfo.M1_Admin_Centre = ScenarioUtils.CreateArmyUnit("Aeon", "M1_Admin_Centre")
	ScenarioInfo.M1_Admin_Centre:SetCustomName("Administrative Centre")
	
	-- Palace
	ScenarioInfo.Palace = ScenarioUtils.CreateArmyUnit("Aeon", "Palace")
	
	-- Crystals
	ScenarioInfo.Crystal[1] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal1")
	ScenarioInfo.Crystal[2] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal2")
	ScenarioInfo.Crystal[3] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal3")
	ScenarioInfo.Crystal[4] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal4")
	ScenarioInfo.Crystal[5] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal5")
	ScenarioInfo.Crystal[6] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal6")
	ScenarioInfo.Crystal[7] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal7")
	ScenarioInfo.Crystal[8] = ScenarioUtils.CreateArmyUnit("Crystals", "Crystal8")
	
	-- Create M1 Aeon Base
	M1_Aeon_Base_AI.M1_Aeon_Base_Spawn()
	
	-- Create M2 Aeon Bases
	M2_Aeon_Land_Base_AI.M2_Aeon_Land_Base_Spawn()
	M2_Aeon_Air_Base_AI.M2_Aeon_Air_Base_Spawn()
	ScenarioFramework.CreateVisibleAreaLocation(100, "M2_Aeon_Air_Base_Marker", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(100, "M2_Aeon_Land_Base_Marker", 0, ArmyBrains[Player1])
	ScenarioFramework.CreateVisibleAreaLocation(150, "M3_Aeon_Naval_Base_Marker", 0, ArmyBrains[Player1])
end
   
function OnStart()
	ForkThread(Intro_Mission_1)
end
   
function Intro_Mission_1()
	tblArmy = ListArmies()
	
	-- Gets player number and joins it to a string to make it refrence a camera marker e.g Player1_Cam N.B. Observers are called nilCam
	local strCameraPlayer = tostring(tblArmy[GetFocusArmy()])
	local CameraMarker = strCameraPlayer .. "_Cam"
	
	--Intro Cinematic
	Cinematics.EnterNISMode()
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Crashed_Ship_Camera"), 1)
	ScenarioFramework.CreateVisibleAreaLocation(30, "M1_Aeon_Base_Marker", 8, ArmyBrains[Player1])
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("M1_Cine_Cam_1"), 2)
	ForkThread(SpawnInitalUnits)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("M1_Cine_Cam_1"), 4)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Crashed_Ship_Camera"), 2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker(CameraMarker), 4)
	Cinematics.ExitNISMode()
	ForkThread(Start_Mission_1)
end

function Start_Mission_1()
	-- Rainbow effect for crystals
	ForkThread(RainbowEffect)
	--------------------------------------------------------------
	-- Mission 1 Primary Objective 1 - Protect the crashed ship --
	--------------------------------------------------------------
	ScenarioInfo.M1P1 = Objectives.Protect(
		'primary',                      					-- type
		'incomplete',                   					-- complete
		'Ensure the crashed ship survives',                 -- title
		'Ensure the crashed ship survives',  				-- description
		{                               					-- target
			Units = {ScenarioInfo.Crashed_Ship_Unit},
		}
    )
    ScenarioInfo.M1P1:AddResultCallback(
        function(result)
            if not(result) then
				ForkThread(Ship_Death)
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M1P1)
	WaitSeconds(4)
	--------------------------------------------------------------------
	-- Mission 1 Primary Objective 2 - Find things to repair the ship --
	--------------------------------------------------------------------
	ScenarioInfo.M1P2 = Objectives.Reclaim(
		'primary',                      					-- type
		'incomplete',                   					-- complete
		'Reclaim these things',                 			-- title
		'Reclaim these things so the ship can get better',  -- description
		{                               					-- target
			Units = {ScenarioInfo.Crystal[1], ScenarioInfo.Crystal[2], ScenarioInfo.Crystal[3], ScenarioInfo.Crystal[4], ScenarioInfo.Crystal[5], ScenarioInfo.Crystal[6], ScenarioInfo.Crystal[7], ScenarioInfo.Crystal[8]},
		}
    )
    ScenarioInfo.M1P2:AddResultCallback(
        function(result)
            if (result) then
				ForkThread(Player_Win)
            end
            if not(result) then
				ForkThread(Crystal_Death)
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M1P2)
	WaitSeconds(4)
    -------------------------------------------------------------
    -- Mission 1 Primary Objective 3 - Destroy Aeon south base --
    -------------------------------------------------------------
	ScenarioInfo.M1P3 = Objectives.CategoriesInArea(
		'primary',                      					-- type
		'incomplete',                   					-- status
		'Destroy the southern Aeon base',    				-- title
		'Eliminate the marked Aeon structures.',  			-- description
		'kill',                         					-- action
		{                              						-- target
			MarkUnits = true,
			Requirements = {
				{Area = 'M1_Aeon_South_Base', Category = categories.FACTORY + categories.ECONOMIC + categories.CONSTRUCTION, CompareOp = '<=', Value = 0, ArmyIndex = Aeon},
			},
		}
	)
    ScenarioInfo.M1P3:AddResultCallback(
        function(result)
            if(result) then
				ForkThread(Intro_Mission_2)
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M1P3)
	WaitSeconds(4)
    ------------------------------------------------------------------------------
    -- Mission 1 Secondary Objective 1 - Capture the Aeon administrative centre --
    ------------------------------------------------------------------------------
    ScenarioInfo.M1S1 = Objectives.Capture(
        'secondary',                    										-- type
        'incomplete',                   										-- complete
        'Capture the Aeon administrative centre',  								-- title
        'Capture the Aeon administrative centre to recieve additional intel',   -- description
        {
            Units = {ScenarioInfo.M1_Admin_Centre},
            FlashVisible = true,
        }
	)
    ScenarioInfo.M1S1:AddResultCallback(
        function(result)
            if(result) then
				LOG("TODO")
            end
        end
   )
   table.insert(AssignedObjectives, ScenarioInfo.M1S1)
end

function Intro_Mission_2()
	LOG("TODO")
	ScenarioFramework.SetPlayableArea('M2_Area', true)
	ForkThread(Start_Mission_2)
	M3_Aeon_Naval_Base_AI.M3_Aeon_Naval_Base_Spawn()
	ScenarioUtils.CreateArmyGroup("Aeon", "M3_Aeon_Arty_Base")
end

function Start_Mission_2()
	-- Rainbow effect for crystals
	ForkThread(RainbowEffect)
    -------------------------------------------------------------
    -- Mission 2 Primary Objective 1 - Destroy Aeon south base --
    -------------------------------------------------------------
    ScenarioInfo.M2P1 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- status
        'Destroy the Aeon Bases',  		-- title
        'Destroy the Aeon Bases',  		-- description
        'kill',
        {                               -- target
            MarkUnits = true,
			FlashVisible = true,
            Requirements = {
                {Area = 'M2_Aeon_Air_Base', Category = categories.FACTORY + categories.ECONOMIC + categories.CONSTRUCTION, CompareOp = '<=', Value = 0, ArmyIndex = Aeon},
                {Area = 'M2_Aeon_Land_Base', Category = categories.FACTORY + categories.ECONOMIC + categories.CONSTRUCTION, CompareOp = '<=', Value = 0, ArmyIndex = Aeon},
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
	table.insert(AssignedObjectives, ScenarioInfo.M2P1)
end

function Intro_Mission_3()
	LOG("TODO")
	ScenarioFramework.SetPlayableArea('M3_Area', true)
	M4_Aeon_Naval_Base_AI.M4_Aeon_Naval_Base_Spawn()
	M4_Aeon_Palace_Base_AI.M4_Aeon_Palace_Base_Spawn()
	ForkThread(Start_Mission_3)
end

function Start_Mission_3()
	-- Rainbow effect for crystals
	ForkThread(RainbowEffect)
	-------------------------------------------------------------
    -- Mission 3 Primary Objective 1 - Destroy Aeon Naval base --
    -------------------------------------------------------------
    ScenarioInfo.M3P1 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- status
        'Destroy the Aeon Naval Base',  -- title
        'Destroy the Aeon Naval Base',  -- description
        'kill',
        {                               -- target
            MarkUnits = true,
			FlashVisible = true,
            Requirements = {
                {Area = 'M3_Aeon_Naval_Base', Category = categories.FACTORY + categories.ECONOMIC + categories.CONSTRUCTION, CompareOp = '<=', Value = 0, ArmyIndex = Aeon},
            },
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if(result) then
                ForkThread(Intro_Mission_4)
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M3P1)
	WaitSeconds(4)
    -------------------------------------------------------------------------
    -- Mission 3 Secondary Objective 1 - Capture the Aeon Science Facility --
    -------------------------------------------------------------------------
    ScenarioInfo.M3S1 = Objectives.Capture(
        'secondary',                      	-- type
        'incomplete',                       -- status
        'Capture the Aeon Science Facility',  -- title
        'Capture the to capture the T3 artillery',  -- description
        {
            FlashVisible = true,
            NumRequired = 1,
            Units = {ScenarioInfo.M3_Science_Lab},
        }
    )
    ScenarioInfo.M3S1:AddResultCallback(
        function(result)
            if(result) then
				ScenarioFramework.GiveUnitToArmy( ScenarioInfo.M3_T3_Artillery, Crashed_Ship )
				for iPgen, strPgen in pairs(ScenarioInfo.M3_Pgen) do
					if not ScenarioInfo.M3_Pgen[iPgen]:IsDead() then
						ScenarioFramework.GiveUnitToArmy( ScenarioInfo.M3_Pgen[iPgen], Crashed_Ship )
					end
				end
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3S1)
end

function Intro_Mission_4()
	LOG("TODO")
	ScenarioFramework.SetPlayableArea('M4_Area', true)
	ForkThread(Start_Mission_4)
end

function Start_Mission_4()
	-- Rainbow effect for crystals
	ForkThread(RainbowEffect)
	-------------------------------------------------------------
    -- Mission 4 Secondary Objective 1 - Destroy Aeon Naval base --
    -------------------------------------------------------------
    ScenarioInfo.M3P1 = Objectives.CategoriesInArea(
        'secondary',                    -- type
        'incomplete',                   -- status
        'Destroy the Aeon Naval Base',  -- title
        'Destroy the Aeon Naval Base',  -- description
        'kill',
        {                               -- target
            MarkUnits = true,
			FlashVisible = true,
            Requirements = {
                {Area = 'M4_Aeon_Naval_Base', Category = categories.FACTORY + categories.ECONOMIC + categories.CONSTRUCTION, CompareOp = '<=', Value = 0, ArmyIndex = Aeon},
            },
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if(result) then
                LOG("TODO")
            end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M3P1)
end

function SpawnInitalUnits()
	LOG("Spawning Players")
	ArmyBrains[Crashed_Ship]:GiveResource('MASS', 1010)
	for iArmy, strArmy in pairs(tblArmy) do
		if iArmy >= Player1 then
			SetArmyColor(strArmy, PlayerColours[iArmy].r, PlayerColours[iArmy].g, PlayerColours[iArmy].b)
			ScenarioInfo.PlayerACU[iArmy] = ScenarioFramework.SpawnCommander(strArmy, 'ACU', false, true, true, PlayerDeath)
			IssueMove({ScenarioInfo.PlayerACU[iArmy]}, ScenarioUtils.MarkerToPosition(strArmy))
		end
	end
end

function RainbowEffect()
	local i = 1
	frequency = math.pi*2/255
	while not ScenarioInfo.OpEnded do
		WaitSeconds(0.1)
		if i >= 255 then i = 255 end
		local red   = math.sin(frequency*i+2) * 127 + 128
		local green = math.sin(frequency*i+0) * 127 + 128
		local blue  = math.sin(frequency*i+4) * 127 + 128
		SetArmyColor("Crystals",red,green,blue)
		if i >= 255 then i = 1 end
		i = i + 1
	end
end

function PlayerDeath(Player)
	LOG("ACU Death")
	if(not ScenarioInfo.OpEnded) then
		ScenarioFramework.CDRDeathNISCamera(Player)
		ForkThread(Mission_Failed)
	end
end

function Ship_Death()
	LOG("Ship Death")
	if(not ScenarioInfo.OpEnded) then
		Cinematics.EnterNISMode()
		Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Crashed_Ship_Camera"), 1)
		ForkThread(Mission_Failed)
	end
end

function Crystal_Death()
	LOG("Crystal Death")
	if(not ScenarioInfo.OpEnded) then
		Cinematics.EnterNISMode()
		Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker("Crashed_Ship_Camera"), 1)
		ForkThread(Mission_Failed)
	end
end

function Mission_Failed()
	LOG("Mission Failed")
	ScenarioFramework.EndOperationSafety()
	ScenarioFramework.FlushDialogueQueue()
	for k, v in AssignedObjectives do
		if(v and v.Active) then
			v:ManualResult(false)
		end
	end
	ScenarioInfo.OpComplete = false
	ForkThread(
		function()
			WaitSeconds(5)
			UnlockInput()
			Kill_Game()
		end
	)
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

function M3S1_Manual_Result()
    if(ScenarioInfo.M3S1 and ScenarioInfo.M3S1.Active) then
        ScenarioInfo.M3S1:ManualResult(false)
	end
end

function Crashed_Ship_Jerky_Rotors()
	while not ScenarioInfo.Crashed_Ship_Unit:IsDead() do
		local RotorSpeed1 = Random(0,60)-10
		local RotorSpeed2 = Random(0,60)-50
		local AccelSpeed1 = Random(0,100)-20
		local AccelSpeed2 = Random(0,100)-80
		ScenarioInfo.Crashed_Ship_Unit.RotatorManipulator1:SetAccel( AccelSpeed1 ) 
		ScenarioInfo.Crashed_Ship_Unit.RotatorManipulator2:SetAccel( AccelSpeed2 )
		ScenarioInfo.Crashed_Ship_Unit.RotatorManipulator1:SetTargetSpeed( RotorSpeed1 )
		ScenarioInfo.Crashed_Ship_Unit.RotatorManipulator2:SetTargetSpeed( RotorSpeed2 )
		WaitSeconds(0.5)
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