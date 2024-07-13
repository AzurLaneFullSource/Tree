local var0_0 = class("WorldSwitchPlanningLayer", import("view.base.BaseUI"))

var0_0.MODE_DIFFICULT = 0
var0_0.MODE_SAFE = 1
var0_0.MODE_TREASURE = 2
var0_0.modeToggleDic = {
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

function var0_0.getUIName(arg0_1)
	return "WorldSwitchPlanningUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)

	arg0_2.rtBg = arg0_2._tf:Find("bg")

	onButton(arg0_2, arg0_2.rtBg, function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.rtWindow = arg0_2._tf:Find("window")
	arg0_2.btnBack = arg0_2.rtWindow:Find("top/btnBack")

	onButton(arg0_2, arg0_2.btnBack, function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.btnCancel = arg0_2.rtWindow:Find("button_container/custom_button_2")

	setText(arg0_2.btnCancel:Find("pic"), i18n("text_cancel"))
	onButton(arg0_2, arg0_2.btnCancel, function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.btnConfirm = arg0_2.rtWindow:Find("button_container/custom_button_1")

	setText(arg0_2.btnConfirm:Find("pic"), i18n("text_confirm"))
	onButton(arg0_2, arg0_2.btnConfirm, function()
		arg0_2:emit(WorldSwitchPlanningMediator.OnConfirm)
		arg0_2:closeView()
	end, SFX_CONFIRM)

	arg0_2.btnMove = arg0_2.rtWindow:Find("button_container/custom_button_3")

	setText(arg0_2.btnMove:Find("pic"), i18n("text_goto"))
	onButton(arg0_2, arg0_2.btnMove, function()
		local var0_7 = nowWorld()

		if var0_7:GetInventoryProxy():GetItemCount(WorldConst.SwitchPlainingItemId) > 0 then
			arg0_2:emit(WorldSwitchPlanningMediator.OnMove, {
				inMap = true,
				context = Context.New({
					mediator = WorldInventoryMediator,
					viewComponent = WorldInventoryLayer
				})
			})
		elseif not var0_7:IsSystemOpen(WorldConst.SystemResetShop) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_treasure_3"))
		else
			arg0_2:emit(WorldSwitchPlanningMediator.OnMove, {
				inMap = false,
				context = Context.New({
					mediator = WorldShopMediator,
					viewComponent = WorldShopLayer
				})
			})
		end

		arg0_2:closeView()
	end, SFX_CONFIRM)

	arg0_2.rtContent = arg0_2.rtWindow:Find("content")

	onToggle(arg0_2, arg0_2.rtContent:Find("toggles/toggle_base"), function(arg0_8)
		if arg0_8 then
			arg0_2:updateView(var0_0.MODE_DIFFICULT)
			scrollTo(arg0_2.rtView:Find("content"), nil, 1)
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.rtContent:Find("toggles/toggle_safe"), function(arg0_9)
		if arg0_9 then
			arg0_2:updateView(var0_0.MODE_SAFE)
			scrollTo(arg0_2.rtView:Find("content"), nil, 1)
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.rtContent:Find("toggles/toggle_treasure"), function(arg0_10)
		if arg0_10 then
			arg0_2:updateView(var0_0.MODE_TREASURE)
			scrollTo(arg0_2.rtView:Find("content"), nil, 1)
		end
	end, SFX_PANEL)

	arg0_2.rtView = arg0_2.rtContent:Find("view")

	for iter0_2, iter1_2 in ipairs({
		"base",
		"treasure"
	}) do
		local var0_2 = arg0_2.rtView:Find("content/" .. iter1_2 .. "/toggles")
		local var1_2 = var0_2:Find("all")
		local var2_2 = {}
		local var3_2 = 0
		local var4_2 = var0_2.childCount

		eachChild(var0_2, function(arg0_11)
			onToggle(arg0_2, arg0_11, function(arg0_12)
				local var0_12 = (arg0_12 and 1 or 0) - defaultValue(var2_2[arg0_11.name], 0)

				var2_2[arg0_11.name] = arg0_12 and 1 or 0
				var3_2 = var3_2 + var0_12

				local var1_12 = true

				if arg0_11 == var1_2 and arg0_12 then
					eachChild(var0_2, function(arg0_13)
						if arg0_13 ~= arg0_11 and GetComponent(arg0_13, typeof(Toggle)).isOn == true then
							triggerToggle(arg0_13, false)

							var1_12 = false
						end
					end)
				elseif var3_2 == 0 or var3_2 >= var4_2 - 1 then
					triggerToggle(var1_2, true)

					var1_12 = false
				elseif var3_2 > 1 and GetComponent(var1_2, typeof(Toggle)).isOn == true then
					triggerToggle(var1_2, false)

					var1_12 = false
				end

				if var1_12 then
					arg0_2:saveConfig(iter1_2)
				end
			end, SFX_PANEL)
		end)
	end

	local var5_2 = pg.gameset.joint_boss_ticket.description
	local var6_2 = var5_2[1] + var5_2[2]
	local var7_2 = var5_2[1] .. "&" .. var6_2
	local var8_2 = {}

	table.insert(var8_2, "")
	table.insert(var8_2, var7_2)
	table.insert(var8_2, tostring(var6_2))

	arg0_2.togglesList = {
		safe = {
			getFlag = function()
				return PlayerPrefs.GetString("auto_switch_difficult_safe", "all")
			end,
			setFlag = function(arg0_15)
				PlayerPrefs.SetString("auto_switch_difficult_safe", arg0_15)
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
			setFlag = function(arg0_17)
				PlayerPrefs.SetInt("auto_switch_wait", arg0_17)
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
			setFlag = function(arg0_19)
				PlayerPrefs.SetInt("auto_switch_wait_2", arg0_19)
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
			setFlag = function(arg0_21)
				getProxy(SettingsProxy):WorldBossProgressTipFlag(arg0_21)
			end,
			info = {
				no = var8_2[1],
				["100"] = var8_2[2],
				["200"] = var8_2[3]
			}
		},
		consume = {
			getFlag = function()
				return getProxy(SettingsProxy):GetWorldFlag("consume_item")
			end,
			setFlag = function(arg0_23)
				getProxy(SettingsProxy):SetWorldFlag("consume_item", arg0_23)
			end,
			info = {
				yes = true,
				no = false
			}
		}
	}

	for iter2_2, iter3_2 in pairs(arg0_2.togglesList) do
		local var9_2 = arg0_2.rtView:Find("content/" .. iter2_2 .. "/toggles")

		for iter4_2, iter5_2 in pairs(iter3_2.info) do
			onToggle(arg0_2, var9_2:Find(iter4_2), function(arg0_24)
				if arg0_24 then
					iter3_2.setFlag(iter5_2)
				end
			end, SFX_PANEL)
		end
	end

	local var10_2 = {
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

	for iter6_2, iter7_2 in pairs(var10_2) do
		local var11_2 = arg0_2.rtView:Find("content/" .. iter6_2)

		setText(var11_2:Find("Text"), i18n(iter7_2.text))

		for iter8_2, iter9_2 in pairs(iter7_2.info) do
			setText(var11_2:Find("toggles/" .. iter8_2 .. "/Text"), i18n(iter9_2))
		end
	end

	setText(arg0_2.rtWindow:Find("top/bg/title"), i18n("world_automode_title_1"))
	setText(arg0_2.rtWindow:Find("top/bg/title/title_en"), i18n("world_automode_title_2"))
	setText(arg0_2.rtContent:Find("toggles/toggle_base/Text"), i18n("area_putong"))
	setText(arg0_2.rtContent:Find("toggles/toggle_safe/Text"), i18n("area_anquan"))
	setText(arg0_2.rtContent:Find("toggles/toggle_treasure/Text"), i18n("area_yinmi"))
end

function var0_0.didEnter(arg0_25)
	triggerToggle(arg0_25.rtContent:Find("toggles"):GetChild(PlayerPrefs.GetInt("auto_switch_mode", 0)), true)
end

function var0_0.willExit(arg0_26)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_26._tf)
end

function var0_0.initToggle(arg0_27, arg1_27)
	local var0_27 = arg0_27.togglesList[arg1_27]
	local var1_27 = var0_27.getFlag()

	for iter0_27, iter1_27 in pairs(var0_27.info) do
		if iter1_27 == var1_27 then
			triggerToggle(arg0_27.rtView:Find("content/" .. arg1_27 .. "/toggles/" .. iter0_27), true)

			break
		end
	end
end

function var0_0.updateView(arg0_28, arg1_28)
	PlayerPrefs.SetInt("auto_switch_mode", arg1_28)
	PlayerPrefs.Save()

	local var0_28 = nowWorld()
	local var1_28 = arg1_28 == var0_0.MODE_TREASURE and not var0_28:GetGobalFlag("treasure_flag")

	setActive(arg0_28.rtView:Find("content"), not var1_28)
	setActive(arg0_28.rtContent:Find("scrollbar"), not var1_28)
	setActive(arg0_28.rtView:Find("tip"), var1_28)
	setActive(arg0_28.btnConfirm, not var1_28)
	setActive(arg0_28.btnMove, var1_28)

	if var1_28 then
		if var0_28:GetInventoryProxy():GetItemCount(WorldConst.SwitchPlainingItemId) > 0 then
			setText(arg0_28.rtView:Find("tip/Text"), i18n("world_automode_treasure_2"))
		else
			setText(arg0_28.rtView:Find("tip/Text"), i18n("world_automode_treasure_1"))
		end
	end

	eachChild(arg0_28.rtView:Find("content"), function(arg0_29)
		setActive(arg0_29, var0_0.modeToggleDic[arg1_28][arg0_29.name])

		if var0_0.modeToggleDic[arg1_28] then
			switch(arg0_29.name, {
				base = function()
					local var0_30 = {}

					for iter0_30, iter1_30 in ipairs(var0_0.paresingToggleString(PlayerPrefs.GetString("auto_switch_difficult_base", "all"))) do
						var0_30[iter1_30] = true
					end

					eachChild(arg0_28.rtView:Find("content/base/toggles"), function(arg0_31)
						triggerToggle(arg0_31, var0_30[arg0_31.name])
					end)
				end,
				treasure = function()
					local var0_32 = {}

					for iter0_32, iter1_32 in ipairs(var0_0.paresingToggleString(PlayerPrefs.GetString("auto_switch_difficult_treasure", "all"))) do
						var0_32[iter1_32] = true
					end

					eachChild(arg0_28.rtView:Find("content/treasure/toggles"), function(arg0_33)
						triggerToggle(arg0_33, var0_32[arg0_33.name])
					end)
				end
			}, function()
				arg0_28:initToggle(arg0_29.name)
			end)
		end
	end)
end

function var0_0.saveConfig(arg0_35, arg1_35)
	local var0_35 = {}

	eachChild(arg0_35.rtView:Find("content/" .. arg1_35 .. "/toggles"), function(arg0_36)
		if GetComponent(arg0_36, typeof(Toggle)).isOn then
			table.insert(var0_35, arg0_36.name)
		end
	end)
	PlayerPrefs.SetString("auto_switch_difficult_" .. arg1_35, table.concat(var0_35, "&"))
	PlayerPrefs.Save()
end

function var0_0.paresingToggleString(arg0_37)
	if not arg0_37 or arg0_37 == "" then
		return {}
	end

	return string.split(arg0_37, "&")
end

function var0_0.checkDifficultValid(arg0_38, arg1_38)
	local var0_38 = var0_0.paresingToggleString(arg0_38)

	for iter0_38, iter1_38 in ipairs(var0_38) do
		if iter1_38 == "all" then
			return true
		elseif string.sub(iter1_38, 1, 6) == "until_" then
			if arg1_38 <= tonumber(string.sub(iter1_38, 7)) then
				return true
			end
		elseif arg1_38 == tonumber(iter1_38) then
			return true
		end
	end

	return false
end

return var0_0
