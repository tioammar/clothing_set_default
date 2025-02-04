registerForEvent("onInit", function()
    Observe("QuestsSystem", "SetFact",
    ---@param this QuestsSystem
    ---@param factName string | CName
    ---@param value Int32
    function(this, factName, value)
        -- print("fact_name:" .. tostring(factName.value))
        if tostring(factName.value) == "ranged_combat_tutorial" then
            print("clothing_set_default: checkpoint_" .. tostring(factName.value))

            local is_rescue_done = Game.GetQuestsSystem():GetFactStr("q001_wakeup_scene_done") == 1
            if not is_rescue_done then
                RPGManager.ForceEquipItemOnPlayer(GetPlayer(),"Items.Q001_Racer", true)
            end
        end
    end)
end)