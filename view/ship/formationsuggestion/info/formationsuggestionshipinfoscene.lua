local var0_0 = class("FormationSuggestionShipInfoScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "FormationSuggestionShipInfoUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiTitleText, i18n("formation_suggestion_info_title"))
	setText(arg0_2.uiLockText, i18n("formation_suggestion_info_not_get"))
	setText(arg0_2.uiUnLockText, i18n("formation_suggestion_info_got"))
	setText(arg0_2.uiGoDockText, i18n("formation_suggestion_info_go_dock"))
	setText(arg0_2.uiEquipTitleText1, i18n("formation_suggestion_info_equip_recommend"))
	setText(arg0_2.uiEquipTitleText2, i18n("formation_suggestion_info_equip_transitional"))
	setText(arg0_2.uiEquipTipText, i18n("formation_suggestion_info_equip_tip"))
	setText(arg0_2.uiBackText, i18n("formation_suggestion_info_back"))

	arg0_2.shipView = FormationSuggestionShipItem.New(tf(arg0_2.uiShipItem), arg0_2)
	arg0_2.equipView1 = FormationSuggestionShipEquipPanel.New(tf(arg0_2.uiEquipPanel1), arg0_2)
	arg0_2.equipView2 = FormationSuggestionShipEquipPanel.New(tf(arg0_2.uiEquipPanel2), arg0_2, true)

	onButton(arg0_2, arg0_2.uiGoDockBtn, function()
		arg0_2:emit(BaseUI.ON_GO_SCENE, SCENE.DOCKYARD, {
			mode = DockyardScene.MODE_OVERVIEW
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)

	arg0_2.skillList = UIItemList.New(arg0_2.uiSkillParent, arg0_2.uiSkillItem)
	arg0_2.obtainList = UIItemList.New(arg0_2.uiObtainParent, arg0_2.uiObtainItem)
end

function var0_0.didEnter(arg0_5)
	arg0_5:OverlayPanel(arg0_5._tf, {
		pbList = {
			arg0_5.uiBlurTf
		}
	})

	arg0_5.id = arg0_5.contextData.id

	local var0_5 = pg.chapter_suggestion_char[arg0_5.id]

	arg0_5.shipView:SetData(arg0_5.id)
	arg0_5.equipView1:SetData(var0_5.wepaon)
	arg0_5.equipView2:SetData(var0_5.wepaon_2)

	local var1_5 = Ship.New({
		id = arg0_5.id,
		configId = var0_5.char_id,
		level = var0_5.char_lv
	})

	setText(arg0_5.uiNameText, var1_5:GetColorName())

	local var2_5 = pg.ship_data_template[var0_5.char_id].group_type
	local var3_5 = getProxy(BayProxy):findShipsByGroup(var2_5)

	for iter0_5 = #var3_5, 1, -1 do
		if var0_5.remoulded == 1 and not var3_5[iter0_5]:isRemoulded() then
			table.remove(var3_5, iter0_5)
		end
	end

	local var4_5 = #var3_5 > 0

	setActive(arg0_5.uiUnLockGo, var4_5)
	setActive(arg0_5.uiLockGo, not var4_5)
	setActive(arg0_5.uiLvGo, var4_5)

	local var5_5 = 1

	for iter1_5, iter2_5 in ipairs(var3_5) do
		var5_5 = var5_5 < iter2_5.level and iter2_5.level or var5_5
	end

	setText(arg0_5.uiLevelText, i18n("formation_suggestion_info_level", var5_5))
	arg0_5.skillList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5.skill_lv[arg1_6 + 1]
			local var1_6 = var0_6[1]
			local var2_6 = findTF(arg2_6, "level")

			if var4_5 then
				local var3_6 = var1_5:isBluePrintShip() and getProxy(TechnologyProxy):getBluePrintVOByGroupID(var2_5)
				local var4_6 = 1

				if var3_6 then
					for iter0_6, iter1_6 in ipairs(var3_5) do
						local var5_6 = iter1_6:fateSkillChange(var1_6)

						if var5_6 ~= var1_6 then
							var1_6 = var5_6

							break
						end
					end
				end

				for iter2_6, iter3_6 in ipairs(var3_5) do
					if var0_5.remoulded == 0 then
						local var6_6 = table.keyof(pg.ship_data_template[var1_5.configId].buff_list_display, var1_6)
						local var7_6 = pg.ship_data_template[iter3_6.configId].buff_list_display[var6_6]

						if iter3_6.skills[var7_6] then
							local var8_6 = iter3_6.skills[var7_6].level

							var4_6 = var4_6 < var8_6 and var8_6 or var4_6
						end
					end

					if iter3_6.skills[var1_6] then
						local var9_6 = iter3_6.skills[var1_6].level

						var4_6 = var4_6 < var9_6 and var9_6 or var4_6
					end
				end

				if var4_6 >= var0_6[2] then
					setText(var2_6, i18n("formation_suggestion_info_level_recommend", string.format("<color=#ffffff>Lv.%s</color>/%s", var4_6, var0_6[2])))
				else
					setText(var2_6, i18n("formation_suggestion_info_level_recommend", string.format("<color=#d53333>Lv.%s</color>/%s", var4_6, var0_6[2])))
				end
			else
				setText(var2_6, i18n("formation_suggestion_info_level_recommend", string.format("Lv.%s", var0_6[2])))
			end

			local var10_6 = getSkillConfig(var1_6)

			LoadImageSpriteAsync("skillicon/" .. var10_6.icon, findTF(arg2_6, "icon"))
			setScrollText(findTF(arg2_6, "mask/name"), getSkillName(var10_6.id))
		end
	end)
	arg0_5.skillList:align(#var0_5.skill_lv)
	arg0_5.obtainList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var0_5.source[arg1_7 + 1]

			setScrollText(findTF(arg2_7, "text/text"), i18n("formation_suggestion_info_obtain", var0_7[2]))
			onButton(arg0_5, findTF(arg2_7, "goBtn"), function()
				arg0_5:emit(FormationSuggestionShipInfoMediator.JUMP_TO_SCENE, var0_7[1])
			end)
		end
	end)
	arg0_5.obtainList:align(#var0_5.source)
end

function var0_0.willExit(arg0_9)
	arg0_9:UnOverlayPanel(arg0_9._tf)
	arg0_9.shipView:willExit()

	arg0_9.shipView = nil

	arg0_9.skillList:Dispose()

	arg0_9.skillList = nil

	arg0_9.obtainList:Dispose()

	arg0_9.obtainList = nil

	arg0_9.equipView1:willExit()

	arg0_9.equipView1 = nil

	arg0_9.equipView2:willExit()

	arg0_9.equipView2 = nil

	pg.m02:sendNotification(GAME.FORMATION_SUGGESTION_EXIT_SHIP_INFO)
end

return var0_0
