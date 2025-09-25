local var0_0 = class("CityRebuildBookLayer", import("view.base.BaseUI"))

var0_0.Building = "building"
var0_0.Chara = "chara"
var0_0.Buff = "buff"

function var0_0.getUIName(arg0_1)
	return "CityRebuildBookUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.closeBtn = arg0_2._tf:Find("panel/closeBtn")
	arg0_2.buildingTg = arg0_2._tf:Find("panel/switch/building")
	arg0_2.charaTg = arg0_2._tf:Find("panel/switch/chara")
	arg0_2.buffTg = arg0_2._tf:Find("panel/switch/buff")
	arg0_2.buildingPage = arg0_2._tf:Find("panel/subPages/buildingPage")
	arg0_2.charaPage = arg0_2._tf:Find("panel/subPages/charaPage")
	arg0_2.buffPage = arg0_2._tf:Find("panel/subPages/buffPage")

	setText(arg0_2.buildingPage:Find("left/buildingScroll/Viewport/Content/city/title/name"), i18n("ninja_game_citylevel") .. ":")
	setText(arg0_2.charaPage:Find("left/charaScroll/Viewport/Content/city/title/name"), i18n("ninja_game_citylevel") .. ":")
	setText(arg0_2.buildingPage:Find("right/consumeTitle/Text"), i18n("ninja_game_buildcost"))
	setText(arg0_2.charaPage:Find("right/consumeTitle/Text"), i18n("ninja_game_allycost"))
	setText(arg0_2.buffPage:Find("left/panel/buildingDPS"), i18n("ninja_game_citydmg"))
	setText(arg0_2.buffPage:Find("left/panel/charaDPS"), i18n("ninja_game_allydmg"))
	setText(arg0_2.buffPage:Find("left/panel/DPS"), i18n("ninja_game_dps"))
	setText(arg0_2.buffPage:Find("left/panel/time"), i18n("ninja_game_time"))
	setText(arg0_2.buffPage:Find("left/panel/pts"), i18n("ninja_game_income"))
	setText(arg0_2.buffPage:Find("left/panel/pt"), i18n("ninja_game_ptcount"))
	setText(arg0_2.buffPage:Find("right/buffScroll/Viewport/Content/buff/descTitle"), i18n("ninja_game_buffeffect"))
	setText(arg0_2.buffPage:Find("right/buffScroll/Viewport/Content/buff/nextLevelPt/title"), i18n("ninja_game_buffcost"))
	setText(arg0_2.buffPage:Find("right/buffScroll/Viewport/Content/buff/levelMax"), i18n("ninja_game_levelblock"))
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onToggle(arg0_3, arg0_3.buildingTg, function(arg0_6)
		setActive(arg0_3.buildingPage, arg0_6)
		setActive(arg0_3.charaPage, not arg0_6)
		setActive(arg0_3.buffPage, not arg0_6)

		if arg0_6 then
			if arg0_3.page ~= var0_0.Building then
				triggerToggle(arg0_3.firstBuildingTg, true)
			end

			arg0_3.page = var0_0.Building
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.charaTg, function(arg0_7)
		setActive(arg0_3.buildingPage, not arg0_7)
		setActive(arg0_3.charaPage, arg0_7)
		setActive(arg0_3.buffPage, not arg0_7)

		if arg0_7 then
			if arg0_3.page ~= var0_0.Chara then
				triggerToggle(arg0_3.firstCharaTg, true)
			end

			arg0_3.page = var0_0.Chara
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.buffTg, function(arg0_8)
		setActive(arg0_3.buildingPage, not arg0_8)
		setActive(arg0_3.charaPage, not arg0_8)
		setActive(arg0_3.buffPage, arg0_8)

		if arg0_8 then
			arg0_3.page = var0_0.Buff
		end
	end, SFX_PANEL)
	arg0_3:Refresh()
end

function var0_0.InitData(arg0_9)
	arg0_9.activityId = ActivityConst.NINJA_CITY_ACT_ID
	arg0_9.cityRebuildProxy = getProxy(CityRebuildProxy)
	arg0_9.cityRebuildData = arg0_9.cityRebuildProxy:GetData(arg0_9.activityId)
	arg0_9.page = arg0_9.contextData.page or var0_0.Building

	if arg0_9.page == var0_0.Building then
		arg0_9.showBuildingId = arg0_9.contextData.showId
	elseif arg0_9.page == var0_0.Chara then
		arg0_9.showCharaId = arg0_9.contextData.showId
	end

	if not arg0_9.showBuildingId then
		arg0_9.showBuildingId = arg0_9.cityRebuildData.Levelbuildings[1][1]
	end

	if not arg0_9.showCharaId then
		arg0_9.showCharaId = arg0_9.cityRebuildData.Levelcharas[1][1]
	end
