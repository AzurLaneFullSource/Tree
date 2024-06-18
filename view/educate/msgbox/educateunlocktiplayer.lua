local var0_0 = class("EducateUnlockTipLayer", import("..base.EducateBaseUI"))

var0_0.UNLOCK_TYPE_SYSTEM = 1
var0_0.UNLOCK_TYPE_SITE = 2
var0_0.UNLOCK_TYPE_PLAN = 3
var0_0.UNLOCK_NEW_SECRETARY = 4

function var0_0.getUIName(arg0_1)
	return "EducateUnlockTip"
end

function var0_0.init(arg0_2)
	arg0_2.anim = arg0_2:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0_2._tipTF = arg0_2._tf:Find("anim_root/tip")
	arg0_2.contentTF = arg0_2._tipTF:Find("tip_bg/layout/title/name")

	setText(arg0_2._tipTF:Find("tip_bg/layout/title/unlock"), i18n("child_unlock_tip"))
end

function var0_0.didEnter(arg0_4)
	arg0_4:setContent()
end

function var0_0.setContent(arg0_5)
	local var0_5 = ""

	switch(arg0_5.contextData.type, {
		[var0_0.UNLOCK_TYPE_SYSTEM] = function()
			var0_5 = EducateTipHelper.system_tip_list[arg0_5.contextData.single]
		end,
		[var0_0.UNLOCK_TYPE_SITE] = function()
			for iter0_7, iter1_7 in ipairs(arg0_5.contextData.list) do
				var0_5 = var0_5 .. pg.child_site[iter1_7].name .. " "
			end
		end,
		[var0_0.UNLOCK_TYPE_PLAN] = function()
			for iter0_8, iter1_8 in ipairs(arg0_5.contextData.list) do
				var0_5 = var0_5 .. pg.child_plan[iter1_8].name .. " "
			end
		end,
		[var0_0.UNLOCK_NEW_SECRETARY] = function()
			var0_5 = i18n("child_unlock_new_secretary")
		end
	})
	setText(arg0_5.contentTF, shortenString(var0_5, 15))
end

function var0_0.saveTipRecord(arg0_10)
	switch(arg0_10.contextData.type, {
		[var0_0.UNLOCK_TYPE_SYSTEM] = function()
			EducateTipHelper.SaveSystemUnlockTip(arg0_10.contextData.single)
		end,
		[var0_0.UNLOCK_TYPE_SITE] = function()
			for iter0_12, iter1_12 in ipairs(arg0_10.contextData.list) do
				EducateTipHelper.SaveSiteUnlockTipId(iter1_12)
			end
		end,
		[var0_0.UNLOCK_TYPE_PLAN] = function()
			for iter0_13, iter1_13 in ipairs(arg0_10.contextData.list) do
				EducateTipHelper.SavePlanUnlockTipId(iter1_13)
			end
		end
	})
end

function var0_0.onBackPressed(arg0_14)
	return
end

function var0_0.willExit(arg0_15)
	arg0_15:saveTipRecord()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_15._tf)

	if arg0_15.contextData.onExit then
		arg0_15.contextData.onExit()
	end
end

return var0_0
