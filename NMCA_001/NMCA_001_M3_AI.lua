local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFBase = BaseManager.CreateBaseManager()

function UEFBaseAI()
	UEFBase:Initialize(ArmyBrains[UEF], 'MainBase', 'M3_UEF_Base_Marker', 100, {MainBase = 100})
	UEFBase:StartNonZeroBase({7, 5})
	UEFBase:SetActive('AirScouting', true)
	UEFBase:SetActive('LandScouting', true)

	UEFBaseLandAttacks()
	UEFBaseAirAttacks()
	UEFBaseTransportAttacks()
end

function UEFBaseLandAttacks()
	local opai = nil
	local quantity = {}

	quantity = {6, 8, 10}
	opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack1',
	    {
	        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
	        PlatoonData = {
	            PatrolChain = 'M3_BaseLandAttack_1'
	        },
	        Priority = 100,
	    }
	)
	opai:SetChildQuantity('LightTanks', quantity[Difficulty])

	quantity = {4, 5, 6}
	opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack2',
	    {
	        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
	        PlatoonData = {
	            PatrolChain = 'M3_BaseLandAttack_1'
	        },
	        Priority = 100,
	    }
	)
	opai:SetChildQuantity('MobileAntiAir', quantity[Difficulty])

	quantity = {6, 8, 10}
	opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack3',
	    {
	        MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
	        PlatoonData = {
	            PatrolChain = 'M3_BaseLandAttack_2'
	        },
	        Priority = 100,
	    }
	)
	opai:SetChildQuantity({'LightBots', 'MobileAntiAir'}, quantity[Difficulty])

	-- Builds platoon of 3/4/5 Artillery
	quantity = {3, 4, 5}
	opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack4',
	    {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M3_BaseLandAttack_1', 
                				'M3_BaseLandAttack_2'},
            },
	        Priority = 100,
	    }
	)
	opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
end


function UEFBaseAirAttacks()

end

function UEFBaseTransportAttacks()
	local opai = nil
	local quantity = {}

	-- Transport Builder
    opai = UEFBase:AddOpAI('EngineerAttack', 'M3_Base_TransportBuilder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {
            AttackChain = 'M3_BaseTransport_Attack_Route',
            LandingChain = 'M3_BaseTransport_Drop_Chain',
            TransportReturn = 'M3_UEF_Base_Marker',
        },
        Priority = 100,
    })
    opai:SetChildActive('All', false)
    opai:SetChildActive('T1Transports', true)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 5, categories.uea0107})

    -- Drops
    for i = 1, 3 do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_UEFTLandAttack1' .. i,
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'M3_BaseTransport_Attack_Route',
                LandingChain = 'M3_BaseTransport_Drop_Chain',
                TransportReturn = 'M3_UEF_Base_Marker',
            },
            Priority = 125,
        })
        opai:SetChildQuantity('LightTanks', 6)
        opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
            'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0107})
    end

    for i = 1, 3 do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_UEFTLandAttack2' .. i,
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'M3_BaseTransport_Attack_Route',
                LandingChain = 'M3_BaseTransport_Drop_Chain',
                TransportReturn = 'M3_UEF_Base_Marker',
            },
            Priority = 125,
        })
        opai:SetChildQuantity({'MobileAntiAir', 'LightBots'}, 8)
        opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
            'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0107})
    end
end

function DisableBase()
    if(UEFBase) then
        UEFBase:BaseActive(false)
    end
end
