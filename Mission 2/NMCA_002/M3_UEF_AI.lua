local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEFM3Base = BaseManager.CreateBaseManager()

local Difficulty = ScenarioInfo.Options.Difficulty

local UEF = 1

function M3UEFBase()
    UEFM3Base:Initialize(ArmyBrains[UEF], 'M3_SupplyBase', 'UEF_Supply_Base_Marker', 100, {M3_SupplyBase = 100})
    UEFM3Base:StartNonZeroBase({12, 6})
    
    UEFM3Base:SetActive('LandScouting', true)
    UEFM3Base:SetActive('AirScouting', true)

    ForkThread(function()
        WaitSeconds(1)
        -- Support Factories
        UEFM3Base:AddBuildGroup('M3_Base_Support', 100, true)
    end)
end