local var0_0 = class("ALYCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))
local var1_0 = 50055

function var0_0.getUIName(arg0_1)
	return "ALYCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	local var0_2, var1_2 = pg.TimeMgr.GetInstance():inTime(pg.activity_template[var1_0].time)
	local var2_2

	if var1_2 then
		local var3_2 = pg.TimeMgr.GetInstance():Table2ServerTime(var1_2)

		var2_2 = var0_0:skinCommdityTimeStamps(var3_2)
	end

	setText(arg0_2._tf:Find("adapt/top/btn_home/text_tip/Text (Legacy)"), i18n("yumia_main_tip_4", var2_2))
	arg0_2:Reset()
	arg0_2.tabsList:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = underscore.detect(arg0_2.activities, function(arg0_4)
				return tostring(arg0_4:getConfig("is_show")) == arg2_3.name
			end)

			if not var0_3 or var0_3:isEnd() then
				setActive(arg2_3, false)
			elseif not arg0_2.pageDic[var0_3.id] then
				warning(string.format("without page in act:", var0_3.id))
			else
				local var1_3 = arg0_2.pageDic[var0_3.id]

				if var0_3.id == 50063 or var0_3.id == 50058 then
					local var2_3 = arg0_2:findTF("tip", arg2_3)

					setActive(var2_3, var0_3:readyToAchieve())
				else
					setActive(arg0_2:findTF("tip", arg2_3), false)
				end

				onToggle(arg0_2, arg2_3, function(arg0_5)
					warning(arg1_3, arg0_5)

					if arg0_5 then
						if arg1_3 == 3 then
							setActive(arg0_2._tf:Find("Image/VX"), false)
						else
							setActive(arg0_2._tf:Find("Image/VX"), true)
						end

						arg0_2:selectActivity(var0_3)
						quickPlayAnimation(arg0_2:findTF("on", arg2_3), "Anim_ALYCoreActivityUI_tabs_selected")
					end
				end, SFX_PANEL)
			end
		end
	end)

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_6, arg1_6)
		arg0_2:UpdateAdapt()
	end)

	arg0_2:UpdateAdapt()

	arg0_2.anim_1 = arg0_2._tf:Find("adapt/tabs/1/off"):GetComponent(typeof(Animation))
	arg0_2.anim_2 = arg0_2._tf:Find("adapt/tabs/2/off"):GetComponent(typeof(Animation))
	arg0_2.anim_3 = arg0_2._tf:Find("adapt/tabs/3/off"):GetComponent(typeof(Animation))
	arg0_2.anim_4 = arg0_2._tf:Find("adapt/tabs/4/off"):GetComponent(typeof(Animation))
	arg0_2.anim_5 = arg0_2._tf:Find("adapt/tabs/5/off"):GetComponent(typeof(Animation))
	arg0_2.anim_tf_Event = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.anim_tf_Event:SetStartEvent(function()
		setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/1"), 1)

		for iter0_7 = 4, 5 do
			onDelayTick(function()
				if iter0_7 == 4 then
					setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/3"), 1)
					setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/4"), 1)
				elseif iter0_7 == 5 then
					setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/2"), 1)
					setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/5"), 1)
				end
			end, 0.08 * (iter0_7 - 3))
		end
	end)

	arg0_2.anim_1_Event = arg0_2._tf:Find("adapt/tabs/1/off"):GetComponent(typeof(DftAniEvent))

	arg0_2.anim_1_Event:SetStartEvent(function()
		setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/3"), 1)
		setCanvasGroupAlpha(arg0_2._tf:Find("adapt/tabs/4"), 1)
	end)
end

function var0_0.didEnter(arg0_10)
	var0_0.super.didEnter(arg0_10)
end

function var0_0.UpdateAdapt(arg0_11)
	local var0_11 = 1.33333333333333
	local var1_11 = 2.16666666666667
	local var2_11 = pg.CameraFixMgr.GetInstance()
	local var3_11 = var2_11.currentWidth / var2_11.currentHeight
	local var4_11 = math.clamp(var3_11, var0_11, var1_11)

	arg0_11._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_11

	setSizeDelta(arg0_11._tf:Find("adapt"), {
		x = 0,
		y = 0
	})

	local var5_11 = NotchAdapt.CheckNotchRatio == math.clamp(NotchAdapt.CheckNotchRatio, var0_11, var1_11)

	SetComponentEnabled(arg0_11._tf:Find("adapt"), "NotchAdapt", var5_11)
end

function var0_0.Reset(arg0_12)
	for iter0_12 = 1, 5 do
		setText(arg0_12._tf:Find("adapt/tabs/" .. iter0_12 .. "/off/Label/name_bg/name"), i18n("yumia_main_tip_" .. iter0_12 + 4))
		setText(arg0_12._tf:Find("adapt/tabs/" .. iter0_12 .. "/on/Label/name_bg/name"), i18n("yumia_main_tip_" .. iter0_12 + 4))
	end
end

function var0_0.skinCommdityTimeStamps(arg0_13, arg1_13)
	local var0_13 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_13 = math.max(arg1_13 - var0_13, 0)
	local var2_13 = math.floor(var1_13 / 86400)

	if var2_13 > 0 then
		return var2_13
	elseif var2_13 <= 0 then
		return 0
	end
end

function var0_0.willExit(arg0_14)
	var0_0.super.willExit(arg0_14)

	if arg0_14.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_14.camEventId)

		arg0_14.camEventId = nil
	end
end

return var0_0
