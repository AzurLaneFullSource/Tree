local var0_0 = class("CommanderCatPlayPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommanderCatPlayui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.skillTF = arg0_2:findTF("skill/frame")
	arg0_2.skillNameTxt = arg0_2:findTF("name", arg0_2.skillTF):GetComponent(typeof(Text))
	arg0_2.skillIcon = arg0_2:findTF("icon/Image", arg0_2.skillTF)
	arg0_2.skillLvTxt = arg0_2:findTF("level_container/level", arg0_2.skillTF):GetComponent(typeof(Text))
	arg0_2.skillAdditionTxt = arg0_2:findTF("level_container/addition", arg0_2.skillTF):GetComponent(typeof(Text))
	arg0_2.expTxt = arg0_2:findTF("exp/Text", arg0_2.skillTF):GetComponent(typeof(Text))
	arg0_2.descBtn = arg0_2:findTF("skill/frame/desc")
	arg0_2.descPage = arg0_2:findTF("skill_desc")
	arg0_2.descToggle = arg0_2:findTF("tags", arg0_2.descPage)
	arg0_2.descToggleMark = arg0_2.descToggle:Find("sel")
	arg0_2.skillDescList = UIItemList.New(arg0_2:findTF("content/list", arg0_2.descPage), arg0_2:findTF("content/list/tpl", arg0_2.descPage))

	setActive(arg0_2.descPage, false)

	arg0_2.commanderLvTxt = arg0_2:findTF("select_panel/exp_bg/level_bg/Text"):GetComponent(typeof(Text))
	arg0_2.levelAdditionTxt = arg0_2:findTF("select_panel/exp_bg/level_bg/addition"):GetComponent(typeof(Text))
	arg0_2.preExpSlider = arg0_2:findTF("select_panel/exp_bg/slider"):GetComponent(typeof(Slider))
	arg0_2.expSlider = arg0_2:findTF("select_panel/exp_bg/slider/exp"):GetComponent(typeof(Slider))
	arg0_2.sliderExpTxt = arg0_2:findTF("select_panel/exp_bg/slider/Text"):GetComponent(typeof(Text))
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("select_panel/frame/list"), arg0_2:findTF("select_panel/frame/list/commandeTF"))
	arg0_2.consumeTxt = arg0_2:findTF("select_panel/consume/Text"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("select_panel/confirm_btn")
	arg0_2.animation = CommanderCatPlayAnimation.New(arg0_2.expSlider)

	setText(arg0_2:findTF("select_panel/title"), i18n("commander_confirm_tip"))
	setText(arg0_2:findTF("skill_desc/title"), i18n("commander_skill_effect"))
end

function var0_0.OnInit(arg0_3)
	arg0_3:RegisterEvent()
	onButton(arg0_3, arg0_3.descBtn, function()
		if arg0_3.isOpenDescPage then
			arg0_3:CloseDescPage()

			arg0_3.isOpenDescPage = false
		else
			arg0_3.isOpenDescPage = true

			arg0_3:UpdateDescPage()
			arg0_3:emit(CommanderCatScene.EVENT_CLOSE_DESC)
		end

		setActive(arg0_3.descBtn:Find("sel"), arg0_3.isOpenDescPage)
	end, SFX_PANEL)
	setActive(arg0_3.descBtn:Find("sel"), false)

	arg0_3.commonFlag = true

	onButton(arg0_3, arg0_3.descToggle, function()
		arg0_3.commonFlag = not arg0_3.commonFlag

		local var0_5 = arg0_3.commonFlag and 0 or arg0_3.descToggleMark.rect.width

		setAnchoredPosition(arg0_3.descToggleMark, {
			x = var0_5
		})
		arg0_3:UpdateDescPage()
	end, SFX_PANEL)
end

function var0_0.RegisterEvent(arg0_6)
	arg0_6:bind(CommanderCatScene.EVENT_OPEN_DESC, function(arg0_7)
		if arg0_6.isOpenDescPage then
			triggerButton(arg0_6.descBtn)
		end
	end)
	arg0_6:bind(CommanderCatScene.MSG_UPGRADE, function(arg0_8, arg1_8, arg2_8)
		arg0_6.preExpSlider.value = 0

		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0_6.animation:Action(arg1_8, arg2_8, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_6:Flush(arg2_8)
			arg0_6:emit(CommanderCatScene.EVENT_UPGRADE)
		end)
	end)
	arg0_6:bind(CommanderCatScene.EVENT_FOLD, function(arg0_10, arg1_10)
		if arg1_10 then
			LeanTween.moveX(rtf(arg0_6._tf), 1000, 0.5)
		else
			LeanTween.moveX(rtf(arg0_6._tf), -410, 0.5)
		end
	end)
	arg0_6:bind(CommanderCatScene.EVENT_SWITCH_PAGE, function(arg0_11, arg1_11)
		if arg1_11 == CommanderCatScene.PAGE_DOCK then
			arg0_6:ClearSortData()
		end
	end)
	arg0_6:bind(CommanderCatScene.EVENT_SELECTED, function(arg0_12, arg1_12)
		arg0_6:Flush(arg1_12)
	end)
end

function var0_0.Flush(arg0_13, arg1_13)
	arg0_13.commander = arg1_13
	arg0_13.contextData.materialIds = {}

	arg0_13:UpdateMaterials()
end

function var0_0.Show(arg0_14, arg1_14)
	var0_0.super.Show(arg0_14)

	arg0_14.commander = arg1_14

	arg0_14:UpdateMaterials()

	if arg0_14.isOpenDescPage then
		arg0_14:UpdateDescPage()
	end
end

function var0_0.UpdateMaterials(arg0_15)
	arg0_15.uilist:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg0_15:UpdateCard(arg1_16, arg2_16)
		end
	end)
	arg0_15.uilist:align(CommanderConst.PLAY_MAX_COUNT)
	arg0_15:UpdateMainView()