end

function var0_0.Refresh(arg0_10)
	arg0_10.virtualBagActivity = getProxy(ActivityProxy):getActivityById(arg0_10.activityId)

	arg0_10:RemoveTimer()
	arg0_10:RemoveAllTimers()
	arg0_10:RefreshBuildingPage()
	arg0_10:RefreshCharaPage()
	arg0_10:RefreshBuffPage()
	triggerToggle(arg0_10._tf:Find("panel/switch/" .. arg0_10.page), true)
	setActive(arg0_10.charaTg:Find("tip"), var0_0.ShouldShowTip())
end

function var0_0.RefreshBuildingPage(arg0_11)
	local var0_11 = UIItemList.New(arg0_11.buildingPage:Find("left/buildingScroll/Viewport/Content"), arg0_11.buildingPage:Find("left/buildingScroll/Viewport/Content/city"))
	local var1_11 = arg0_11.cityRebuildData.Levelbuildings

	var0_11:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var1_11[arg1_12 + 1]
			local var1_12 = arg0_11.cityRebuildData.cityLevel >= arg1_12 + 1 and Color.New(1, 1, 1, 1) or Color.New(0.819607843137255, 0.819607843137255, 0.819607843137255, 1)

			arg2_12:Find("title/name"):GetComponent(typeof(Text)).color = var1_12
			arg2_12:Find("title/name/Text"):GetComponent(typeof(Text)).color = var1_12

			setText(arg2_12:Find("title/name/Text"), "Lv." .. arg1_12 + 1)
			setActive(arg2_12:Find("title/name/lock"), arg0_11.cityRebuildData.cityLevel < arg1_12 + 1)

			local var2_12 = UIItemList.New(arg2_12:Find("buildings"), arg2_12:Find("buildings/building"))

			var2_12:make(function(arg0_13, arg1_13, arg2_13)
				if arg0_13 == UIItemList.EventUpdate then
					local var0_13 = pg.activity_ninja_building[var0_12[arg1_13 + 1]]
					local var1_13 = table.contains(arg0_11.cityRebuildData.buildings, var0_13.id)

					setActive(arg2_13:Find("iconBg/lock"), arg0_11.cityRebuildData.cityLevel < arg1_12 + 1)
					setActive(arg2_13:Find("iconBg/icon"), arg0_11.cityRebuildData.cityLevel >= arg1_12 + 1)

					local var2_13 = ""

					if arg0_11.cityRebuildData.cityLevel >= arg1_12 + 1 then
						var2_13 = var1_13 and var0_13.handbook_pic[2] or var0_13.handbook_pic[1]
					end

					if var2_13 ~= "" then
						GetImageSpriteFromAtlasAsync(var2_13, "", arg2_13:Find("iconBg/icon"))
					end

					arg2_13:Find("nameMask/name"):GetComponent(typeof(Text)).color = arg0_11.cityRebuildData.cityLevel >= arg1_12 + 1 and Color.New(0, 0, 0, 1) or Color.New(0.345098039215686, 0.384313725490196, 0.4, 1)

					local var3_13 = var1_13 and var0_13.name[2] or var0_13.name[1]

					setScrollText(arg2_13:Find("nameMask/name"), var3_13)
					setActive(arg2_13:Find("isRepaired"), var1_13)

					if arg0_11.cityRebuildData.cityLevel >= arg1_12 + 1 then
						arg2_13:GetComponent(typeof(Toggle)).interactable = true

						onToggle(arg0_11, arg2_13, function(arg0_14)
							if arg0_14 then
								arg0_11.showBuildingId = var0_13.id

								setText(arg0_11.buildingPage:Find("right/name"), var3_13)
								GetImageSpriteFromAtlasAsync(var2_13, "", arg0_11.buildingPage:Find("right/iconBg/icon"))

								local var0_14 = var1_13 and var0_13.desc[2] or var0_13.desc[1]

								setText(arg0_11.buildingPage:Find("right/desc"), var0_14)
								setActive(arg0_11.buildingPage:Find("right/consumeTitle"), not var1_13)
								setActive(arg0_11.buildingPage:Find("right/consume"), not var1_13)
								setActive(arg0_11.buildingPage:Find("right/rebuildBtn"), not var1_13)

								if not var1_13 then
									local var1_14 = {
										type = var0_13.cost[1],
										id = var0_13.cost[2],
										count = var0_13.cost[3]
									}

									updateDrop(arg0_11.buildingPage:Find("right/consume/cost/mask/item"), var1_14)
									onButton(arg0_11, arg0_11.buildingPage:Find("right/consume/cost"), function()
										arg0_11:emit(BaseUI.ON_DROP, var1_14)
									end, SFX_PANEL)

									local var2_14 = arg0_11.virtualBagActivity:getVitemNumber(var0_13.cost[2])

									arg0_11.buildingPage:Find("right/consume/cost/mask/item/icon_bg/count"):GetComponent(typeof(Text)).color = var2_14 < var0_13.cost[3] and Color.New(0.835294117647059, 0.462745098039216, 0.462745098039216, 1) or Color.New(1, 1, 1, 1)

									local var3_14 = {
										type = var0_13.pt_cost[1],
										id = var0_13.pt_cost[2],
										count = var0_13.pt_cost[3]
									}

									updateDrop(arg0_11.buildingPage:Find("right/consume/ptCost/mask/item"), var3_14)
									onButton(arg0_11, arg0_11.buildingPage:Find("right/consume/ptCost"), function()
										arg0_11:emit(BaseUI.ON_DROP, var3_14)
									end, SFX_PANEL)

									arg0_11.buildingPage:Find("right/consume/ptCost/mask/item/icon_bg/count"):GetComponent(typeof(Text)).color = arg0_11.cityRebuildData.pt < var0_13.pt_cost[3] and Color.New(0.835294117647059, 0.462745098039216, 0.462745098039216, 1) or Color.New(1, 1, 1, 1)

									onButton(arg0_11, arg0_11.buildingPage:Find("right/rebuildBtn"), function()
										if var2_14 < var0_13.cost[3] or arg0_11.cityRebuildData.pt < var0_13.pt_cost[3] then
											pg.TipsMgr.GetInstance():ShowTips(i18n("ninja_game_update_failed"))

											return
										end

										arg0_11:emit(CityRebuildBookMediator.REBUILD_OR_START_RECRUIT, arg0_11.activityId, var0_13.id, var0_13.cost, var0_13.pt_cost)
									end, SFX_PANEL)
								end
							end
						end, SFX_PANEL)

						if arg0_11.showBuildingId == var0_13.id then
							triggerToggle(arg2_13, true)
						end
					else
						arg2_13:GetComponent(typeof(Toggle)).interactable = false
					end

					if arg1_12 == 0 and arg1_13 == 0 then
						arg0_11.firstBuildingTg = arg2_13
					end
				end
			end)
			var2_12:align(#var0_12)
		end
	end)
	var0_11:align(#var1_11)
end

function var0_0.RefreshCharaPage(arg0_18)
	local var0_18 = UIItemList.New(arg0_18.charaPage:Find("left/charaScroll/Viewport/Content"), arg0_18.charaPage:Find("left/charaScroll/Viewport/Content/city"))
	local var1_18 = arg0_18.cityRebuildData.Levelcharas

	var0_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var1_18[arg1_19 + 1]

			setActive(arg2_19, #var0_19 > 0)

			if #var0_19 > 0 then
				local var1_19 = arg0_18.cityRebuildData.cityLevel >= arg1_19 + 1 and Color.New(1, 1, 1, 1) or Color.New(0.819607843137255, 0.819607843137255, 0.819607843137255, 1)

				arg2_19:Find("title/name"):GetComponent(typeof(Text)).color = var1_19
				arg2_19:Find("title/name/Text"):GetComponent(typeof(Text)).color = var1_19

				setText(arg2_19:Find("title/name/Text"), "Lv." .. arg1_19 + 1)
				setActive(arg2_19:Find("title/name/lock"), arg0_18.cityRebuildData.cityLevel < arg1_19 + 1)

				local var2_19 = UIItemList.New(arg2_19:Find("charas"), arg2_19:Find("charas/chara"))

				var2_19:make(function(arg0_20, arg1_20, arg2_20)
					if arg0_20 == UIItemList.EventUpdate then
						local var0_20 = pg.activity_ninja_building[var0_19[arg1_20 + 1]]
						local var1_20 = table.contains(arg0_18.cityRebuildData.roles, var0_20.id)
						local var2_20 = arg0_18.cityRebuildData.recruiting[var0_20.id] ~= nil
						local var3_20 = false

						if var2_20 then
							var3_20 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_18.cityRebuildData.recruiting[var0_20.id] >= var0_20.time
						end

						setActive(arg2_20:Find("iconBg/time"), var2_20 and not var3_20)

						local var4_20 = arg0_18.cityRebuildData.recruiting[var0_20.id]

						if var2_20 and not var3_20 then
							arg0_18:StartTimers(function()
								local var0_21 = pg.TimeMgr.GetInstance():GetServerTime() - var4_20

								if var0_21 < var0_20.time then
									setText(arg2_20:Find("iconBg/time/Text"), arg0_18:DescCDTime(var0_20.time - var0_21))

									arg2_20:Find("iconBg/time"):GetComponent(typeof(Image)).fillAmount = (var0_20.time - var0_21) / var0_20.time
								else
									setActive(arg2_20:Find("iconBg/time"), false)
									arg0_18.timerList[var0_20.id]:Stop()

									arg0_18.timerList[var0_20.id] = nil
								end
							end, var0_20.id)
						end

						setActive(arg2_20:Find("iconBg/lock"), arg0_18.cityRebuildData.cityLevel < arg1_19 + 1)
						setActive(arg2_20:Find("iconBg/icon"), arg0_18.cityRebuildData.cityLevel >= arg1_19 + 1)

						local var5_20 = ""

						if arg0_18.cityRebuildData.cityLevel >= arg1_19 + 1 then
							var5_20 = var1_20 and var0_20.handbook_pic[2] or var0_20.handbook_pic[1]
						end

						if var5_20 ~= "" then
							GetImageSpriteFromAtlasAsync(var5_20, "", arg2_20:Find("iconBg/icon"))
						end

						arg2_20:Find("nameMask/name"):GetComponent(typeof(Text)).color = arg0_18.cityRebuildData.cityLevel >= arg1_19 + 1 and Color.New(0, 0, 0, 1) or Color.New(0.345098039215686, 0.384313725490196, 0.4, 1)

						local var6_20 = var1_20 and var0_20.name[2] or var0_20.name[1]

						setScrollText(arg2_20:Find("nameMask/name"), var6_20)
						setActive(arg2_20:Find("isRepaired"), var1_20)

						if arg0_18.cityRebuildData.cityLevel >= arg1_19 + 1 then
							arg2_20:GetComponent(typeof(Toggle)).interactable = true

							onToggle(arg0_18, arg2_20, function(arg0_22)
								if arg0_22 then
									arg0_18.showCharaId = var0_20.id

									arg0_18:RemoveTimer()
									setText(arg0_18.charaPage:Find("right/name"), var6_20)
									GetImageSpriteFromAtlasAsync(var5_20, "", arg0_18.charaPage:Find("right/iconBg/icon"))

									local var0_22 = var1_20 and var0_20.desc[2] or var0_20.desc[1]

									setText(arg0_18.charaPage:Find("right/desc"), var0_22)
									setActive(arg0_18.charaPage:Find("right/consumeTitle"), not var1_20 and not var2_20)
									setActive(arg0_18.charaPage:Find("right/consume"), not var1_20 and not var2_20)
									setActive(arg0_18.charaPage:Find("right/recruitBtn"), not var1_20 and not var2_20)

									if not var1_20 and not var2_20 then
										local var1_22 = {
											type = var0_20.cost[1],
											id = var0_20.cost[2],
											count = var0_20.cost[3]
										}

										updateDrop(arg0_18.charaPage:Find("right/consume/cost/mask/item"), var1_22)
										onButton(arg0_18, arg0_18.charaPage:Find("right/consume/cost"), function()
											arg0_18:emit(BaseUI.ON_DROP, var1_22)
										end, SFX_PANEL)

										local var2_22 = arg0_18.virtualBagActivity:getVitemNumber(var0_20.cost[2])

										arg0_18.charaPage:Find("right/consume/cost/mask/item/icon_bg/count"):GetComponent(typeof(Text)).color = var2_22 < var0_20.cost[3] and Color.New(0.835294117647059, 0.462745098039216, 0.462745098039216, 1) or Color.New(1, 1, 1, 1)

										local var3_22 = {
											type = var0_20.pt_cost[1],
											id = var0_20.pt_cost[2],
											count = var0_20.pt_cost[3]
										}

										updateDrop(arg0_18.charaPage:Find("right/consume/ptCost/mask/item"), var3_22)
										onButton(arg0_18, arg0_18.charaPage:Find("right/consume/ptCost"), function()
											arg0_18:emit(BaseUI.ON_DROP, var3_22)
										end, SFX_PANEL)

										arg0_18.charaPage:Find("right/consume/ptCost/mask/item/icon_bg/count"):GetComponent(typeof(Text)).color = arg0_18.cityRebuildData.pt < var0_20.pt_cost[3] and Color.New(0.835294117647059, 0.462745098039216, 0.462745098039216, 1) or Color.New(1, 1, 1, 1)

										onButton(arg0_18, arg0_18.charaPage:Find("right/recruitBtn"), function()
											if var2_22 < var0_20.cost[3] or arg0_18.cityRebuildData.pt < var0_20.pt_cost[3] then
												pg.TipsMgr.GetInstance():ShowTips(i18n("ninja_game_update_failed"))

												return
											end

											arg0_18:emit(CityRebuildBookMediator.REBUILD_OR_START_RECRUIT, arg0_18.activityId, var0_20.id, var0_20.cost, var0_20.pt_cost)
										end, SFX_PANEL)
									end

									if var2_20 then
										var3_20 = pg.TimeMgr.GetInstance():GetServerTime() - arg0_18.cityRebuildData.recruiting[var0_20.id] >= var0_20.time
									end

									setActive(arg0_18.charaPage:Find("right/recruiting"), var2_20 and not var3_20)
									setActive(arg0_18.charaPage:Find("right/endRecruitBtn"), var2_20 and var3_20)

									if var2_20 then
										if var3_20 then
											local var4_22 = {
												var0_20.id
											}

											onButton(arg0_18, arg0_18.charaPage:Find("right/endRecruitBtn"), function()
												arg0_18:emit(CityRebuildBookMediator.END_RECRUIT, arg0_18.activityId, var4_22)
											end, SFX_PANEL)
										else
											arg0_18:StartTimer(function()
												local var0_27 = pg.TimeMgr.GetInstance():GetServerTime() - var4_20

												if var0_27 < var0_20.time then
													setText(arg0_18.charaPage:Find("right/recruiting/Text"), arg0_18:DescCDTime(var0_20.time - var0_27))
												else
													setActive(arg0_18.charaPage:Find("right/recruiting"), false)
													setActive(arg0_18.charaPage:Find("right/endRecruitBtn"), true)

													local var1_27 = {
														var0_20.id
													}

													onButton(arg0_18, arg0_18.charaPage:Find("right/endRecruitBtn"), function()
														arg0_18:emit(CityRebuildBookMediator.END_RECRUIT, arg0_18.activityId, var1_27)
													end, SFX_PANEL)
													arg0_18:RemoveTimer()
												end
											end)
										end
									end
								end
							end, SFX_PANEL)

							if arg0_18.showCharaId == var0_20.id then
								triggerToggle(arg2_20, true)
							end
						else
							arg2_20:GetComponent(typeof(Toggle)).interactable = false
						end

						if arg1_19 == 0 and arg1_20 == 0 then
							arg0_18.firstCharaTg = arg2_20
						end
					end
				end)
				var2_19:align(#var0_19)
			end
		end
	end)
	var0_18:align(#var1_18)
end

function var0_0.RefreshBuffPage(arg0_29)
	arg0_29:SetSummaryPanel()

	local var0_29 = arg0_29.cityRebuildData.buffs
	local var1_29 = arg0_29.cityRebuildData.buffLevels

	table.sort(var0_29, CompareFuncs({
		function(arg0_30)
			return pg.activity_ninja_buff[arg0_30].group
		end
	}))

	local var2_29 = pg.activity_ninja_city[arg0_29.cityRebuildData.cityLevel].buff
	local var3_29 = UIItemList.New(arg0_29.buffPage:Find("right/buffScroll/Viewport/Content"), arg0_29.buffPage:Find("right/buffScroll/Viewport/Content/buff"))

	var3_29:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = pg.activity_ninja_buff[var0_29[arg1_31 + 1]]
			local var1_31 = pg.activity_ninja_buff.get_id_list_by_group[arg1_31 + 1]
			local var2_31 = pg.activity_ninja_buff[var1_31[1]]
			local var3_31 = pg.activity_ninja_buff[var1_31[var0_31.level + 1]]
			local var4_31 = var2_29[arg1_31 + 1]
			local var5_31 = pg.activity_ninja_city[5].buff[arg1_31 + 1]

			GetImageSpriteFromAtlasAsync(var0_31.icon, "", arg2_31:Find("icon"))
			setText(arg2_31:Find("name"), i18n(var2_31.name))
			setText(arg2_31:Find("level"), "LV." .. var0_31.level)

			local var6_31 = 0
			local var7_31 = switch(var0_31.group, {
				function()
					return arg0_29:GetParam(5)^(var1_29[1] - 1)
				end,
				function()
					return arg0_29:GetParam(6) * var1_29[2]
				end,
				function()
					return (1 - arg0_29:GetParam(11)^(var1_29[3] - 1)) * 100
				end,
				function()
					return arg0_29:GetParam(15)^var1_29[4]
				end,
				function()
					return var1_29[5]
				end,
				function()
					return arg0_29:GetParam(7) * var1_29[6] * 100
				end,
				function()
					return arg0_29:GetParam(4) * var1_29[7]
				end,
				function()
					return arg0_29:GetParam(1)^(var1_29[8] - 1)
				end,
				function()
					return arg0_29:GetParam(3)^(var1_29[9] - 1)
				end,
				function()
					return var1_29[10]
				end
			})

			setText(arg2_31:Find("desc"), i18n("ninja_buff_effect" .. var0_31.group, string.format("%.2f", var7_31)))

			local var8_31 = var4_31 > var0_31.level and var3_31

			setActive(arg2_31:Find("nextLevelPt"), var8_31)
			setActive(arg2_31:Find("upgradeBtn"), var8_31)
			setActive(arg2_31:Find("upgradeTenBtn"), var8_31)
			setActive(arg2_31:Find("levelMax"), not var8_31)

			if var0_31.level == var5_31 then
				setActive(arg2_31:Find("levelMax"), false)
			end

			if var8_31 then
				local var9_31 = math.ceil(var3_31.basic_cost * var3_31.cost^(var3_31.level - 1) * (1 - arg0_29:GetParam(7) * var1_29[6]))

				setText(arg2_31:Find("nextLevelPt/Text"), var9_31)
				onButton(arg0_29, arg2_31:Find("upgradeBtn"), function()
					if arg0_29.cityRebuildData.pt < var9_31 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ninja_game_update_failed"))

						return
					end

					arg0_29:emit(CityRebuildBookMediator.UPGRADE_BUFF, arg0_29.activityId, arg1_31 + 1, 1, var9_31)
				end, SFX_PANEL)
				onButton(arg0_29, arg2_31:Find("upgradeTenBtn"), function()
					local var0_43 = 1
					local var1_43 = var9_31

					for iter0_43 = 2, 10 do
						local var2_43 = pg.activity_ninja_buff[var1_31[var0_31.level + iter0_43]]

						if var0_31.level + iter0_43 > var4_31 or not var2_43 then
							break
						end

						var0_43 = var0_43 + 1

						if arg1_31 + 1 == 6 then
							var1_43 = var1_43 + math.ceil(var2_43.basic_cost * var2_43.cost^(var2_43.level - 1) * (1 - arg0_29:GetParam(7) * (var0_31.level + iter0_43 - 1)))
						else
							var1_43 = var1_43 + math.ceil(var2_43.basic_cost * var2_43.cost^(var2_43.level - 1) * (1 - arg0_29:GetParam(7) * var1_29[6]))
						end
					end

					if var1_43 > arg0_29.cityRebuildData.pt then
						pg.TipsMgr.GetInstance():ShowTips(i18n("ninja_game_update_failed"))

						return
					end

					arg0_29:emit(CityRebuildBookMediator.UPGRADE_BUFF, arg0_29.activityId, arg1_31 + 1, var0_43, var1_43)
				end, SFX_PANEL)
			end
		end
	end)
	var3_29:align(#var0_29)
end

function var0_0.SetSummaryPanel(arg0_44)
	local var0_44 = arg0_44.cityRebuildData.buildings
	local var1_44 = arg0_44.cityRebuildData.roles
	local var2_44 = arg0_44.cityRebuildData.buffLevels
	local var3_44 = arg0_44.cityRebuildData.curLevel
	local var4_44 = var3_44 % 5 == 0
	local var5_44 = 0
	local var6_44 = pg.activity_ninja_enemy[var3_44].basic

	if var3_44 < 51 then
		var5_44 = math.ceil(var6_44 * (var3_44 - 1 + arg0_44:GetParam(9)^(var3_44 - 1)) * (var4_44 and arg0_44:GetParam(10) or 1) * arg0_44:GetParam(11)^(var2_44[3] - 1))
	else
		var5_44 = math.ceil(var6_44 * (arg0_44:GetParam(16) + arg0_44:GetParam(9)^arg0_44:GetParam(16) * arg0_44:GetParam(13)^(var3_44 - (arg0_44:GetParam(16) + 1))) * (var4_44 and arg0_44:GetParam(10) or 1) * arg0_44:GetParam(11)^(var2_44[3] - 1))
	end

	local var7_44 = math.ceil(arg0_44:GetParam(14)^var3_44 * arg0_44:GetParam(15)^var2_44[4])
	local var8_44 = math.ceil((#var0_44 + var2_44[10] + (#var0_44 + var2_44[10]) * arg0_44:GetParam(1)^(var2_44[8] - 1) / arg0_44:GetParam(2)) * arg0_44:GetParam(3)^(var2_44[9] - 1) + arg0_44:GetParam(4) * var2_44[7])
	local var9_44 = math.ceil((#var1_44 + var2_44[5]) * arg0_44:GetParam(5)^(var2_44[1] - 1) + arg0_44:GetParam(6) * var2_44[2])
	local var10_44 = var8_44 + var9_44
	local var11_44 = CityRebuildData.PtToShow(arg0_44.cityRebuildData.pt)
	local var12_44 = math.ceil(var5_44 / var10_44)
	local var13_44 = string.format("%.2f", var7_44 / var12_44)

	setText(arg0_44.buffPage:Find("left/panel/buildingDPS/Text"), var8_44)
	setText(arg0_44.buffPage:Find("left/panel/charaDPS/Text"), var9_44)
	setText(arg0_44.buffPage:Find("left/panel/DPS/Text"), var10_44)
	setText(arg0_44.buffPage:Find("left/panel/time/Text"), var12_44 .. "s")
	setText(arg0_44.buffPage:Find("left/panel/pts/Text"), "+" .. var13_44 .. "/s")
	setText(arg0_44.buffPage:Find("left/panel/pt/Text"), var11_44)
end

function var0_0.GetParam(arg0_45, arg1_45)
	local var0_45 = pg.gameset["ninja_Param" .. arg1_45]

	return var0_45.key_value ~= 0 and var0_45.key_value or tonumber(var0_45.description)
end

function var0_0.StartTimer(arg0_46, arg1_46)
	arg0_46.timer = Timer.New(arg1_46, 1, -1)

	arg0_46.timer:Start()
end

function var0_0.RemoveTimer(arg0_47)
	if arg0_47.timer then
		arg0_47.timer:Stop()

		arg0_47.timer = nil
	end
end

function var0_0.StartTimers(arg0_48, arg1_48, arg2_48)
	if not arg0_48.timerList then
		arg0_48.timerList = {}
	end

	local var0_48 = Timer.New(arg1_48, 1, -1)

	var0_48:Start()

	arg0_48.timerList[arg2_48] = var0_48
end

function var0_0.RemoveAllTimers(arg0_49)
	if arg0_49.timerList then
		for iter0_49, iter1_49 in pairs(arg0_49.timerList) do
			iter1_49:Stop()
		end

		arg0_49.timerList = {}
	end
end

function var0_0.DescCDTime(arg0_50, arg1_50)
	local var0_50 = math.floor(arg1_50 / 60)

	arg1_50 = arg1_50 % 60

	return string.format("%02d:%02d", var0_50, arg1_50)
end

function var0_0.willExit(arg0_51)
	arg0_51:RemoveTimer()
	arg0_51:RemoveAllTimers()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_51._tf)
end

function var0_0.ShouldShowTip()
	local var0_52 = getProxy(CityRebuildProxy):GetData(ActivityConst.NINJA_CITY_ACT_ID)

	if not var0_52 then
		return false
	end

	for iter0_52, iter1_52 in pairs(var0_52.recruiting) do
		local var1_52 = pg.activity_ninja_building[iter0_52]

		if pg.TimeMgr.GetInstance():GetServerTime() - iter1_52 >= var1_52.time then
			return true
		end
	end

	return false
end

return var0_0
