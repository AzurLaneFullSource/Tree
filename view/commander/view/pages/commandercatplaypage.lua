local var0 = class("CommanderCatPlayPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommanderCatPlayui"
end

function var0.OnLoaded(arg0)
	arg0.skillTF = arg0:findTF("skill/frame")
	arg0.skillNameTxt = arg0:findTF("name", arg0.skillTF):GetComponent(typeof(Text))
	arg0.skillIcon = arg0:findTF("icon/Image", arg0.skillTF)
	arg0.skillLvTxt = arg0:findTF("level_container/level", arg0.skillTF):GetComponent(typeof(Text))
	arg0.skillAdditionTxt = arg0:findTF("level_container/addition", arg0.skillTF):GetComponent(typeof(Text))
	arg0.expTxt = arg0:findTF("exp/Text", arg0.skillTF):GetComponent(typeof(Text))
	arg0.descBtn = arg0:findTF("skill/frame/desc")
	arg0.descPage = arg0:findTF("skill_desc")
	arg0.descToggle = arg0:findTF("tags", arg0.descPage)
	arg0.descToggleMark = arg0.descToggle:Find("sel")
	arg0.skillDescList = UIItemList.New(arg0:findTF("content/list", arg0.descPage), arg0:findTF("content/list/tpl", arg0.descPage))

	setActive(arg0.descPage, false)

	arg0.commanderLvTxt = arg0:findTF("select_panel/exp_bg/level_bg/Text"):GetComponent(typeof(Text))
	arg0.levelAdditionTxt = arg0:findTF("select_panel/exp_bg/level_bg/addition"):GetComponent(typeof(Text))
	arg0.preExpSlider = arg0:findTF("select_panel/exp_bg/slider"):GetComponent(typeof(Slider))
	arg0.expSlider = arg0:findTF("select_panel/exp_bg/slider/exp"):GetComponent(typeof(Slider))
	arg0.sliderExpTxt = arg0:findTF("select_panel/exp_bg/slider/Text"):GetComponent(typeof(Text))
	arg0.uilist = UIItemList.New(arg0:findTF("select_panel/frame/list"), arg0:findTF("select_panel/frame/list/commandeTF"))
	arg0.consumeTxt = arg0:findTF("select_panel/consume/Text"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("select_panel/confirm_btn")
	arg0.animation = CommanderCatPlayAnimation.New(arg0.expSlider)

	setText(arg0:findTF("select_panel/title"), i18n("commander_confirm_tip"))
	setText(arg0:findTF("skill_desc/title"), i18n("commander_skill_effect"))
end

function var0.OnInit(arg0)
	arg0:RegisterEvent()
	onButton(arg0, arg0.descBtn, function()
		if arg0.isOpenDescPage then
			arg0:CloseDescPage()

			arg0.isOpenDescPage = false
		else
			arg0.isOpenDescPage = true

			arg0:UpdateDescPage()
			arg0:emit(CommanderCatScene.EVENT_CLOSE_DESC)
		end

		setActive(arg0.descBtn:Find("sel"), arg0.isOpenDescPage)
	end, SFX_PANEL)
	setActive(arg0.descBtn:Find("sel"), false)

	arg0.commonFlag = true

	onButton(arg0, arg0.descToggle, function()
		arg0.commonFlag = not arg0.commonFlag

		local var0 = arg0.commonFlag and 0 or arg0.descToggleMark.rect.width

		setAnchoredPosition(arg0.descToggleMark, {
			x = var0
		})
		arg0:UpdateDescPage()
	end, SFX_PANEL)
end

function var0.RegisterEvent(arg0)
	arg0:bind(CommanderCatScene.EVENT_OPEN_DESC, function(arg0)
		if arg0.isOpenDescPage then
			triggerButton(arg0.descBtn)
		end
	end)
	arg0:bind(CommanderCatScene.MSG_UPGRADE, function(arg0, arg1, arg2)
		arg0.preExpSlider.value = 0

		pg.UIMgr.GetInstance():LoadingOn(false)
		arg0.animation:Action(arg1, arg2, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0:Flush(arg2)
			arg0:emit(CommanderCatScene.EVENT_UPGRADE)
		end)
	end)
	arg0:bind(CommanderCatScene.EVENT_FOLD, function(arg0, arg1)
		if arg1 then
			LeanTween.moveX(rtf(arg0._tf), 1000, 0.5)
		else
			LeanTween.moveX(rtf(arg0._tf), -410, 0.5)
		end
	end)
	arg0:bind(CommanderCatScene.EVENT_SWITCH_PAGE, function(arg0, arg1)
		if arg1 == CommanderCatScene.PAGE_DOCK then
			arg0:ClearSortData()
		end
	end)
	arg0:bind(CommanderCatScene.EVENT_SELECTED, function(arg0, arg1)
		arg0:Flush(arg1)
	end)
end

function var0.Flush(arg0, arg1)
	arg0.commander = arg1
	arg0.contextData.materialIds = {}

	arg0:UpdateMaterials()
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.commander = arg1

	arg0:UpdateMaterials()

	if arg0.isOpenDescPage then
		arg0:UpdateDescPage()
	end
end

function var0.UpdateMaterials(arg0)
	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateCard(arg1, arg2)
		end
	end)
	arg0.uilist:align(CommanderConst.PLAY_MAX_COUNT)
	arg0:UpdateMainView()
end

function var0.UpdateMainView(arg0)
	local var0 = arg0.contextData.materialIds or {}
	local var1, var2 = CommanderCatUtil.GetSkillExpAndCommanderExp(arg0.commander, var0)

	arg0:UpdateSkillTF(var2)
	arg0:UpdateCommanderTF(var1)
	arg0:UpdateConsume(var0, var2)
	setActive(go(arg0.skillAdditionTxt), #var0 > 0)
	setActive(go(arg0.levelAdditionTxt), #var0 > 0)
end

function var0.UpdateDescPage(arg0)
	local function var0(arg0, arg1)
		if not arg0 and arg1.desc_world and arg1.desc_world ~= "" then
			return arg1.desc_world
		else
			return arg1.desc
		end
	end

	setActive(arg0.descPage, true)

	local var1 = arg0.commander:getSkills()[1]
	local var2 = var1:GetSkillGroup()
	local var3 = var1:getConfig("lv")

	arg0.skillDescList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var2[arg1 + 1]
			local var1 = var0(arg0.commonFlag, var0)
			local var2 = var3 >= var0.lv and "#66472a" or "#a3a2a2"
			local var3 = var3 < var0.lv and "(Lv." .. var0.lv .. i18n("word_take_effect") .. ")" or ""

			setText(arg2, "<color=" .. var2 .. ">" .. var1 .. "</color>" .. var3)
			setText(arg2:Find("level"), "<color=" .. var2 .. ">" .. "Lv." .. var0.lv .. "</color>")
		end
	end)
	arg0.skillDescList:align(#var2)
end

function var0.CloseDescPage(arg0)
	setActive(arg0.descPage, false)
end

function var0.SimulateAddSkillExp(arg0, arg1)
	local var0 = arg0.commander:getSkills()[1]
	local var1 = Clone(var0)

	var1:addExp(arg1)

	return var1, var0
end

function var0.UpdateSkillTF(arg0, arg1)
	local var0, var1 = arg0:SimulateAddSkillExp(arg1)
	local var2 = var1:getConfig("lv")

	GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. var1:getConfig("icon"), "", arg0.skillIcon)

	arg0.skillNameTxt.text = var1:getConfig("name")
	arg0.skillLvTxt.text = "Lv." .. var1:getLevel()
	arg0.skillAdditionTxt.text = "+" .. var0:getLevel() - var1:getLevel()

	if var1:isMaxLevel() then
		arg0.expTxt.text = "0/0"
	else
		arg0.expTxt.text = var1.exp .. (arg1 == 0 and "" or "<color=#A9F548FF>(+" .. arg1 .. ")</color>") .. "/" .. var1:getNextLevelExp()
	end
end

function var0.SimulateAddCommanderExp(arg0, arg1)
	local var0 = arg0.commander
	local var1 = Clone(var0)

	var1:addExp(arg1)

	return var1, var0
end

function var0.UpdateCommanderTF(arg0, arg1)
	local var0, var1 = arg0:SimulateAddCommanderExp(arg1)

	arg0:emit(CommanderCatScene.EVENT_PREVIEW, var0)

	arg0.commanderLvTxt.text = "LV." .. var1.level

	if var1:isMaxLevel() then
		arg0.expSlider.value = 1
		arg0.sliderExpTxt.text = "EXP: +0/MAX"
		arg0.preExpSlider.value = 1
		arg0.levelAdditionTxt.text = "+0"
	else
		arg0.expSlider.value = arg1 > 0 and 0 or var1.exp / var1:getNextLevelExp()

		local var2 = arg1 > 0 and "<color=#A9F548FF>" .. var1.exp + arg1 .. "</color>" or var1.exp

		arg0.sliderExpTxt.text = "EXP: " .. var2 .. "/" .. var1:getNextLevelExp()

		if var0:isMaxLevel() then
			arg0.preExpSlider.value = 1
		else
			arg0.preExpSlider.value = var0.exp / var0:getNextLevelExp()
		end

		arg0.levelAdditionTxt.text = "+" .. var0.level - var1.level
	end
end

function var0.UpdateConsume(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.total = CommanderCatUtil.CalcCommanderConsume(arg1)
	arg0.consumeTxt.text = var0.gold < arg0.total and "<color=" .. COLOR_RED .. ">" .. arg0.total .. "</color>" or arg0.total

	local function var1()
		if var0.gold < arg0.total then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					arg0.total - var0.gold,
					arg0.total
				}
			})

			return
		end

		local var0 = arg0.commander:getSkills()[1]

		arg0:emit(CommanderCatMediator.UPGRADE, arg0.commander.id, arg1, var0.id)
	end

	onButton(arg0, arg0.confirmBtn, function()
		if not arg1 or #arg1 <= 0 then
			return
		end

		arg0:CheckTip(arg1, arg2, var1)
	end, SFX_PANEL)
