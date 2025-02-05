registerForEvent("onInit", function()
    Observe("QuestsSystem", "SetFact",
    ---@param this QuestsSystem
    ---@param factName string | CName
    ---@param value Int32
    function(this, factName, value)
        if tostring(factName.value) == "ranged_combat_tutorial" then
            print("clothing_set_default: checkpoint_" .. tostring(factName.value))
            if Game.GetQuestsSystem():GetFactStr("q001_wakeup_scene_done") == 0 then
                RPGManager.ForceEquipItemOnPlayer(GetPlayer(),"Items.Q001_Racer", true)
            end
        end
    end)

    Observe("JournalManager", "OnQuestEntryTracked",
    ---@param this JournalManager
    ---@param entry JournalEntry
    function(this, entry)
        if tostring(entry.id) == "johnny_talk" then
            print("clothing_set_default: checkpoint_" .. tostring(entry.id))
            if Game.GetQuestsSystem():GetFactStr("q101_v_reached_pills") == 0 then
                Game.AddToInventory("Items.V_Necklace_titanium", 1)
                PlayerDevelopmentSystem.GetInstance(Game.GetPlayer()):GetDevelopmentData(Game.GetPlayer()):SetLevel(gamedataProficiencyType['StreetCred'], 15, telemetryLevelGainReason.Gameplay)
            end
        end
    end)
end)