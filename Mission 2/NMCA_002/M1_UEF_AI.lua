local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEFM1Base = BaseManager.CreateBaseManager()

local Difficulty = ScenarioInfo.Options.Difficulty

local UEF = 1

function M1UEFBase()
    UEFM1Base:Initialize(ArmyBrains[UEF], 'M1_Base', 'M1_UEF_Base_1_Marker', 100, {M1_Base = 100})
    UEFM1Base:StartNonZeroBase({12, 6})
    
    UEFM1Base:SetActive('LandScouting', true)

    ForkThread(function()
        WaitSeconds(1)
        -- Support Factories
        UEFM1Base:AddBuildGroup('M1_Base_Support', 100, true)
    end)

    StartUEFLandAttacks()
    StartUEFAirAttacks()

    StartMiscAIStuff()
end

function StartUEFLandAttacks()
    local opai = nil

    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Cybran_1',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('HeavyTanks', 8)

    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Cybran_2',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('LightTanks', 16)

    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Cybran_3',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('LightBots', 12)

    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Cybran_4',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('MobileFlak', 4)
end

function StartUEFAirAttacks()
    local opai = nil

    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Cybran_1',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('Gunships', 8)

    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Cybran_2',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('Bombers', 10)

    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Cybran_3',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('CombatFighters', 6)

    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Cybran_4',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('Interceptors', 12)
end

function StartMiscAIStuff()

end

-- Player Attacks
function StartPlayerAttacks()
    StartPlayerLandAttacks()
    StartPlayerAirAttacks()
end

function StartPlayerLandAttacks()
    WARN("Attacking Player...")
end

function StartPlayerAirAttacks()

end