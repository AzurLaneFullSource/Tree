local var0 = class("TerminalGuardianPage", import("view.base.BaseSubView"))

var0.BIND_LOTTERY_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID
var0.config = pg.guardian_template
var0.GUARDIAN_SELECT_CNT = 4

function var0.getUIName(arg0)
	return "TerminalGuardianPage"
end

function var0.OnLoaded(arg0)
	arg0._tf.name = tostring(OtherworldTerminalLayer.PAGE_GUARDIAN)
	arg0.mainViewTF = arg0:findTF("frame/view")
	arg0.mainViewUIList = UIItemList.New(arg0:findTF("content", arg0.mainViewTF), arg0:findTF("content/tpl", arg0.mainViewTF))
	arg0.selectViewTF = arg0:findTF("frame/select_view")
	arg0.selectBackBtn = arg0:findTF("top/back_btn", arg0.selectViewTF)

	setText(arg0:findTF("top/Text", arg0.selectViewTF), i18n("guardian_select_title"))

	arg0.selectMainTF = arg0:findTF("left", arg0.selectViewTF)
	arg0.selectdIcon = arg0:findTF("icon_bg/Image", arg0.selectMainTF)
	arg0.selectdUnknown = arg0:findTF("icon_bg/unknown", arg0.selectMainTF)
	arg0.selectdName = arg0:findTF("name", arg0.selectMainTF)
	arg0.selectdDesc = arg0:findTF("desc/content/Text", arg0.selectMainTF)
	arg0.selectdSureBtn = arg0:findTF("sure_btn", arg0.selectMainTF)

	setText(arg0:findTF("Text", arg0.selectdSureBtn), i18n("guardian_sure_btn"))

	arg0.selectdCancelBtn = arg0:findTF("cancel_btn", arg0.selectMainTF)

	setText(arg0:findTF("Text", arg0.selectdCancelBtn), i18n("guardian_cancel_btn"))

	arg0.selectdCondition = arg0:findTF("condition", arg0.selectMainTF)
	arg0.selectViewUIList = UIItemList.New(arg0:findTF("right/content", arg0.selectViewTF), arg0:findTF("right/content/tpl", arg0.selectViewTF))

	setText(arg0:findTF("right/content/tpl/active/Text", arg0.selectViewTF), i18n("guardian_active_tip"))
end

function var0.OnInit(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityById(var0.BIND_LOTTERY_ACT_ID)

	assert(arg0.activity, "not exist bind lottery act, id" .. var0.BIND_LOTTERY_ACT_ID)
	onButton(arg0, arg0.selectBackBtn, function()
		arg0:CloseSelectView()
	end, SFX_PANEL)
	onButton(arg0, arg0.selectdSureBtn, function()
		if #arg0.activeIds >= var0.GUARDIAN_SELECT_CNT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guardian_sure_limit_tip"))

			return
		end

		table.insert(arg0.activeIds, arg0.selectedId)
		arg0:ChangeActiveIds()
	end, SFX_PANEL)
	onButton(arg0, arg0.selectdCancelBtn, function()
		table.removebyvalue(arg0.activeIds, arg0.selectedId)
		arg0:ChangeActiveIds()
	end, SFX_PANEL)
	arg0:InitMainViewUI()
	arg0:InitSelectViewUI()
	arg0:UpdateView()
	arg0:CloseSelectView()
end

function var0.ChangeActiveIds(arg0)
	arg0:emit(OtherworldTerminalMediator.ON_BUFF_LIST_CHANGE, {
		actId = var0.BIND_LOTTERY_ACT_ID,
		ids = arg0.activeIds
	})
end

function var0.InitMainViewUI(arg0)
	arg0.mainViewUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.activeIds[arg1 + 1]
			local var1 = var0 ~= nil

			setActive(arg0:findTF("content", arg2), var1)
			setActive(arg0:findTF("empty", arg2), not var1)

			if var1 then
				local var2 = var0.config[var0]

				setText(arg0:findTF("content/name", arg2), var2.guardian_name)
				setText(arg0:findTF("content/desc/content/Text", arg2), var2.guardian_desc)

				local var3 = arg0:findTF("content/icon_mask/Image", arg2)

				GetImageSpriteFromAtlasAsync("shipyardicon/" .. var2.guardian_painting, "", var3, false)
			end

			onButton(arg0, arg2, function()
				arg0.selectedId = var0 or underscore.detect(arg0.allIds, function(arg0)
					return not table.contains(arg0.activeIds, arg0)
				end)

				arg0:OpenSelectView()
			end, SFX_PANEL)
		end
	end)
