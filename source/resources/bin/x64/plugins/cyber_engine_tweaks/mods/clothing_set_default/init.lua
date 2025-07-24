local is_init = false
local is_johnny = false
local is_nomad = false
local GameSession = require('GameSession')

function statusSet()
    is_init = Game.GetQuestsSystem():GetFactStr("ranged_combat_tutorial") == 1
    is_johnny = Game.GetQuestsSystem():GetFactStr("q101_v_reached_pills") == 1
end

function statusReset()
    is_init = false
    is_johnny = false
end

function statusPrint()
    print("clothing_set_default: " .. (is_init and "racer_1" or "racer_0"))
    print("clothing_set_default: " .. (is_johnny and "necklace_1" or "necklace_0"))
end

registerForEvent("onInit", function()
    print("Alternate V Clothing Set Initialized!")
    statusSet()

    GameSession.OnStart(function()
        print('clothing_set_default: game_session_start')
        statusSet()
        statusPrint()
    end)

    GameSession.OnEnd(function()
        print("clothing_set_default: game_session_ended")
        statusReset()
    end)
    
    Observe("characterCreationSummaryMenu", "OnOutroComplete",
    ---@param this characterCreationSummaryMenu
    ---@param anim inkAnimProxy
    function(this, anim)
        print("clothing_set_default: new_game")
        statusReset()
        statusPrint()
    end)
        
    Observe("QuestsSystem", "SetFact",
    ---@param this QuestsSystem
    ---@param factName string | CName
    ---@param value Int32
    function(this, factName, value)
        if tostring(factName.value) == "ranged_combat_tutorial" and not is_init then
            print("clothing_set_default: checkpoint_" .. tostring(factName.value))
            RPGManager.ForceEquipItemOnPlayer(GetPlayer(),"Items.Q001_Racer", true)
            Game.AddToInventory("Items.Nomad_01_Set_Jacket", 1)
            Game.AddToInventory("Items.Q001_Glasses", 1)
            is_init = true
            statusPrint()
        end
    end)

    Observe("JournalManager", "OnQuestEntryTracked",
    ---@param this JournalManager
    ---@param entry JournalEntry
    function(this, entry)
        if tostring(entry.id) == "johnny_talk" and not is_johnny then
            print("clothing_set_default: checkpoint_" .. tostring(entry.id))
            Game.AddToInventory("Items.V_Necklace_titanium", 1)
            is_johnny = true
            statusPrint()
        end
    end)
end)