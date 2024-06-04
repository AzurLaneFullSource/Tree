local var0 = class("ActivityBossPtAwardSubPanel", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "ActivitybonusWindow_btnVer"
end

function var0.OnInit(arg0)
	arg0.scrollPanel = arg0._tf:Find("window/panel")
	arg0.UIlist = UIItemList.New(arg0._tf:Find("window/panel/list"), arg0._tf:Find("window/panel/list/item"))
	arg0.totalTxt = arg0._tf:Find("window/pt/Text"):GetComponent(typeof(Text))
	arg0.totalTitleTxt = arg0._tf:Find("window/pt/title"):GetComponent(typeof(Text))
	arg0.closeBtn = arg0._tf:Find("window/top/btnBack")
	arg0.btn_banned = arg0._tf:Find("window/btn_banned")
	arg0.btn_get = arg0._tf:Find("window/btn_get")
	arg0.btn_got = arg0._tf:Find("window/btn_got")

	onButton(arg0, arg0._tf:Find("bg_dark"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.btn_get, function()
		local var0, var1 = arg0.ptData:GetResProgress()

		arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = arg0.ptData:GetId(),
			arg1 = var1
		})
	end, SFX_PANEL)
end

function var0.UpdateView(arg0, arg1)
	arg0.ptData = arg1

	local var0 = arg1.dropList
	local var1 = arg1.targets
	local var2 = arg1.level
	local var3 = arg1.count
	local var4 = arg1.resId
	local var5 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var4
	}):getName()

	if arg1.type == 2 then
		arg0.resTitle, arg0.cntTitle = i18n("pt_count", i18n("pt_cosume", var5)), i18n("pt_total_count", i18n("pt_cosume", var5))
	else
		arg0.resTitle, arg0.cntTitle = i18n("pt_count", var5), i18n("pt_total_count", var5)
	end

	local var6 = arg0.ptData:CanGetAward()
	local var7 = arg0.ptData:GetBossProgress()

	setActive(arg0.btn_get, var6)
	setActive(arg0.btn_banned, not var6)
	arg0:UpdateList(var0, var1, var2, var7)
	Canvas.ForceUpdateCanvases()
end

function var0.UpdateList(arg0, arg1, arg2, arg3, arg4)
	assert(#arg1 == #arg2)
	arg0.UIlist:make(function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = arg1[arg1 + 1]
		local var1 = arg2[arg1 + 1]

		setText(arg2:Find("title/Text"), "PHASE " .. arg1 + 1)
		setText(arg2:Find("target/Text"), var1)
		setText(arg2:Find("target/title"), arg0.resTitle)

		local var2 = {
			type = var0[1],
			id = var0[2],
			count = var0[3]
		}

		updateDrop(arg2:Find("award"), var2, {
			hideName = true
		})
		onButton(arg0, arg2:Find("award"), function()
			arg0:emit(BaseUI.ON_DROP, var2)
		end, SFX_PANEL)
		setActive(arg2:Find("award/mask"), arg1 + 1 <= arg3)

		local var3 = arg0.ptData.progress_target[arg1 + 1] < arg4

		setActive(arg2:Find("mask"), var3)

		if var3 then
			setText(arg2:Find("mask/Text"), i18n("world_boss_award_limit", math.round(arg0.ptData.progress_target[arg1 + 1] / 100)))
		end

		setActive(arg2:Find("award/mask/Image"), arg1 + 1 <= arg3)
	end)
	arg0.UIlist:align(#arg1)
	scrollTo(arg0.scrollPanel, 0, 1 - arg3 * 166 / (#arg2 * 166 + 20 - 570))
end

function var0.OnShow(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.OnHide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.viewParent._tf)
end

return var0
