local var0_0 = class("SecretsAbyssCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "SecretsAbyssCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)
	quickPlayAnimation(arg0_2._tf:Find("adapt/TopPage/top"), "Anim_SecretsAbyssCoreActivityUI_top_In")
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("masaina_main_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text_1"), i18n("masaina_main_title_en"))

	local var0_2

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
				setText(arg0_2:findTF("off/name", arg2_3), i18n("masaina_main_sheet" .. var0_3:getConfig("is_show")))
				setText(arg0_2:findTF("on/name", arg2_3), i18n("masaina_main_sheet" .. var0_3:getConfig("is_show")))

				if arg0_2.pageDic[var0_3.id] ~= nil then
					setActive(arg0_2:findTF("tip", arg2_3), var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						if arg0_5 then
							arg0_2:selectActivity(var0_3)

							if var0_2 ~= var0_3.id then
								quickPlayAnimation(arg2_3, "Anim_SecretsAbyssCoreActivityUI_tabs_on_In")
							end

							var0_2 = var0_3.id
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
	onButton(arg0_2, arg0_2._tf:Find("adapt/TopPage/top/btn_back"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
end

function var0_0.UpdateAdapt(arg0_8)
	local var0_8 = 1.33333333333333
	local var1_8 = 2.16666666666667
	local var2_8 = pg.CameraFixMgr.GetInstance()
	local var3_8 = var2_8.currentWidth / var2_8.currentHeight
	local var4_8 = math.clamp(var3_8, var0_8, var1_8)

	arg0_8._tf:GetComponent(typeof(AspectRatioFitter)).aspectRatio = var4_8

	setSizeDelta(arg0_8._tf:Find("adapt"), {
		x = 0,
		y = 0
	})

	local var5_8 = NotchAdapt.CheckNotchRatio == math.clamp(NotchAdapt.CheckNotchRatio, var0_8, var1_8)

	SetComponentEnabled(arg0_8._tf:Find("adapt"), "NotchAdapt", var5_8)
end

function var0_0.willExit(arg0_9)
	var0_0.super.willExit(arg0_9)

	if arg0_9.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_9.camEventId)

		arg0_9.camEventId = nil
	end
end

return var0_0
