local var0_0 = class("TerminalGuardianPage", import("view.base.BaseSubView"))

var0_0.BIND_LOTTERY_ACT_ID = ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID
var0_0.config = pg.guardian_template
var0_0.GUARDIAN_SELECT_CNT = 4

function var0_0.getUIName(arg0_1)
	return "TerminalGuardianPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2._tf.name = tostring(OtherworldTerminalLayer.PAGE_GUARDIAN)
	arg0_2.mainViewTF = arg0_2:findTF("frame/view")
	arg0_2.mainViewUIList = UIItemList.New(arg0_2:findTF("content", arg0_2.mainViewTF), arg0_2:findTF("content/tpl", arg0_2.mainViewTF))
	arg0_2.selectViewTF = arg0_2:findTF("frame/select_view")
	arg0_2.selectBackBtn = arg0_2:findTF("top/back_btn", arg0_2.selectViewTF)

	setText(arg0_2:findTF("top/Text", arg0_2.selectViewTF), i18n("guardian_select_title"))

	arg0_2.selectMainTF = arg0_2:findTF("left", arg0_2.selectViewTF)
	arg0_2.selectdIcon = arg0_2:findTF("icon_bg/Image", arg0_2.selectMainTF)
	arg0_2.selectdUnknown = arg0_2:findTF("icon_bg/unknown", arg0_2.selectMainTF)
	arg0_2.selectdName = arg0_2:findTF("name", arg0_2.selectMainTF)
	arg0_2.selectdDesc = arg0_2:findTF("desc/content/Text", arg0_2.selectMainTF)
	arg0_2.selectdSureBtn = arg0_2:findTF("sure_btn", arg0_2.selectMainTF)

	setText(arg0_2:findTF("Text", arg0_2.selectdSureBtn), i18n("guardian_sure_btn"))

	arg0_2.selectdCancelBtn = arg0_2:findTF("cancel_btn", arg0_2.selectMainTF)

	setText(arg0_2:findTF("Text", arg0_2.selectdCancelBtn), i18n("guardian_cancel_btn"))

	arg0_2.selectdCondition = arg0_2:findTF("condition", arg0_2.selectMainTF)
	arg0_2.selectViewUIList = UIItemList.New(arg0_2:findTF("right/content", arg0_2.selectViewTF), arg0_2:findTF("right/content/tpl", arg0_2.selectViewTF))

	setText(arg0_2:findTF("right/content/tpl/active/Text", arg0_2.selectViewTF), i18n("guardian_active_tip"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.activity = getProxy(ActivityProxy):getActivityById(var0_0.BIND_LOTTERY_ACT_ID)

	assert(arg0_3.activity, "not exist bind lottery act, id" .. var0_0.BIND_LOTTERY_ACT_ID)
	onButton(arg0_3, arg0_3.selectBackBtn, function()
		arg0_3:CloseSelectView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.selectdSureBtn, function()
		if #arg0_3.activeIds >= var0_0.GUARDIAN_SELECT_CNT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guardian_sure_limit_tip"))

			return
		end

		table.insert(arg0_3.activeIds, arg0_3.selectedId)
		arg0_3:ChangeActiveIds()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.selectdCancelBtn, function()
		table.removebyvalue(arg0_3.activeIds, arg0_3.selectedId)
		arg0_3:ChangeActiveIds()
	end, SFX_PANEL)
	arg0_3:InitMainViewUI()
	arg0_3:InitSelectViewUI()
	arg0_3:UpdateView()
	arg0_3:CloseSelectView()
end

function var0_0.ChangeActiveIds(arg0_7)
	arg0_7:emit(OtherworldTerminalMediator.ON_BUFF_LIST_CHANGE, {
		actId = var0_0.BIND_LOTTERY_ACT_ID,
		ids = arg0_7.activeIds
	})
end

function var0_0.InitMainViewUI(arg0_8)
	arg0_8.mainViewUIList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_8.activeIds[arg1_9 + 1]
			local var1_9 = var0_9 ~= nil

			setActive(arg0_8:findTF("content", arg2_9), var1_9)
			setActive(arg0_8:findTF("empty", arg2_9), not var1_9)

			if var1_9 then
				local var2_9 = var0_0.config[var0_9]

				setText(arg0_8:findTF("content/name", arg2_9), var2_9.guardian_name)
				setText(arg0_8:findTF("content/desc/content/Text", arg2_9), var2_9.guardian_desc)

				local var3_9 = arg0_8:findTF("content/icon_mask/Image", arg2_9)

				GetImageSpriteFromAtlasAsync("shipyardicon/" .. var2_9.guardian_painting, "", var3_9, false)
			end

			onButton(arg0_8, arg2_9, function()
				arg0_8.selectedId = var0_9 or underscore.detect(arg0_8.allIds, function(arg0_11)
					return not table.contains(arg0_8.activeIds, arg0_11)
				end)

				arg0_8:OpenSelectView()
			end, SFX_PANEL)
		end
	end)
end

function var0_0.UpdateMainView(arg0_12)
	arg0_12.mainViewUIList:align(var0_0.GUARDIAN_SELECT_CNT)
end

function var0_0.InitSelectViewUI(arg0_13)
	arg0_13.selectViewUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			local var0_14 = arg0_13.allIds[arg1_14 + 1]
			local var1_14 = var0_0.config[var0_14]
			local var2_14 = arg0_13:findTF("icon_mask/Image", arg2_14)

			GetImageSpriteFromAtlasAsync("shipyardicon/" .. var1_14.guardian_painting, "", var2_14, true)
			onButton(arg0_13, arg2_14, function()
				arg0_13.selectedId = var0_14

				arg0_13:UpdateSelectViewUI()
			end, SFX_PANEL)
		elseif arg0_14 == UIItemList.EventUpdate then
			local var3_14 = arg0_13.allIds[arg1_14 + 1]
			local var4_14 = var0_0.config[var3_14]
			local var5_14 = table.contains(arg0_13.unlcokIds, var3_14)
			local var6_14 = table.contains(arg0_13.activeIds, var3_14)
			local var7_14 = var4_14.type == 2 and not var5_14

			setActive(arg0_13:findTF("icon_mask/Image", arg2_14), not var7_14)
			setActive(arg0_13:findTF("unknown", arg2_14), var7_14)
			setActive(arg0_13:findTF("lock", arg2_14), not var5_14 and not var7_14)
			setActive(arg0_13:findTF("active", arg2_14), var6_14)
			setActive(arg0_13:findTF("selected", arg2_14), var3_14 == arg0_13.selectedId)
		end
	end)
