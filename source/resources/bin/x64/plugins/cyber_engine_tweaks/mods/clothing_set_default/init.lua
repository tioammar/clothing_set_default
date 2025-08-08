local is_init = false
local is_johnny = false
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
    print("clothing_set_default: " .. (is_init and "jacket_1" or "jacket_0"))
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
            RPGManager.ForceEquipItemOnPlayer(GetPlayer(),"Items.Q001_Jacket", true)
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

-- Cleanup when the game shuts down
registerForEvent("onShutdown", function()
    print("Clothing Set Shutting down.")
end)

-- Check if CET is open
registerForEvent("onOverlayOpen", function()
	CetOpen = true
end)

registerForEvent("onOverlayClose", function()
	CetOpen = false
end)

-- Main GUI logic
registerForEvent("onDraw", function()
	if(CetOpen) then
		ImGui.SetNextWindowSize(600, 600)
		if not ImGui.Begin("Clothing Set Additional Items") then
            ImGui.End()
            return
		end
		if ImGui.BeginChild("Child Window 16", 0, 0, true) then
            if ImGui.BeginTabBar("##TabBar4") then
                if ImGui.BeginTabItem("Clothes") then
                    ImGui.AlignTextToFramePadding()
                    ImGui.Text("Requires 'Clothing Set Default'")

                    ImGui.AlignTextToFramePadding()
                    ImGui.Text("Plain Samurai Jacket")
                    if ImGui.Button("Add Samurai Jacket!", -1, 0) then
                        Game.AddToInventory("Items.Q001_Samurai", 1)
                    end

                    ImGui.AlignTextToFramePadding()
                    ImGui.Text("V's Racer Jacket")
                    if ImGui.Button("Add Racer Jacket!", -1, 0) then
                        Game.AddToInventory("Items.Q001_Racer", 1)
                    end

                    ImGui.AlignTextToFramePadding()
                    ImGui.Text("V's Plain Solo T-Shirt")
                    if ImGui.Button("Add T-Shirt!", -1, 0) then
                        Game.AddToInventory("Items.Q001_TShirt_01", 1)
                    end

                    ImGui.AlignTextToFramePadding()
                    ImGui.Text("Nomad Jacket")
                    if ImGui.Button("Add Nomad Jacket!", -1, 0) then
                        Game.AddToInventory("Items.Nomad_01_Set_Jacket", 1)
                    end
                ImGui.EndTabItem()
                end
            ImGui.EndTabBar()
            end
		ImGui.EndChild()
		end
		ImGui.End()
	end
end)