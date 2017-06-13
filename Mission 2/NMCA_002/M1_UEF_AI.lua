local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEFM1Base = BaseManager.CreateBaseManager()

local Difficulty = ScenarioInfo.Options.Difficulty

local UEF = 1

function M1UEFBase()
    UEFM1Base:Initialize(ArmyBrains[UEF], 'M1_Base', 'M1_UEF_Base_1_Marker', 100, {M1_Base = 100})
    UEFM1Base:StartNonZeroBase({12, 6})
    
    UEFM1Base:SetActive('LandScouting', true)
    UEFM1Base:SetActive('AirScouting', true)

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

    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Cybran_5',
    {
    
        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
        PlatoonData = {
            PatrolChain = 'M1_UEF_Attack_Cybran_1',
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('LightArtillery', 8)
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
    local opai = nil
    local quantity = {}

    quantity = {8, 12, 16}
    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Player_1',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 220,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])

    quantity = {6, 12, 18}
    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Player_2',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('LightBots', quantity[Difficulty])

    quantity = {12, 16, 20}
    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Player_3',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 235,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 2, categories.LAND * categories.FACTORY, '>='})

    -- TECH 2 --
    quantity = {6, 8, 10}
    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Player_4',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 1, categories.LAND * categories.FACTORY * categories.TECH2, '>='})

    quantity = {4, 6, 8}
    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Player_5',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('MobileMissiles', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 1, categories.LAND * categories.FACTORY * categories.TECH2, '>='})

    opai = UEFM1Base:AddOpAI('BasicLandAttack', 'M1_UEF_Land_Attack_Player_6',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('MobileFlak', 4)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 1, categories.LAND * categories.FACTORY * categories.TECH2, '>='})
end

function StartPlayerAirAttacks()
    local opai = nil
    local quantity = {}

    quantity = {4, 6, 8}
    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Player_1',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    quantity = {8, 12, 16}
    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Player_2',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 225,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 1, categories.AIR * categories.FACTORY, '>='})

    quantity = {6, 12, 18}
    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Player_3',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 235,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 2, categories.AIR * categories.FACTORY, '>='})

    -- TECH 2 --
    quantity = {6, 7, 8}
    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Player_4',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 250,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 1, categories.AIR * categories.FACTORY * categories.TECH2, '>='})

    quantity = {4, 5, 6}
    opai = UEFM1Base:AddOpAI('AirAttacks', 'M1_UEF_Air_Attack_Player_5',
    {
        MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
        PlatoonData = {
            PatrolChains = {
            'M1_UEF_Attack_Player_1',
            'M1_UEF_Attack_Player_2'
            },
        },
        Priority = 200,
        }
    )
    opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, 2, categories.AIR * categories.FACTORY * categories.TECH2, '>='})
end

function DisableBase()
    if(UEFM1Base) then
        UEFM1Base:BaseActive(false)
    end
end