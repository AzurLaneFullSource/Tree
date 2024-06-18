local var0_0 = class("ActivityBossPtAwardSubPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "ActivitybonusWindow_btnVer"
end

function var0_0.OnInit(arg0_2)
	arg0_2.scrollPanel = arg0_2._tf:Find("window/panel")
	arg0_2.UIlist = UIItemList.New(arg0_2._tf:Find("window/panel/list"), arg0_2._tf:Find("window/panel/list/item"))
	arg0_2.totalTxt = arg0_2._tf:Find("window/pt/Text"):GetComponent(typeof(Text))
	arg0_2.totalTitleTxt = arg0_2._tf:Find("window/pt/title"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2._tf:Find("window/top/btnBack")
	arg0_2.btn_banned = arg0_2._tf:Find("window/btn_banned")
	arg0_2.btn_get = arg0_2._tf:Find("window/btn_get")
	arg0_2.btn_got = arg0_2._tf:Find("window/btn_got")

	onButton(arg0_2, arg0_2._tf:Find("bg_dark"), function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.btn_get, function()
		local var0_5, var1_5 = arg0_2.ptData:GetResProgress()

		arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.ptData:GetId(),
			arg1 = var1_5
		})
	end, SFX_PANEL)
end

function var0_0.UpdateView(arg0_6, arg1_6)
	arg0_6.ptData = arg1_6

	local var0_6 = arg1_6.dropList
	local var1_6 = arg1_6.targets
	local var2_6 = arg1_6.level
	local var3_6 = arg1_6.count
	local var4_6 = arg1_6.resId
	local var5_6 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var4_6
	}):getName()

	if arg1_6.type == 2 then
		arg0_6.resTitle, arg0_6.cntTitle = i18n("pt_count", i18n("pt_cosume", var5_6)), i18n("pt_total_count", i18n("pt_cosume", var5_6))
	else
		arg0_6.resTitle, arg0_6.cntTitle = i18n("pt_count", var5_6), i18n("pt_total_count", var5_6)
	end

	local var6_6 = arg0_6.ptData:CanGetAward()
	local var7_6 = arg0_6.ptData:GetBossProgress()

	setActive(arg0_6.btn_get, var6_6)
	setActive(arg0_6.btn_banned, not var6_6)
	arg0_6:UpdateList(var0_6, var1_6, var2_6, var7_6)
	Canvas.ForceUpdateCanvases()
end

function var0_0.UpdateList(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	assert(#arg1_7 == #arg2_7)
	arg0_7.UIlist:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 ~= UIItemList.EventUpdate then
			return
		end

		local var0_8 = arg1_7[arg1_8 + 1]
		local var1_8 = arg2_7[arg1_8 + 1]

		setText(arg2_8:Find("title/Text"), "PHASE " .. arg1_8 + 1)
		setText(arg2_8:Find("target/Text"), var1_8)
		setText(arg2_8:Find("target/title"), arg0_7.resTitle)

		local var2_8 = {
			type = var0_8[1],
			id = var0_8[2],
			count = var0_8[3]
		}

		updateDrop(arg2_8:Find("award"), var2_8, {
			hideName = true
		})
		onButton(arg0_7, arg2_8:Find("award"), function()
			arg0_7:emit(BaseUI.ON_DROP, var2_8)
		end, SFX_PANEL)
		setActive(arg2_8:Find("award/mask"), arg1_8 + 1 <= arg3_7)

		local var3_8 = arg0_7.ptData.progress_target[arg1_8 + 1] < arg4_7

		setActive(arg2_8:Find("mask"), var3_8)

		if var3_8 then
			setText(arg2_8:Find("mask/Text"), i18n("world_boss_award_limit", math.round(arg0_7.ptData.progress_target[arg1_8 + 1] / 100)))
		end

		setActive(arg2_8:Find("award/mask/Image"), arg1_8 + 1 <= arg3_7)
	end)
	arg0_7.UIlist:align(#arg1_7)
	scrollTo(arg0_7.scrollPanel, 0, 1 - arg3_7 * 166 / (#arg2_7 * 166 + 20 - 570))
end

function var0_0.OnShow(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
end

function var0_0.OnHide(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf, arg0_11.viewParent._tf)
end

return var0_0
