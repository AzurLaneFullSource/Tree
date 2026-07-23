local var0_0 = class("EscapeManorCoreActivityUI", import("view.activity.CorePage.Helena.HelenaCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "EscapeManorCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.topPage = arg0_2._tf:Find("adapt/TopPage")

	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))

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
				arg0_2:OnToggleName(arg2_3, var0_3)

				if arg0_2.pageDic[var0_3.id] ~= nil then
					setActive(arg2_3:Find("tip"), var0_3:readyToAchieve())
					onToggle(arg0_2, arg2_3, function(arg0_5)
						local var0_5 = arg2_3:Find("on")

						if arg0_5 then
							if var0_2 ~= var0_3.id then
								arg0_2:selectActivity(var0_3)
								arg0_2:OnAnimations(arg2_3, var0_3)
							end

							var0_2 = var0_3.id
						end

						setActive(var0_5, arg0_5)
					end, SFX_PANEL)
				end
			end
		end
	end)
	onButton(arg0_2, arg0_2._tf:Find("adapt/TopPage/top/btn_back"), function()
		arg0_2:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
end

function var0_0.verifyTabs(arg0_7, arg1_7)
	local var0_7 = arg0_7.activities[arg0_7:getActivityIndex(arg1_7) or arg0_7:getActivityIndex(arg0_7:GetActiveActivity()) or 1]

	if var0_7 == nil then
		return
	end

	local var1_7 = var0_7:getConfig("is_show")
	local var2_7 = arg0_7.tabs:Find(tostring(var1_7))

	triggerToggle(var2_7, true)
end

return var0_0
