local var0 = class("EducateUnlockTipLayer", import("..base.EducateBaseUI"))

var0.UNLOCK_TYPE_SYSTEM = 1
var0.UNLOCK_TYPE_SITE = 2
var0.UNLOCK_TYPE_PLAN = 3
var0.UNLOCK_NEW_SECRETARY = 4

function var0.getUIName(arg0)
	return "EducateUnlockTip"
end

function var0.init(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	arg0._tipTF = arg0._tf:Find("anim_root/tip")
	arg0.contentTF = arg0._tipTF:Find("tip_bg/layout/title/name")

	setText(arg0._tipTF:Find("tip_bg/layout/title/unlock"), i18n("child_unlock_tip"))
end

function var0.didEnter(arg0)
	arg0:setContent()
end

function var0.setContent(arg0)
	local var0 = ""

	switch(arg0.contextData.type, {
		[var0.UNLOCK_TYPE_SYSTEM] = function()
			var0 = EducateTipHelper.system_tip_list[arg0.contextData.single]
		end,
		[var0.UNLOCK_TYPE_SITE] = function()
			for iter0, iter1 in ipairs(arg0.contextData.list) do
				var0 = var0 .. pg.child_site[iter1].name .. " "
			end
		end,
		[var0.UNLOCK_TYPE_PLAN] = function()
			for iter0, iter1 in ipairs(arg0.contextData.list) do
				var0 = var0 .. pg.child_plan[iter1].name .. " "
			end
		end,
		[var0.UNLOCK_NEW_SECRETARY] = function()
			var0 = i18n("child_unlock_new_secretary")
		end
	})
	setText(arg0.contentTF, shortenString(var0, 15))
end

function var0.saveTipRecord(arg0)
	switch(arg0.contextData.type, {
		[var0.UNLOCK_TYPE_SYSTEM] = function()
			EducateTipHelper.SaveSystemUnlockTip(arg0.contextData.single)
		end,
		[var0.UNLOCK_TYPE_SITE] = function()
			for iter0, iter1 in ipairs(arg0.contextData.list) do
				EducateTipHelper.SaveSiteUnlockTipId(iter1)
			end
		end,
		[var0.UNLOCK_TYPE_PLAN] = function()
			for iter0, iter1 in ipairs(arg0.contextData.list) do
				EducateTipHelper.SavePlanUnlockTipId(iter1)
			end
		end
	})
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	arg0:saveTipRecord()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
