local var0 = class("WorldSwitchPlanningLayer", import("view.base.BaseUI"))

var0.MODE_DIFFICULT = 0
var0.MODE_SAFE = 1
var0.MODE_TREASURE = 2
var0.modeToggleDic = {
	[0] = {
		base = true,
		wait_2 = true,
		wait = true,
		boss = true,
		consume = true
	},
	{
		safe = true,
		wait_2 = true,
		wait = true,
		boss = true,
		consume = true
	},
	{
		wait = true,
		boss = true,
		treasure = true,
		consume = true
	}
}

function var0.getUIName(arg0)
	return "WorldSwitchPlanningUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.rtBg = arg0._tf:Find("bg")

	onButton(arg0, arg0.rtBg, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.rtWindow = arg0._tf:Find("window")
	arg0.btnBack = arg0.rtWindow:Find("top/btnBack")

	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.btnCancel = arg0.rtWindow:Find("button_container/custom_button_2")

	setText(arg0.btnCancel:Find("pic"), i18n("text_cancel"))
	onButton(arg0, arg0.btnCancel, function()
		arg0:closeView()
	end, SFX_CANCEL)

	arg0.btnConfirm = arg0.rtWindow:Find("button_container/custom_button_1")

	setText(arg0.btnConfirm:Find("pic"), i18n("text_confirm"))
	onButton(arg0, arg0.btnConfirm, function()
		arg0:emit(WorldSwitchPlanningMediator.OnConfirm)
		arg0:closeView()
	end, SFX_CONFIRM)

	arg0.btnMove = arg0.rtWindow:Find("button_container/custom_button_3")

	setText(arg0.btnMove:Find("pic"), i18n("text_goto"))
	onButton(arg0, arg0.btnMove, function()
		local var0 = nowWorld()

		if var0:GetInventoryProxy():GetItemCount(WorldConst.SwitchPlainingItemId) > 0 then
			arg0:emit(WorldSwitchPlanningMediator.OnMove, {
				inMap = true,
				context = Context.New({
					mediator = WorldInventoryMediator,
					viewComponent = WorldInventoryLayer
				})
			})
		elseif not var0:IsSystemOpen(WorldConst.SystemResetShop) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_treasure_3"))
		else
			arg0:emit(WorldSwitchPlanningMediator.OnMove, {
				inMap = false,
				context = Context.New({
					mediator = WorldShopMediator,
					viewComponent = WorldShopLayer
				})
			})
		end

		arg0:closeView()
	end, SFX_CONFIRM)

	arg0.rtContent = arg0.rtWindow:Find("content")

	onToggle(arg0, arg0.rtContent:Find("toggles/toggle_base"), function(arg0)
		if arg0 then
			arg0:updateView(var0.MODE_DIFFICULT)
			scrollTo(arg0.rtView:Find("content"), nil, 1)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.rtContent:Find("toggles/toggle_safe"), function(arg0)
		if arg0 then
			arg0:updateView(var0.MODE_SAFE)
			scrollTo(arg0.rtView:Find("content"), nil, 1)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.rtContent:Find("toggles/toggle_treasure"), function(arg0)
		if arg0 then
			arg0:updateView(var0.MODE_TREASURE)
			scrollTo(arg0.rtView:Find("content"), nil, 1)
		end
	end, SFX_PANEL)

	arg0.rtView = arg0.rtContent:Find("view")

	for iter0, iter1 in ipairs({
		"base",
		"treasure"
	}) do
		local var0 = arg0.rtView:Find("content/" .. iter1 .. "/toggles")
		local var1 = var0:Find("all")
		local var2 = {}
		local var3 = 0
		local var4 = var0.childCount

		eachChild(var0, function(arg0)
			onToggle(arg0, arg0, function(arg0)
				local var0 = (arg0 and 1 or 0) - defaultValue(var2[arg0.name], 0)

				var2[arg0.name] = arg0 and 1 or 0
				var3 = var3 + var0

				local var1 = true

				if arg0 == var1 and arg0 then
					eachChild(var0, function(arg0)
						if arg0 ~= arg0 and GetComponent(arg0, typeof(Toggle)).isOn == true then
							triggerToggle(arg0, false)

							var1 = false
						end
					end)
				elseif var3 == 0 or var3 >= var4 - 1 then
					triggerToggle(var1, true)

					var1 = false
				elseif var3 > 1 and GetComponent(var1, typeof(Toggle)).isOn == true then
					triggerToggle(var1, false)

					var1 = false
				end

				if var1 then
					arg0:saveConfig(iter1)
				end
			end, SFX_PANEL)
		end)
	end

	local var5 = pg.gameset.joint_boss_ticket.description
	local var6 = var5[1] + var5[2]
	local var7 = var5[1] .. "&" .. var6
	local var8 = {}

	table.insert(var8, "")
	table.insert(var8, var7)
	table.insert(var8, tostring(var6))

	arg0.togglesList = {
		safe = {
			getFlag = function()
				return PlayerPrefs.GetString("auto_switch_difficult_safe", "all")
			end,
			setFlag = function(arg0)
				PlayerPrefs.SetString("auto_switch_difficult_safe", arg0)
				PlayerPrefs.Save()
			end,
			info = {
				all = "all",
				only = "only"
			}
		},
		wait = {
			getFlag = function()
				return PlayerPrefs.GetInt("auto_switch_wait", 0)
			end,
			setFlag = function(arg0)
				PlayerPrefs.SetInt("auto_switch_wait", arg0)
				PlayerPrefs.Save()
			end,
			info = {
				yes = 1,
				no = 0
			}
		},
		wait_2 = {
			getFlag = function()
				return PlayerPrefs.GetInt("auto_switch_wait_2", 0)
			end,
			setFlag = function(arg0)
				PlayerPrefs.SetInt("auto_switch_wait_2", arg0)
				PlayerPrefs.Save()
			end,
			info = {
				yes = 1,
				no = 0
			}
		},
		boss = {
			getFlag = function()
				return getProxy(SettingsProxy):GetWorldBossProgressTipFlag()
			end,
			setFlag = function(arg0)
				getProxy(SettingsProxy):WorldBossProgressTipFlag(arg0)
			end,
			info = {
				no = var8[1],
				["100"] = var8[2],
				["200"] = var8[3]
			}
		},
		consume = {
			getFlag = function()
				return getProxy(SettingsProxy):GetWorldFlag("consume_item")
			end,
			setFlag = function(arg0)
				getProxy(SettingsProxy):SetWorldFlag("consume_item", arg0)
			end,
			info = {
				yes = true,
				no = false
			}
		}
	}

	for iter2, iter3 in pairs(arg0.togglesList) do
		local var9 = arg0.rtView:Find("content/" .. iter2 .. "/toggles")

		for iter4, iter5 in pairs(iter3.info) do
			onToggle(arg0, var9:Find(iter4), function(arg0)
				if arg0 then
					iter3.setFlag(iter5)
				end
			end, SFX_PANEL)
		end
	end

	local var10 = {
		base = {
			text = "world_automode_setting_1",
			info = {
				["5"] = "world_automode_setting_1_2",
				until_4 = "world_automode_setting_1_1",
				["6"] = "world_automode_setting_1_3",
				all = "world_automode_setting_1_4"
			}
		},
		safe = {
			text = "world_automode_setting_2",
			info = {
				all = "world_automode_setting_2_2",
				only = "world_automode_setting_2_1"
			}
		},
		treasure = {
			text = "world_automode_setting_new_1",
			info = {
				all = "world_automode_setting_new_1_5",
				["6"] = "world_automode_setting_new_1_4",
				["5"] = "world_automode_setting_new_1_3",
				until_3 = "world_automode_setting_new_1_1",
				["4"] = "world_automode_setting_new_1_2"
			}
		},
		wait = {
			text = "world_automode_setting_all_1",
			info = {
				yes = "world_automode_setting_all_1_1",
				no = "world_automode_setting_all_1_2"
			}
		},
		wait_2 = {
			text = "world_automode_setting_all_4",
			info = {
				yes = "world_automode_setting_all_4_1",
				no = "world_automode_setting_all_4_2"
			}
		},
		boss = {
			text = "world_automode_setting_all_2",
			info = {
				["200"] = "world_automode_setting_all_2_3",
				["100"] = "world_automode_setting_all_2_2",
				no = "world_automode_setting_all_2_1"
			}
		},
		consume = {
			text = "world_automode_setting_all_3",
			info = {
				yes = "world_automode_setting_all_3_2",
				no = "world_automode_setting_all_3_1"
			}
		}
	}

	for iter6, iter7 in pairs(var10) do
		local var11 = arg0.rtView:Find("content/" .. iter6)

		setText(var11:Find("Text"), i18n(iter7.text))

		for iter8, iter9 in pairs(iter7.info) do
			setText(var11:Find("toggles/" .. iter8 .. "/Text"), i18n(iter9))
		end
	end

	setText(arg0.rtWindow:Find("top/bg/title"), i18n("world_automode_title_1"))
	setText(arg0.rtWindow:Find("top/bg/title/title_en"), i18n("world_automode_title_2"))
	setText(arg0.rtContent:Find("toggles/toggle_base/Text"), i18n("area_putong"))
	setText(arg0.rtContent:Find("toggles/toggle_safe/Text"), i18n("area_anquan"))
	setText(arg0.rtContent:Find("toggles/toggle_treasure/Text"), i18n("area_yinmi"))
end

function var0.didEnter(arg0)
	triggerToggle(arg0.rtContent:Find("toggles"):GetChild(PlayerPrefs.GetInt("auto_switch_mode", 0)), true)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initToggle(arg0, arg1)
	local var0 = arg0.togglesList[arg1]
	local var1 = var0.getFlag()

	for iter0, iter1 in pairs(var0.info) do
		if iter1 == var1 then
			triggerToggle(arg0.rtView:Find("content/" .. arg1 .. "/toggles/" .. iter0), true)

			break
		end
	end
end

function var0.updateView(arg0, arg1)
	PlayerPrefs.SetInt("auto_switch_mode", arg1)
	PlayerPrefs.Save()

	local var0 = nowWorld()
	local var1 = arg1 == var0.MODE_TREASURE and not var0:GetGobalFlag("treasure_flag")

	setActive(arg0.rtView:Find("content"), not var1)
	setActive(arg0.rtContent:Find("scrollbar"), not var1)
	setActive(arg0.rtView:Find("tip"), var1)
	setActive(arg0.btnConfirm, not var1)
	setActive(arg0.btnMove, var1)

	if var1 then
		if var0:GetInventoryProxy():GetItemCount(WorldConst.SwitchPlainingItemId) > 0 then
			setText(arg0.rtView:Find("tip/Text"), i18n("world_automode_treasure_2"))
		else
			setText(arg0.rtView:Find("tip/Text"), i18n("world_automode_treasure_1"))
		end
	end

	eachChild(arg0.rtView:Find("content"), function(arg0)
		setActive(arg0, var0.modeToggleDic[arg1][arg0.name])

		if var0.modeToggleDic[arg1] then
			switch(arg0.name, {
				base = function()
					local var0 = {}

					for iter0, iter1 in ipairs(var0.paresingToggleString(PlayerPrefs.GetString("auto_switch_difficult_base", "all"))) do
						var0[iter1] = true
					end

					eachChild(arg0.rtView:Find("content/base/toggles"), function(arg0)
						triggerToggle(arg0, var0[arg0.name])
					end)
				end,
				treasure = function()
					local var0 = {}

					for iter0, iter1 in ipairs(var0.paresingToggleString(PlayerPrefs.GetString("auto_switch_difficult_treasure", "all"))) do
						var0[iter1] = true
					end

					eachChild(arg0.rtView:Find("content/treasure/toggles"), function(arg0)
						triggerToggle(arg0, var0[arg0.name])
					end)
				end
			}, function()
				arg0:initToggle(arg0.name)
			end)
		end
	end)
end

function var0.saveConfig(arg0, arg1)
	local var0 = {}

	eachChild(arg0.rtView:Find("content/" .. arg1 .. "/toggles"), function(arg0)
		if GetComponent(arg0, typeof(Toggle)).isOn then
			table.insert(var0, arg0.name)
		end
	end)
	PlayerPrefs.SetString("auto_switch_difficult_" .. arg1, table.concat(var0, "&"))
	PlayerPrefs.Save()
end

function var0.paresingToggleString(arg0)
	if not arg0 or arg0 == "" then
		return {}
	end

	return string.split(arg0, "&")
end

function var0.checkDifficultValid(arg0, arg1)
	local var0 = var0.paresingToggleString(arg0)

	for iter0, iter1 in ipairs(var0) do
		if iter1 == "all" then
			return true
		elseif string.sub(iter1, 1, 6) == "until_" then
			if arg1 <= tonumber(string.sub(iter1, 7)) then
				return true
			end
		elseif arg1 == tonumber(iter1) then
			return true
		end
	end

	return false
end

return var0
