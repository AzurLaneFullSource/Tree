local var0 = class("GuildTechnologyPage", import("...base.GuildBasePage"))

var0.PAGE_DEV = 1
var0.PAGE_UPGRADE = 2
var0.PAGE_DEV_ITEM = 3

function var0.getTargetUI(arg0)
	return "TechnologyBluePage", "TechnologyRedPage"
end

function var0.OnLoaded(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.toggle = arg0:findTF("frame/toggle")
	arg0.upgradeList = UIItemList.New(arg0:findTF("frame/upgrade/content"), arg0:findTF("frame/upgrade/content/tpl"))
	arg0.breakOutList = UIItemList.New(arg0:findTF("frame/breakout/content"), arg0:findTF("frame/upgrade/content/tpl"))
	arg0.breakoutListPanel = arg0:findTF("frame/breakout")
	arg0.upgradePanel = arg0:findTF("frame/upgrade")
	arg0.inDevelopmentPanel = arg0:findTF("frame/dev")
	arg0.inDevelopmentIcon = arg0:findTF("item/icon", arg0.inDevelopmentPanel):GetComponent(typeof(Image))
	arg0.inDevelopmentName = arg0:findTF("item/name", arg0.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0.inDevelopmentLevel1Txt = arg0:findTF("level1/Text", arg0.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0.inDevelopmentLevel2Txt = arg0:findTF("level2/Text", arg0.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0.inDevelopmentLevel1Desc = arg0:findTF("level1/level/Text", arg0.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0.inDevelopmentLevel2Desc = arg0:findTF("level2/level/Text", arg0.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0.inDevelopmentProgress = arg0:findTF("progress/bar", arg0.inDevelopmentPanel)
	arg0.inDevelopmentProgressTxt = arg0:findTF("progress/Text", arg0.inDevelopmentPanel):GetComponent(typeof(Text))
	arg0.donateBtn = arg0:findTF("skin_btn", arg0.inDevelopmentPanel)
	arg0.cancelBtn = arg0:findTF("cancel_btn", arg0.inDevelopmentPanel)

	setText(arg0:findTF("level1/level/label", arg0.inDevelopmentPanel), i18n("guild_tech_label_max_level"))
	setText(arg0:findTF("level2/level/label", arg0.inDevelopmentPanel), i18n("guild_tech_label_max_level"))
	setText(arg0:findTF("progress/title/Text", arg0.inDevelopmentPanel), i18n("guild_tech_label_dev_progress"))
	setText(arg0:findTF("progress/title/label", arg0.inDevelopmentPanel), i18n("guild_tech_label_condition"))
end

function var0.OnInit(arg0)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.frame, {
		pbList = {
			arg0.frame
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})
	setActive(arg0._tf, true)
	onToggle(arg0, arg0.toggle, function(arg0)
		if arg0 then
			arg0:UpdateBreakOutList()
		else
			arg0:UpdateUpgradeList()
		end

		setActive(arg0.toggle:Find("on"), arg0)
		setActive(arg0.toggle:Find("off"), not arg0)
	end, SFX_PANEL)
	onButton(arg0, arg0.donateBtn, function()
		arg0:emit(GuildTechnologyMediator.ON_OPEN_OFFICE)
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Switch2BreakOutList()
	end, SFX_PANEL)
end

function var0.SetUp(arg0, arg1)
	arg0:Update(arg1)
	triggerToggle(arg0.toggle, false)
end

function var0.Update(arg0, arg1)
	arg0.guildVO = arg1
	arg0.technologyVOs = arg0.guildVO:getTechnologys()
	arg0.technologyGroupVOs = arg0.guildVO:getTechnologyGroups()
	arg0.activityGroup = _.detect(arg0.technologyGroupVOs, function(arg0)
		return arg0:GetState() == GuildTechnologyGroup.STATE_START
	end)
	arg0.isAdmin = GuildMember.IsAdministrator(arg1:getSelfDuty())
end

function var0.Flush(arg0)
	if var0.PAGE_DEV == arg0.page then
		arg0:InitBreakOutList()
	elseif var0.PAGE_UPGRADE == arg0.page then
		arg0:UpdateUpgradeList()
	elseif var0.PAGE_DEV_ITEM == arg0.page then
		arg0:InitDevingItem()
	end
end

function var0.UpdateUpgradeList(arg0)
	table.sort(arg0.technologyVOs, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.upgradeList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.technologyVOs[arg1 + 1]

			GuildTechnologyCard.New(arg2:Find("content"), arg0):Update(var0, arg0.activityGroup)
			setActive(arg2:Find("back"), false)
		end
	end)
	arg0.upgradeList:align(#arg0.technologyVOs)
	setActive(arg0.upgradePanel, true)
	setActive(arg0.inDevelopmentPanel, false)
	setActive(arg0.breakoutListPanel, false)

	arg0.page = var0.PAGE_UPGRADE
end

function var0.UpdateBreakOutList(arg0)
	if arg0.activityGroup then
		arg0:InitDevingItem()
	else
		arg0:InitBreakOutList()
	end

	setActive(arg0.upgradePanel, false)
	setActive(arg0.inDevelopmentPanel, arg0.activityGroup)
	setActive(arg0.breakoutListPanel, not arg0.activityGroup)
end

function var0.Switch2BreakOutList(arg0)
	setActive(arg0.upgradePanel, false)
	setActive(arg0.inDevelopmentPanel, false)
	setActive(arg0.breakoutListPanel, true)
	arg0:InitBreakOutList(true)
end

function var0.InitBreakOutList(arg0, arg1)
	table.sort(arg0.technologyGroupVOs, function(arg0, arg1)
		return arg0.pid < arg1.pid
	end)
	arg0.breakOutList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.technologyGroupVOs[arg1 + 1]
			local var1 = GuildTechnologyGroupCard.New(arg2:Find("content"), arg0)

			var1:Update(var0, arg0.activityGroup, arg0.isAdmin)

			local var2 = arg1 and arg0.activityGroup and arg0.activityGroup.id == var0.id

			setActive(var1._tf, not var2)
			setActive(arg2:Find("back"), var2)

			if var2 then
				onButton(arg0, arg2:Find("back"), function()
					arg0:UpdateBreakOutList()
				end, SFX_PANEL)
				arg2:SetAsFirstSibling()
			end
		end
	end)
	arg0.breakOutList:align(#arg0.technologyGroupVOs)

	arg0.page = var0.PAGE_DEV
end

function var0.InitDevingItem(arg0)
	local var0 = arg0.activityGroup
	local var1 = var0.id

	arg0.inDevelopmentIcon.sprite = GetSpriteFromAtlas("GuildTechnology", var1)
	arg0.inDevelopmentName.text = var0:getConfig("name")

	local var2 = var0:bindConfigTable()
	local var3 = var2[var0.pid].next_tech
	local var4
	local var5
	local var6
	local var7
	local var8
	local var9

	if var3 ~= 0 then
		var4 = var0:GetLevel()

		local var10 = var2[var3]

		var5 = var10.level
		var6 = GuildConst.GET_TECHNOLOGY_DESC(var0:getConfig("effect_args"), var0:getConfig("num"))
		var7 = GuildConst.GET_TECHNOLOGY_DESC(var10.effect_args, var10.num)
		var8 = var0:GetProgress()
		var9 = var0:GetTargetProgress()
	else
		var4 = var0:GetLevel()
		var5 = "MAX"
		var6 = GuildConst.GET_TECHNOLOGY_DESC(var0:getConfig("effect_args"), var0:getConfig("num"))
		var7 = ""
		var8 = 1
		var9 = 1
	end

	arg0.inDevelopmentLevel1Txt.text = var6
	arg0.inDevelopmentLevel1Desc.text = "Lv" .. var4
	arg0.inDevelopmentLevel2Desc.text = "Lv" .. var5
	arg0.inDevelopmentLevel2Txt.text = var7

	setFillAmount(arg0.inDevelopmentProgress, var8 / var9)

	arg0.inDevelopmentProgressTxt.text = var8 .. "/" .. var9
	arg0.page = var0.PAGE_DEV_ITEM
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.frame, arg0._tf)
end

return var0