end

function var0.CheckTip(arg0, arg1, arg2, arg3)
	local var0 = {}

	if CommanderCatUtil.AnySSRCommander(arg1) then
		table.insert(var0, function(arg0)
			arg0.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_material_is_rarity"),
				onYes = arg0
			})
		end)
	end

	local var1, var2 = arg0:SimulateAddSkillExp(arg2)

	if var1:isMaxLevel() and var1.exp > 0 and not var2:isMaxLevel() then
		table.insert(var0, function(arg0)
			arg0.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_exp_overflow_tip"),
				onYes = arg0
			})
		end)
	end

	if arg0.commander:isMaxLevel() then
		table.insert(var0, function(arg0)
			arg0.contextData.msgBox:ExecuteAction("Show", {
				content = i18n("commander_material_is_maxLevel"),
				onYes = arg0
			})
		end)
	end

	seriesAsync(var0, arg3)
end

function var0.UpdateCard(arg0, arg1, arg2)
	local var0 = arg0.contextData.materialIds or {}
	local var1 = var0[arg1 + 1]
	local var2 = arg2:Find("add")
	local var3 = arg2:Find("icon")

	if var1 then
		onButton(arg0, var3, function()
			local var0 = table.indexof(var0, var1)

			table.remove(var0, var0)
			arg0:UpdateMaterials()
		end, SFX_PANEL)

		local var4 = getProxy(CommanderProxy):getCommanderById(var1)

		GetImageSpriteFromAtlasAsync("commandericon/" .. var4:getPainting(), "", var3)
		setActive(var3:Find("up"), arg0.commander:isSameGroup(var4.groupId))
		setActive(var3:Find("formation"), var4.inFleet)
		setText(var3:Find("level_bg/Text"), var4.level)
	else
		onButton(arg0, var2, function()
			if table.getCount(getProxy(CommanderProxy):getRawData()) == 1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_material_noenough"))

				return
			end

			if not arg0.commander:getSkills()[1]:isMaxLevel() or not arg0.commander:isMaxLevel() then
				arg0:emit(CommanderCatMediator.ON_SELECT, arg0:GenSelectData())
			end
		end, SFX_PANEL)
	end

	setActive(var2, not var1)
	setActive(var3, var1)
end

function var0.GenSelectData(arg0)
	local var0 = arg0.commander

	return {
		activeCommander = var0,
		selectedIds = arg0.contextData.materialIds or {},
		onSelected = function(arg0, arg1)
			arg0.contextData.materialIds = arg0

			arg0:UpdateMaterials()
			arg1()
		end,
		OnSort = function(arg0)
			arg0:SaveSortData(arg0)
		end,
		sortData = arg0:GetSortData()
	}
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	if arg0.animation then
		arg0.animation:Dispose()

		arg0.animation = nil
	end

	arg0:ClearSortData()
end

function var0.GetSortData(arg0)
	if not var0.SortData then
		var0.SortData = Clone(arg0.contextData.sortData) or {
			asc = true,
			sortData = "Rarity",
			nationData = {},
			rarityData = {}
		}
	end

	return var0.SortData
end

function var0.SaveSortData(arg0, arg1)
	var0.SortData = arg1
end

function var0.ClearSortData(arg0)
	var0.SortData = nil
end

return var0
