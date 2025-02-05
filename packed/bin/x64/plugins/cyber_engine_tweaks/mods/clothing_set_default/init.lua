registerForEvent("onInit", function()
    Observe("QuestsSystem", "SetFact",
    ---@param this QuestsSystem
    ---@param factName string | CName
    ---@param value Int32
    function(this, factName, value)
        local is_rescue_done = Game.GetQuestsSystem():GetFactStr("q001_wakeup_scene_done") == 1
        if tostring(factName.value) == "ranged_combat_tutorial" then
            print("clothing_set_default: checkpoint_" .. tostring(factName.value))
            if not is_rescue_done then
                RPGManager.ForceEquipItemOnPlayer(GetPlayer(),"Items.Q001_Racer", true)
            end
        end
    end)

    Observe("JournalManager", "OnQuestEntryTracked",
    ---@param this JournalManager
    ---@param entry JournalEntry
    function(this, entry)
        local is_johnny_introduction = Game.GetQuestsSystem():GetFactStr("q101_v_reached_pills") == 1
        if tostring(entry.id) == "johnny_talk" and not is_johnny_introduction then
            print("clothing_set_default: checkpoint_" .. tostring(entry.id))
            Game.AddToInventory("Items.V_Necklace_titanium", 1)
            PlayerDevelopmentSystem.GetInstance(Game.GetPlayer()):GetDevelopmentData(Game.GetPlayer()):SetLevel(gamedataProficiencyType['StreetCred'], 15, telemetryLevelGainReason.Gameplay)
            is_johnny_introduction = true
        end
    end)
end)