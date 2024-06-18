local var0_0 = class("GuildTechnologyPage", import("...base.GuildBasePage"))

var0_0.PAGE_DEV = 1
var0_0.PAGE_UPGRADE = 2
var0_0.PAGE_DEV_ITEM = 3

function var0_0.getTargetUI(arg0_1)
	return "TechnologyBluePage", "TechnologyRedPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.toggle = arg0_2:findTF("frame/toggle")
	arg0_2.upgradeList = UIItemList.New(arg0_2:findTF("frame/upgrade/content"), arg0_2:findTF("frame/upgrade/content/tpl"))
	arg0_2.breakOutList = UIItemList.New(arg0_2:findTF("frame/breakout/content"), arg0_2:findTF("frame/upgrade/content/tpl"))
	arg0_2.breakoutListPanel = arg0_2:findTF("frame/breakout")
	arg0_2.upgradePanel = arg0_2:findTF("frame/upgrade")
	arg0_2.inDevelopmentPanel = arg0_2:findTF("frame/dev")
	arg0_2.inDevelopmentIcon = arg0_2:findTF("item/icon", arg0_2.inDevelopmentPanel):GetComponent(typeof(Image))
	arg0_2.inDevelopmentName = arg0_2:findTF("item/name", arg0_2.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0_2.inDevelopmentLevel1Txt = arg0_2:findTF("level1/Text", arg0_2.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0_2.inDevelopmentLevel2Txt = arg0_2:findTF("level2/Text", arg0_2.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0_2.inDevelopmentLevel1Desc = arg0_2:findTF("level1/level/Text", arg0_2.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0_2.inDevelopmentLevel2Desc = arg0_2:findTF("level2/level/Text", arg0_2.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0_2.inDevelopmentProgress = arg0_2:findTF("progress/bar", arg0_2.inDevelopmentPanel)
	arg0_2.inDevelopmentProgressTxt = arg0_2:findTF("progress/Text", arg0_2.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0_2.donateBtn = arg0_2:findTF("skin_btn", arg0_2.inDevelopmentPanel)
	arg0_2.cancelBtn = arg0_2:findTF("cancel_btn", arg0_2.inDevelopmentPanel)

	setText(arg0_2:findTF("level1/level/label", arg0_2.inDevelopmentPanel), i18n("guild_tech_label_max_level"))
	setText(arg0_2:findTF("level2/level/label", arg0_2.inDevelopmentPanel), i18n("guild_tech_label_max_level"))
	setText(arg0_2:findTF("progress/title/Text", arg0_2.inDevelopmentPanel), i18n("guild_tech_label_dev_progress"))
	setText(arg0_2:findTF("progress/title/label", arg0_2.inDevelopmentPanel), i18n("guild_tech_label_condition"))
end

function var0_0.OnInit(arg0_3)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_3.frame, {
		pbList = {
			arg0_3.frame
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})
	setActive(arg0_3._tf, true)
	onToggle(arg0_3, arg0_3.toggle, function(arg0_4)
		if arg0_4 then
			arg0_3:UpdateBreakOutList()
		else
			arg0_3:UpdateUpgradeList()
		end

		setActive(arg0_3.toggle:Find("on"), arg0_4)
		setActive(arg0_3.toggle:Find("off"), not arg0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.donateBtn, function()
		arg0_3:emit(GuildTechnologyMediator.ON_OPEN_OFFICE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Switch2BreakOutList()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_7, arg1_7)
	arg0_7:Update(arg1_7)
	triggerToggle(arg0_7.toggle, false)
end

function var0_0.Update(arg0_8, arg1_8)
	arg0_8.guildVO = arg1_8
	arg0_8.technologyVOs = arg0_8.guildVO:getTechnologys()
	arg0_8.technologyGroupVOs = arg0_8.guildVO:getTechnologyGroups()
	arg0_8.activityGroup = _.detect(arg0_8.technologyGroupVOs, function(arg0_9)
		return arg0_9:GetState() == GuildTechnologyGroup.STATE_START
	end)
	arg0_8.isAdmin = GuildMember.IsAdministrator(arg1_8:getSelfDuty())
end

function var0_0.Flush(arg0_10)
	if var0_0.PAGE_DEV == arg0_10.page then
		arg0_10:InitBreakOutList()
	elseif var0_0.PAGE_UPGRADE == arg0_10.page then
		arg0_10:UpdateUpgradeList()
	elseif var0_0.PAGE_DEV_ITEM == arg0_10.page then
		arg0_10:InitDevingItem()
	end
end

function var0_0.UpdateUpgradeList(arg0_11)
	table.sort(arg0_11.technologyVOs, function(arg0_12, arg1_12)
		return arg0_12.id < arg1_12.id
	end)
	arg0_11.upgradeList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = arg0_11.technologyVOs[arg1_13 + 1]

			GuildTechnologyCard.New(arg2_13:Find("content"), arg0_11):Update(var0_13, arg0_11.activityGroup)
			setActive(arg2_13:Find("back"), false)
		end
	end)
	arg0_11.upgradeList:align(#arg0_11.technologyVOs)
	setActive(arg0_11.upgradePanel, true)
	setActive(arg0_11.inDevelopmentPanel, false)
	setActive(arg0_11.breakoutListPanel, false)

	arg0_11.page = var0_0.PAGE_UPGRADE
end

function var0_0.UpdateBreakOutList(arg0_14)
	if arg0_14.activityGroup then
		arg0_14:InitDevingItem()
	else
		arg0_14:InitBreakOutList()
	end

	setActive(arg0_14.upgradePanel, false)
	setActive(arg0_14.inDevelopmentPanel, arg0_14.activityGroup)
	setActive(arg0_14.breakoutListPanel, not arg0_14.activityGroup)
end

function var0_0.Switch2BreakOutList(arg0_15)
	setActive(arg0_15.upgradePanel, false)
	setActive(arg0_15.inDevelopmentPanel, false)
	setActive(arg0_15.breakoutListPanel, true)
	arg0_15:InitBreakOutList(true)
end

function var0_0.InitBreakOutList(arg0_16, arg1_16)
	table.sort(arg0_16.technologyGroupVOs, function(arg0_17, arg1_17)
		return arg0_17.pid < arg1_17.pid
	end)
	arg0_16.breakOutList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg0_16.technologyGroupVOs[arg1_18 + 1]
			local var1_18 = GuildTechnologyGroupCard.New(arg2_18:Find("content"), arg0_16)

			var1_18:Update(var0_18, arg0_16.activityGroup, arg0_16.isAdmin)

			local var2_18 = arg1_16 and arg0_16.activityGroup and arg0_16.activityGroup.id == var0_18.id

			setActive(var1_18._tf, not var2_18)
			setActive(arg2_18:Find("back"), var2_18)

			if var2_18 then
				onButton(arg0_16, arg2_18:Find("back"), function()
					arg0_16:UpdateBreakOutList()
				end, SFX_PANEL)
				arg2_18:SetAsFirstSibling()
			end
		end
	end)
	arg0_16.breakOutList:align(#arg0_16.technologyGroupVOs)

	arg0_16.page = var0_0.PAGE_DEV
end

function var0_0.InitDevingItem(arg0_20)
	local var0_20 = arg0_20.activityGroup
	local var1_20 = var0_20.id

	arg0_20.inDevelopmentIcon.sprite = GetSpriteFromAtlas("GuildTechnology", var1_20)
	arg0_20.inDevelopmentName.text = var0_20:getConfig("name")

	local var2_20 = var0_20:bindConfigTable()
	local var3_20 = var2_20[var0_20.pid].next_tech
	local var4_20
	local var5_20
	local var6_20
	local var7_20
	local var8_20
	local var9_20

	if var3_20 ~= 0 then
		var4_20 = var0_20:GetLevel()

		local var10_20 = var2_20[var3_20]

		var5_20 = var10_20.level
		var6_20 = GuildConst.GET_TECHNOLOGY_DESC(var0_20:getConfig("effect_args"), var0_20:getConfig("num"))
		var7_20 = GuildConst.GET_TECHNOLOGY_DESC(var10_20.effect_args, var10_20.num)
		var8_20 = var0_20:GetProgress()
		var9_20 = var0_20:GetTargetProgress()
	else
		var4_20 = var0_20:GetLevel()
		var5_20 = "MAX"
		var6_20 = GuildConst.GET_TECHNOLOGY_DESC(var0_20:getConfig("effect_args"), var0_20:getConfig("num"))
		var7_20 = ""
		var8_20 = 1
		var9_20 = 1
	end

	arg0_20.inDevelopmentLevel1Txt.text = var6_20
	arg0_20.inDevelopmentLevel1Desc.text = "Lv" .. var4_20
	arg0_20.inDevelopmentLevel2Desc.text = "Lv" .. var5_20
	arg0_20.inDevelopmentLevel2Txt.text = var7_20

	setFillAmount(arg0_20.inDevelopmentProgress, var8_20 / var9_20)

	arg0_20.inDevelopmentProgressTxt.text = var8_20 .. "/" .. var9_20
	arg0_20.page = var0_0.PAGE_DEV_ITEM
end

function var0_0.OnDestroy(arg0_21)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_21.frame, arg0_21._tf)
end

return var0_0
