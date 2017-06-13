local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local CybranM3Base = BaseManager.CreateBaseManager()

local Difficulty = ScenarioInfo.Options.Difficulty

local Cybran = 3

function M3CybranBase()
    CybranM3Base:Initialize(ArmyBrains[Cybran], 'M1_Base_Cybran', 'M1_Cybran_Base_Marker', 100, {M1_Base_Cybran = 100})
    CybranM3Base:StartNonZeroBase(15)
    
    CybranM3Base:SetActive('LandScouting', true)
    CybranM3Base:SetActive('AirScouting', true)
end