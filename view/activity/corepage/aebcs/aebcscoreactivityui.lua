local var0_0 = class("AEBCSCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "AEBCSCoreActivityUI"
end

local var1_0 = 50152

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	local var0_2, var1_2 = pg.TimeMgr.GetInstance():inTime(pg.activity_template[var1_0].time)
	local var2_2

	if var1_2 then
		local var3_2 = pg.TimeMgr.GetInstance():Table2ServerTime(var1_2)

		var2_2 = arg0_2:skinCommdityTimeStamp(var3_2)
	end

	if var2_2 ~= nil then
		setText(arg0_2._tf:Find("adapt/top/btn_home/text_tip/Text (Legacy)"), var2_2)
	end

	local var4_2

	arg0_2.tabsList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = underscore.detect(arg0_2.activities, function(arg0_4)
				return tostring(arg0_4:getConfig("is_show")) == arg2_3.name
			end)

			if not var0_3 or var0_3:isEnd() then
				setActive(arg2_3, false)
			elseif not arg0_2.pageDic[var0_3.id] then
				warning(string.format("without page in act:", var0_3.id))
			else
				arg0_2:ONToggleName(arg2_3, var0_3)

				local var1_3 = arg0_2.pageDic[var0_3.id]

				if var1_3 ~= nil then
					local var2_3 = arg2_3:Find("tip")
					local var3_3 = var1_3:IsShowReminder()

					if var3_3 == nil then
						setActive(var2_3, var0_3:readyToAchieve())
					else
						setActive(var2_3, var3_3)
					end

					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							arg0_2:selectActivity(var0_3)

							if var4_2 ~= var0_3.id then
								-- block empty
							end

							var4_2 = var0_3.id
						end
					end, SFX_PANEL)
				end
			end
		end
	end)

	arg0_2.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_6, arg1_6)
		arg0_2:UpdateAdapt()
	end)

	arg0_2:UpdateAdapt()
end

function var0_0.UpdateAdapt(arg0_7)
	local var0_7 = 1.33333333333333
	local var1_7 = 2.33333333333333
	local var2_7 = pg.CameraFixMgr.GetInstance()
	local var3_7 = var2_7.currentWidth / var2_7.currentHeight
	local var4_7 = math.clamp(var3_7, var0_7, var1_7)

	arg0_7._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_7

	setSizeDelta(arg0_7._tf:Find("adapt"), {
		x = 0,
		y = 0
	})

	local var5_7 = NotchAdapt.CheckNotchRatio == math.clamp(NotchAdapt.CheckNotchRatio, var0_7, var1_7)

	SetComponentEnabled(arg0_7._tf:Find("adapt"), "NotchAdapt", var5_7)
end

function var0_0.ONToggleName(arg0_8, arg1_8, arg2_8)
	setText(arg1_8:Find("off/name"), i18n("danmachi_main_sheet" .. arg2_8:getConfig("is_show")))
	setText(arg1_8:Find("on/name"), i18n("danmachi_main_sheet" .. arg2_8:getConfig("is_show")))
end

function var0_0.didEnter(arg0_9)
	var0_0.super.didEnter(arg0_9)

	if not arg0_9.contextData.activeScenario then
		arg0_9._tf:GetComponent(typeof(Animation)).enabled = true
	end

	onButton(arg0_9, arg0_9.btnBack, function()
		local var0_10 = arg0_9.pageDic[arg0_9.activity.id]

		if var0_10:IsShowingPopWindow() then
			var0_10:ClosePopWindow()
		else
			arg0_9:emit(var0_0.ON_BACK)
		end
	end, SOUND_BACK)
end

function var0_0.skinCommdityTimeStamp(arg0_11, arg1_11)
	local var0_11 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_11 = math.max(arg1_11 - var0_11, 0)
	local var2_11 = math.floor(var1_11 / 86400)

	if var2_11 > 0 then
		return i18n("limit_skin_time_day", var2_11)
	else
		return i18n("masaina_main_other_tag")
	end
end

function var0_0.ActiveScenarioLayer(arg0_12, arg1_12)
	setActive(arg0_12._tf:Find("left_mask"), not arg1_12)
	setActive(arg0_12._tf:Find("adapt/tabs"), not arg1_12)
	setActive(arg0_12._tf:Find("adapt/decorate"), not arg1_12)
	setActive(arg0_12._tf:Find("adapt/btn_skin"), not arg1_12)

	arg0_12.contextData.activeScenario = arg1_12
end

function var0_0.willExit(arg0_13)
	var0_0.super.willExit(arg0_13)

	if arg0_13.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_13.camEventId)

		arg0_13.camEventId = nil
	end

	for iter0_13, iter1_13 in pairs(arg0_13.pageDic) do
		if iter1_13.loader then
			iter1_13.loader:Clear()
		end
	end
end

return var0_0
