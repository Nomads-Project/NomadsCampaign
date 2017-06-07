local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local CybranM1Base = BaseManager.CreateBaseManager()

local Difficulty = ScenarioInfo.Options.Difficulty

local Cybran = 3

function M1CybranBase()
    CybranM1Base:Initialize(ArmyBrains[Cybran], 'M1_Base_Cybran', 'M1_Cybran_Base_Marker', 100, {M1_Base_Cybran = 100})
    CybranM1Base:StartNonZeroBase(15)
    
    CybranM1Base:SetActive('LandScouting', true)

    ForkThread(function()
        WaitSeconds(1)
        -- Support Factories
        CybranM1Base:AddBuildGroup('M1_Cybran_Support', 100, true)
    end)

    StartCybranLandAttacks()
    StartCybranAirAttacks()

    StartMiscAIStuff()
end

function StartCybranLandAttacks()
	local opai = nil

    opai = CybranM1Base:AddOpAI('BasicLandAttack', 'M1_Cybran_Land_Attack_UEF_1',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('HeavyTanks', 8)

    opai = CybranM1Base:AddOpAI('BasicLandAttack', 'M1_Cybran_Land_Attack_UEF_2',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 175,
        }
    )
    opai:SetChildQuantity('LightBots', 16)

    opai = CybranM1Base:AddOpAI('BasicLandAttack', 'M1_Cybran_Land_Attack_UEF_3',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('LightTanks', 12)

    opai = CybranM1Base:AddOpAI('BasicLandAttack', 'M1_Cybran_Land_Attack_UEF_4',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('MobileFlak', 4)
end

function StartCybranAirAttacks()
	local opai = nil

	opai = CybranM1Base:AddOpAI('AirAttacks', 'M1_Cybran_Air_Attack_UEF_1',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('Interceptors', 12)

    opai = CybranM1Base:AddOpAI('AirAttacks', 'M1_Cybran_Air_Attack_UEF_2',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('Gunships', 8)

    opai = CybranM1Base:AddOpAI('AirAttacks', 'M1_Cybran_Air_Attack_UEF_3',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('CombatFighters', 6)

    opai = CybranM1Base:AddOpAI('AirAttacks', 'M1_Cybran_Air_Attack_UEF_4',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_Cybran_Attack_UEF_1',
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('Bombers', 8)
end

function StartMiscAIStuff()
	local opai = nil

	-- Reclaim some stuff
    opai = CybranM1Base:AddOpAI('EngineerAttack', 'M1_Cybran_Reclaim_Engineers',
    {
        MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
        PlatoonData = {
            PatrolChains = {'M1_Cybran_Reclaim_Patrol_1',
                            'M1_Cybran_Reclaim_Patrol_2',
                            'M1_Cybran_Reclaim_Patrol_3'},
        },
        Priority = 250,
    })
    opai:SetChildQuantity('T1Engineers', 4)
end