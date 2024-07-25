local var0_0 = class("MonopolyCar2024PickPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MonopolyCar2024PickUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2:findTF("confirm")
	arg0_2.anim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2.anim:GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		var0_0.super.Hide(arg0_2)
	end)

	arg0_2.items = {
		arg0_2:findTF("list/1"),
		arg0_2:findTF("list/2"),
		arg0_2:findTF("list/3")
	}

	setText(arg0_2:findTF("title/Text"), i18n("MonopolyCar2024Game_pick_tip"))
	setText(arg0_2.confirmBtn:Find("Text"), i18n("MonopolyCar2024Game_sel_label"))
end

function var0_0.OnInit(arg0_4)
	arg0_4.selectedId = 0

	onButton(arg0_4, arg0_4.confirmBtn, function()
		if arg0_4.selectedId <= 0 then
			return
		end

		if arg0_4.callback then
			arg0_4.callback(arg0_4.selectedId)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateList(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.items) do
		local var0_6 = table.contains(arg0_6.banList, iter0_6)

		onToggle(arg0_6, iter1_6, function(arg0_7)
			if arg0_7 then
				arg0_6.selectedId = iter0_6
			end
		end, SFX_PANEL)
		setToggleEnabled(iter1_6, not var0_6)
		warning(iter0_6, var0_6)
		setActive(iter1_6:Find(iter0_6 .. "/active"), not var0_6)
		setActive(iter1_6:Find(iter0_6 .. "/coin"), arg0_6.banCount < 3 and not var0_6)
	end
end

function var0_0.Show(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	var0_0.super.Show(arg0_8)

	arg0_8.activityId = arg1_8
	arg0_8.banCount = #arg2_8

	if arg0_8.banCount >= 3 then
		arg0_8.banList = {}
	else
		arg0_8.banList = arg2_8
	end

	arg0_8.callback = arg4_8

	arg0_8:UpdateList()
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg0_8._tf, {})
	arg0_8.anim:Play("anim_monopolycar_pick_in")
	arg0_8:CheckAuto(arg3_8)
end

function var0_0.CheckAuto(arg0_9, arg1_9)
	if not arg1_9 then
		return
	end

	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.items) do
		if not table.contains(arg0_9.banList, iter0_9) then
			table.insert(var0_9, iter0_9)
		end
	end

	arg0_9.selectedId = var0_9[math.random(1, #var0_9)]

	if arg0_9.callback then
		arg0_9.callback(arg0_9.selectedId)
	end
end

function var0_0.Hide(arg0_10)
	arg0_10.anim:Play("anim_monopolycar_pick_out")

	for iter0_10, iter1_10 in ipairs(arg0_10.items) do
		triggerToggle(iter1_10, false)
	end

	arg0_10.selectedId = 0

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