end

function var0.UpdateMainView(arg0)
	arg0.mainViewUIList:align(var0.GUARDIAN_SELECT_CNT)
end

function var0.InitSelectViewUI(arg0)
	arg0.selectViewUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg0.allIds[arg1 + 1]
			local var1 = var0.config[var0]
			local var2 = arg0:findTF("icon_mask/Image", arg2)

			GetImageSpriteFromAtlasAsync("shipyardicon/" .. var1.guardian_painting, "", var2, true)
			onButton(arg0, arg2, function()
				arg0.selectedId = var0

				arg0:UpdateSelectViewUI()
			end, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			local var3 = arg0.allIds[arg1 + 1]
			local var4 = var0.config[var3]
			local var5 = table.contains(arg0.unlcokIds, var3)
			local var6 = table.contains(arg0.activeIds, var3)
			local var7 = var4.type == 2 and not var5

			setActive(arg0:findTF("icon_mask/Image", arg2), not var7)
			setActive(arg0:findTF("unknown", arg2), var7)
			setActive(arg0:findTF("lock", arg2), not var5 and not var7)
			setActive(arg0:findTF("active", arg2), var6)
			setActive(arg0:findTF("selected", arg2), var3 == arg0.selectedId)
		end
	end)
end

function var0.UpdateSelectViewUI(arg0)
	local var0 = arg0.selectedId or arg0.allIds[1]
	local var1 = var0.config[var0]
	local var2 = table.contains(arg0.unlcokIds, var0)
	local var3 = table.contains(arg0.activeIds, var0)
	local var4 = var1.type == 2 and not var2

	GetImageSpriteFromAtlasAsync("shipyardicon/" .. var1.guardian_painting, "", arg0.selectdIcon, true)
	setActive(arg0.selectdIcon, not var4)
	setActive(arg0.selectdUnknown, var4)
	setText(arg0.selectdName, var4 and "???" or var1.guardian_name)
	setText(arg0.selectdDesc, var4 and "???" or var1.guardian_desc)

	local var5 = ""

	if var1.type == 1 then
		local var6, var7 = ActivityItemPool.GetGuardianLastCount(var0.BIND_LOTTERY_ACT_ID, var0)
		local var8 = var1.guardian_gain[2] - var7

		var5 = string.gsub(var1.guardian_gain_desc, "$1", math.min(var8, var1.guardian_gain[2]))
	elseif var1.type == 2 then
		var5 = var1.guardian_gain_desc
	end

	setText(arg0:findTF("Text", arg0.selectdCondition), var5)
	setActive(arg0.selectdSureBtn, var2 and not var3)
	setActive(arg0.selectdCancelBtn, var2 and var3)
	setActive(arg0.selectdCondition, not var2)
	arg0.selectViewUIList:align(#arg0.allIds)
end

function var0.UpdateView(arg0, arg1)
	if arg1 then
		arg0.activity = arg1
	end

	arg0.activeIds = _.map(arg0.activity.data2_list, function(arg0)
		return arg0
	end)
	arg0.unlcokIds = ActivityItemPool.GetAllGuardianIdsStatus(var0.BIND_LOTTERY_ACT_ID)
	arg0.allIds = ActivityItemPool.GetAllGuardianIds(var0.BIND_LOTTERY_ACT_ID)

	arg0:UpdateMainView()
	arg0:UpdateSelectViewUI()
end

function var0.OpenSelectView(arg0)
	setActive(arg0.mainViewTF, false)
	setActive(arg0.selectViewTF, true)
	arg0:UpdateSelectViewUI()
end

function var0.CloseSelectView(arg0)
	setActive(arg0.mainViewTF, true)
	setActive(arg0.selectViewTF, false)
	arg0:UpdateMainView()
end

function var0.OnDestroy(arg0)
	return
end

return var0