end

function var0_0.UpdateMainView(arg0_17)
	local var0_17 = arg0_17.contextData.materialIds or {}
	local var1_17, var2_17 = CommanderCatUtil.GetSkillExpAndCommanderExp(arg0_17.commander, var0_17)

	arg0_17:UpdateSkillTF(var2_17)
	arg0_17:UpdateCommanderTF(var1_17)
	arg0_17:UpdateConsume(var0_17, var2_17)
	setActive(go(arg0_17.skillAdditionTxt), #var0_17 > 0)
	setActive(go(arg0_17.levelAdditionTxt), #var0_17 > 0)
end

function var0_0.UpdateDescPage(arg0_18)
	local function var0_18(arg0_19, arg1_19)
		if not arg0_19 and arg1_19.desc_world and arg1_19.desc_world ~= "" then
			return arg1_19.desc_world
		else
			return arg1_19.desc
		end
	end

	setActive(arg0_18.descPage, true)

	local var1_18 = arg0_18.commander:getSkills()[1]
	local var2_18 = var1_18:GetSkillGroup()
	local var3_18 = var1_18:getConfig("lv")

	arg0_18.skillDescList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = var2_18[arg1_20 + 1]
			local var1_20 = var0_18(arg0_18.commonFlag, var0_20)
			local var2_20 = var3_18 >= var0_20.lv and "#66472a" or "#a3a2a2"
			local var3_20 = var3_18 < var0_20.lv and "(Lv." .. var0_20.lv .. i18n("word_take_effect") .. ")" or ""

			setText(arg2_20, "<color=" .. var2_20 .. ">" .. var1_20 .. "</color>" .. var3_20)
			setText(arg2_20:Find("level"), "<color=" .. var2_20 .. ">" .. "Lv." .. var0_20.lv .. "</color>")
		end
	end)
	arg0_18.skillDescList:align(#var2_18)
end

function var0_0.CloseDescPage(arg0_21)
	setActive(arg0_21.descPage, false)
end

function var0_0.SimulateAddSkillExp(arg0_22, arg1_22)
	local var0_22 = arg0_22.commander:getSkills()[1]
	local var1_22 = Clone(var0_22)

	var1_22:addExp(arg1_22)

	return var1_22, var0_22
end

function var0_0.UpdateSkillTF(arg0_23, arg1_23)
	local var0_23, var1_23 = arg0_23:SimulateAddSkillExp(arg1_23)
	local var2_23 = var1_23:getConfig("lv")

	GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var1_23:getConfig("icon"), "", arg0_23.skillIcon)

	arg0_23.skillNameTxt.text = var1_23:getConfig("name")
	arg0_23.skillLvTxt.text = "Lv." .. var1_23:getLevel()
	arg0_23.skillAdditionTxt.text = "+" .. var0_23:getLevel() - var1_23:getLevel()

	if var1_23:isMaxLevel() then
		arg0_23.expTxt.text = "0/0"
	else
		arg0_23.expTxt.text = var1_23.exp .. (arg1_23 == 0 and "" or "<color=#A9F548FF>(+" .. arg1_23 .. ")</color>") .. "/" .. var1_23:getNextLevelExp()
	end
end

function var0_0.SimulateAddCommanderExp(arg0_24, arg1_24)
	local var0_24 = arg0_24.commander
	local var1_24 = Clone(var0_24)

	var1_24:addExp(arg1_24)

	return var1_24, var0_24
end

function var0_0.UpdateCommanderTF(arg0_25, arg1_25)
	local var0_25, var1_25 = arg0_25:SimulateAddCommanderExp(arg1_25)

	arg0_25:emit(CommanderCatScene.EVENT_PREVIEW, var0_25)

	arg0_25.commanderLvTxt.text = "LV." .. var1_25.level

	if var1_25:isMaxLevel() then
		arg0_25.expSlider.value = 1
		arg0_25.sliderExpTxt.text = "EXP: +0/MAX"
		arg0_25.preExpSlider.value = 1
		arg0_25.levelAdditionTxt.text = "+0"
	else
		arg0_25.expSlider.value = arg1_25 > 0 and 0 or var1_25.exp / var1_25:getNextLevelExp()

		local var2_25 = arg1_25 > 0 and "<color=#A9F548FF>" .. var1_25.exp + arg1_25 .. "</color>" or var1_25.exp

		arg0_25.sliderExpTxt.text = "EXP: " .. var2_25 .. "/" .. var1_25:getNextLevelExp()

		if var0_25:isMaxLevel() then
			arg0_25.preExpSlider.value = 1
		else
			arg0_25.preExpSlider.value = var0_25.exp / var0_25:getNextLevelExp()
		end

		arg0_25.levelAdditionTxt.text = "+" .. var0_25.level - var1_25.level
	end
end

function var0_0.UpdateConsume(arg0_26, arg1_26, arg2_26)
	local var0_26 = getProxy(PlayerProxy):getRawData()

	arg0_26.total = CommanderCatUtil.CalcCommanderConsume(arg1_26)
	arg0_26.consumeTxt.text = var0_26.gold < arg0_26.total and "<color=" .. COLOR_RED .. ">" .. arg0_26.total .. "</color>" or arg0_26.total

	local function var1_26()
		if var0_26.gold < arg0_26.total then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					arg0_26.total - var0_26.gold,
					arg0_26.total
				}
			})

			return
		end

		local var0_27 = arg0_26.commander:getSkills()[1]

		arg0_26:emit(CommanderCatMediator.UPGRADE, arg0_26.commander.id, arg1_26, var0_27.id)
	end

	onButton(arg0_26, arg0_26.confirmBtn, function()
		if not arg1_26 or #arg1_26 <= 0 then
			return
		end

		arg0_26:CheckTip(arg1_26, arg2_26, var1_26)
	end, SFX_PANEL)