end

function var0_0.UpdateSelectViewUI(arg0_16)
	local var0_16 = arg0_16.selectedId or arg0_16.allIds[1]
	local var1_16 = var0_0.config[var0_16]
	local var2_16 = table.contains(arg0_16.unlcokIds, var0_16)
	local var3_16 = table.contains(arg0_16.activeIds, var0_16)
	local var4_16 = var1_16.type == 2 and not var2_16

	GetImageSpriteFromAtlasAsync("shipyardicon/" .. var1_16.guardian_painting, "", arg0_16.selectdIcon, true)
	setActive(arg0_16.selectdIcon, not var4_16)
	setActive(arg0_16.selectdUnknown, var4_16)
	setText(arg0_16.selectdName, var4_16 and "???" or var1_16.guardian_name)
	setText(arg0_16.selectdDesc, var4_16 and "???" or var1_16.guardian_desc)

	local var5_16 = ""

	if var1_16.type == 1 then
		local var6_16, var7_16 = ActivityItemPool.GetGuardianLastCount(var0_0.BIND_LOTTERY_ACT_ID, var0_16)
		local var8_16 = var1_16.guardian_gain[2] - var7_16

		var5_16 = string.gsub(var1_16.guardian_gain_desc, "$1", math.min(var8_16, var1_16.guardian_gain[2]))
	elseif var1_16.type == 2 then
		var5_16 = var1_16.guardian_gain_desc
	end

	setText(arg0_16:findTF("Text", arg0_16.selectdCondition), var5_16)
	setActive(arg0_16.selectdSureBtn, var2_16 and not var3_16)
	setActive(arg0_16.selectdCancelBtn, var2_16 and var3_16)
	setActive(arg0_16.selectdCondition, not var2_16)
	arg0_16.selectViewUIList:align(#arg0_16.allIds)
end

function var0_0.UpdateView(arg0_17, arg1_17)
	if arg1_17 then
		arg0_17.activity = arg1_17
	end

	arg0_17.activeIds = _.map(arg0_17.activity.data2_list, function(arg0_18)
		return arg0_18
	end)
	arg0_17.unlcokIds = ActivityItemPool.GetAllGuardianIdsStatus(var0_0.BIND_LOTTERY_ACT_ID)
	arg0_17.allIds = ActivityItemPool.GetAllGuardianIds(var0_0.BIND_LOTTERY_ACT_ID)

	arg0_17:UpdateMainView()
	arg0_17:UpdateSelectViewUI()
end

function var0_0.OpenSelectView(arg0_19)
	setActive(arg0_19.mainViewTF, false)
	setActive(arg0_19.selectViewTF, true)
	arg0_19:UpdateSelectViewUI()
end

function var0_0.CloseSelectView(arg0_20)
	setActive(arg0_20.mainViewTF, true)
	setActive(arg0_20.selectViewTF, false)
	arg0_20:UpdateMainView()
end

function var0_0.OnDestroy(arg0_21)
	return
end

return var0_0