end

function var0_0.CheckTip(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = {}

	if CommanderCatUtil.AnySSRCommander(arg1_29) then
		table.insert(var0_29, function(arg0_30)
			arg0_29.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_material_is_rarity"),
				onYes = arg0_30
			})
		end)
	end

	local var1_29, var2_29 = arg0_29:SimulateAddSkillExp(arg2_29)

	if var1_29:isMaxLevel() and var1_29.exp > 0 and not var2_29:isMaxLevel() then
		table.insert(var0_29, function(arg0_31)
			arg0_29.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_exp_overflow_tip"),
				onYes = arg0_31
			})
		end)
	end

	if arg0_29.commander:isMaxLevel() then
		table.insert(var0_29, function(arg0_32)
			arg0_29.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_material_is_maxLevel"),
				onYes = arg0_32
			})
		end)
	end

	seriesAsync(var0_29, arg3_29)
end

function var0_0.UpdateCard(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.contextData.materialIds or {}
	local var1_33 = var0_33[arg1_33 + 1]
	local var2_33 = arg2_33:Find("add")
	local var3_33 = arg2_33:Find("icon")

	if var1_33 then
		onButton(arg0_33, var3_33, function()
			local var0_34 = table.indexof(var0_33, var1_33)

			table.remove(var0_33, var0_34)
			arg0_33:UpdateMaterials()
		end, SFX_PANEL)

		local var4_33 = getProxy(CommanderProxy):getCommanderById(var1_33)

		GetImageSpriteFromAtlasAsync("commandericon/" .. var4_33:getPainting(), "", var3_33)
		setActive(var3_33:Find("up"), arg0_33.commander:isSameGroup(var4_33.groupId))
		setActive(var3_33:Find("formation"), var4_33.inFleet)
		setText(var3_33:Find("level_bg/Text"), var4_33.level)
	else
		onButton(arg0_33, var2_33, function()
			if table.getCount(getProxy(CommanderProxy):getRawData()) == 1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_material_noenough"))

				return
			end

			if not arg0_33.commander:getSkills()[1]:isMaxLevel() or not arg0_33.commander:isMaxLevel() then
				arg0_33:emit(CommanderCatMediator.ON_SELECT, arg0_33:GenSelectData())
			end
		end, SFX_PANEL)
	end

	setActive(var2_33, not var1_33)
	setActive(var3_33, var1_33)
end

function var0_0.GenSelectData(arg0_36)
	local var0_36 = arg0_36.commander

	return {
		activeCommander = var0_36,
		selectedIds = arg0_36.contextData.materialIds or {},
		onSelected = function(arg0_37, arg1_37)
			arg0_36.contextData.materialIds = arg0_37

			arg0_36:UpdateMaterials()
			arg1_37()
		end,
		OnSort = function(arg0_38)
			arg0_36:SaveSortData(arg0_38)
		end,
		sortData = arg0_36:GetSortData()
	}
end

function var0_0.Hide(arg0_39)
	var0_0.super.Hide(arg0_39)
end

function var0_0.OnDestroy(arg0_40)
	if arg0_40.animation then
		arg0_40.animation:Dispose()

		arg0_40.animation = nil
	end

	arg0_40:ClearSortData()
end

function var0_0.GetSortData(arg0_41)
	if not var0_0.SortData then
		var0_0.SortData = Clone(arg0_41.contextData.sortData) or {
			asc = true,
			sortData = "Rarity",
			nationData = {},
			rarityData = {}
		}
	end

	return var0_0.SortData
end

function var0_0.SaveSortData(arg0_42, arg1_42)
	var0_0.SortData = arg1_42
end

function var0_0.ClearSortData(arg0_43)
	var0_0.SortData = nil
end

return var0_0
